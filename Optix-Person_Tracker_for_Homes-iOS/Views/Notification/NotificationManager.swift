import Foundation
import Combine
import SwiftUI

@MainActor
class NotificationManager: ObservableObject {
    
    @Published var currentAlert: AlertPacket? = nil
    @Published var showBanner: Bool = false
        
    private var webSocketTask: URLSessionWebSocketTask?
    private var loggedInUserId: String = ""
        
    init() {}
        
    func startListening(for userIdString: String) {
        if !SessionManager.shared.getNotification {
            print("Notifications are off")
            return
        }
        guard webSocketTask == nil else { return }
        
        self.loggedInUserId = userIdString
        self.connect()
    }
    
    // MARK: Add a way to disconnect
    func stopListening() {
        print("Stopping WebSocket connection")
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
        
    private func connect() {
        let url = URL(string: "ws://192.168.31.205:8888/ws/alerts")!
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
                
                // Keep listening only if the task still exists
                if self?.webSocketTask != nil {
                    self?.receiveMessage()
                }
                
            case .failure(let error):
                print("WebSocket Error: \(error)")
                
                // MARK: Prevent auto-reconnect if the user turned off the toggle
                if SessionManager.shared.getNotification {
                    print("Attempting to reconnect in 5 seconds...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self?.connect() }
                }
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
            
            if packet.userId == loggedInUserId.lowercased() {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeOut) {
                self.showBanner = false
            }
        }
    }
}
