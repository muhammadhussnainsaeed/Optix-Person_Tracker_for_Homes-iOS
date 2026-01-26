//
//  SessionManager.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 17/1/26.
//

import Foundation
import Combine
import SwiftUI

class SessionManager: ObservableObject {
    
    static let shared = SessionManager()
    
    // MARK: 1, Login Status
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn") {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    
    // MARK: 2, Username
    @Published var currentUsername: String = UserDefaults.standard.string(forKey: "username") ?? "" {
        didSet {
            UserDefaults.standard.set(currentUsername, forKey: "username")
        }
    }
    
    // MARK: 3, User ID
    // Default to nil (logged out) instead of an empty string
    @Published var currentUserID: UUID? = {
        // 1. Load string from defaults
        guard let str = UserDefaults.standard.string(forKey: "id") else { return nil }
        // 2. Convert to UUID
        return UUID(uuidString: str)
    }() {
        didSet {
            // 3. Save as string (or remove if nil)
            if let id = currentUserID {
                UserDefaults.standard.set(id.uuidString, forKey: "id")
            } else {
                UserDefaults.standard.removeObject(forKey: "id")
            }
        }
    }
    
    // MARK: 4, User Name
    @Published var currentName: String = UserDefaults.standard.string(forKey: "name") ?? "" {
        didSet {
            UserDefaults.standard.set(currentName, forKey: "name")
        }
    }
    
    // MARK: 5, The Token (Keychain Logic)
    func saveAuthToken(token: String) {
        let data = Data(token.utf8)
        KeychainHelper.standard.save(data, service: "optix.Optix-Person-Tracker-for-Homes-iOS", account: "authToken")
        
        // This triggers the UI update because 'isLoggedIn' is @Published
        self.isLoggedIn = true
    }
    
    func getAuthToken() -> String? {
        guard let data = KeychainHelper.standard.read(service: "optix.Optix-Person-Tracker-for-Homes-iOS", account: "authToken") else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func logout() {
        // Clear Keychain
        KeychainHelper.standard.delete(service: "optix.Optix-Person-Tracker-for-Homes-iOS", account: "authToken")
        
        // Reset UI (Saves 'false' to UserDefaults automatically via didSet)
        self.isLoggedIn = false
        self.currentName = ""
        self.currentUsername = ""
        self.currentUserID = nil
    }
}

