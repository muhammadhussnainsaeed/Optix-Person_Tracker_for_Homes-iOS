//
//  NotificationManager.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 5/5/26.
//

import Foundation
import Combine
import SwiftUI

class NotificationManager: ObservableObject {
    @Published var currentAlert: AlertPacket? = nil
    @Published var showBanner: Bool = false
        
    private var webSocketTask: URLSessionWebSocketTask?
    private var loggedInUserId: String = "" // Start empty
        
        // Empty initializer
    init() {}
        
        // Call this from .onAppear
    func startListening(for userIdString: String) {
        // Prevent duplicate connections if .onAppear is called multiple times
        guard webSocketTask == nil else { return }
        
        self.loggedInUserId = userIdString
        self.connect()
    }
        
    private func connect() {
        let url = URL(string: "ws://192.168.0.101:8888/ws/alerts")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleIncomingText(text)
                case .data(let data):
                    self?.handleIncomingData(data)
                @unknown default: break
                }
                // Keep listening
                self?.receiveMessage()
                
            case .failure(let error):
                print("WebSocket Error: \(error)")
                // Reconnect after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self?.connect() }
            }
        }
    }
    
    private func handleIncomingText(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        handleIncomingData(data)
    }
    
    private func handleIncomingData(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let packet = try decoder.decode(AlertPacket.self, from: data)
            // Logic: Only show if user_id matches
            if packet.userId == loggedInUserId.lowercased() {
                print(packet.userId)
                print(loggedInUserId.lowercased())
                DispatchQueue.main.async {
                    self.triggerBanner(packet)
                }
            }
        } catch {
            print("Decoding Error: \(error)")
        }
    }
    
    private func triggerBanner(_ packet: AlertPacket) {
        self.currentAlert = packet
            withAnimation(.spring()) {
            self.showBanner = true
        }
        
        // Auto-hide after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeOut) {
                self.showBanner = false
            }
        }
    }
}
