//
//  SettingsViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 23/2/26.
//

import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    //@Published
    
    @Published var settingsServiceObject = SettingsService()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var updateNameReponse: UpdateNameResponse?
    @Published var updatePasswordResponse: UpdatePasswordResponse?
    @Published var updateSecurityQuestionResponse: UpdateSecurityQuestionResponse?
    
    // Update the name
    func updateName(name: String) async{
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                settingsServiceObject.updateName(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", name: name) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.updateNameReponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            SessionManager.shared.currentName = updateNameReponse?.name ?? "testing"
            print("Name has been updated")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
    
    // Update the password
    func updatePassword(oldPassword: String, newPassword: String) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                settingsServiceObject.updatePassword(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", oldPassword: oldPassword, newPassword: newPassword) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.updatePasswordResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            //SessionManager.shared.currentName = updateNameReponse?.name ?? "testing"
            print("Password has been updated")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
    
    // Update the
    func updateSecurityQuestionAnswer(password: String, securityQuestion: String, securityAnswer: String) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                settingsServiceObject.updateSecurityQuestion(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", password: password, securityQuestion: securityQuestion, securityAnswer: securityAnswer) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.updateSecurityQuestionResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
}
