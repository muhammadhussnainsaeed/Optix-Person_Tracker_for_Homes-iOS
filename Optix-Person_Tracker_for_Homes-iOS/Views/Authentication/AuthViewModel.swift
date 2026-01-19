//
//  AuthViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 17/1/26.
//

import Foundation
import Combine
import SwiftUI

enum AuthRoute: Hashable {
    case signup
    case signupQuestion
    case forgetPassword
    case newPassword
}

class AuthViewModel: ObservableObject{
    
    @Published var navPath = NavigationPath()
    
    @Published var AuthServiceObject = AuthService()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var user: User? = nil
    var signupUserResponse: SignupUserResponse? = nil
    
    // Variables for the Signup
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var security_question: String = "What is your mother’s maiden name?"
    @Published var security_answer: String = ""
    
    func loginUser(username: String, password: String) async {
        
        // Update UI (Start Loading)
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            //Calling the service
            let user = try await withCheckedThrowingContinuation { continuation in
                AuthServiceObject.login(username: username, password: password) { result in
                    switch result {
                    case .success(let fetchedUser):
                        continuation.resume(returning: fetchedUser)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // Success! Update UI & Session
            await MainActor.run {
                self.user = user
                self.isLoading = false
                
                // Save the data to the Session Manager
                SessionManager.shared.saveAuthToken(token: user.token)
                SessionManager.shared.currentName = user.name
                SessionManager.shared.currentUsername = user.username
                SessionManager.shared.currentUserID = user.id
                SessionManager.shared.isLoggedIn = true
                
                print("Login Successful: \(user.id)")
            }
            
        } catch let apiError as APIError {
            
            // Handle SPECIFIC Backend Errors
            print("API Error: \(apiError.detail)")
            
            await MainActor.run {
                self.errorMessage = apiError.detail // e.g. "Incorrect password"
                self.isLoading = false
            }
            
        } catch {
            // Handle Generic Errors (Network offline, etc.)
            print("Generic Login Error: \(error.localizedDescription)")
            
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signupUser(name: String, username: String, password: String,security_question: String,security_answer: String) async {
        
        // Update UI (Start Loading)
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            //Calling the service
            let signupUserResponse = try await withCheckedThrowingContinuation { continuation in
                AuthServiceObject.signup(name: name, username: username, password: password, security_question: security_question, security_answer: security_answer) { result in
                    switch result {
                    case .success(let fetchedUser):
                        continuation.resume(returning: fetchedUser)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // Success! Update UI
            await MainActor.run {
                self.signupUserResponse = signupUserResponse
                self.isLoading = false
                
                print("Sigup Successful: \(signupUserResponse.username)")
            }
            
        } catch let apiError as APIError {
            
            // Handle SPECIFIC Backend Errors
            print("API Error: \(apiError.detail)")
            
            await MainActor.run {
                self.errorMessage = apiError.detail // e.g. "Incorrect password"
                self.isLoading = false
            }
            
        } catch {
            // Handle Generic Errors (Network offline, etc.)
            print("Generic Login Error: \(error.localizedDescription)")
            
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func resetUserPassword(username: String,security_question: String,security_answer: String, new_password: String) async {
        
        // Update UI (Start Loading)
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            //Calling the service
            let resetPasswordUserResponse = try await withCheckedThrowingContinuation { continuation in
                AuthServiceObject.resetUserPassword(username: username, security_question: security_question, security_answer: security_answer, new_password: new_password) { result in
                    switch result {
                    case .success(let fetchedUser):
                        continuation.resume(returning: fetchedUser)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // Success! Update UI
            await MainActor.run {
                self.signupUserResponse = signupUserResponse
                self.isLoading = false
                print("Reset Password Successful: \(resetPasswordUserResponse.username)")
            }
            
        } catch let apiError as APIError {
            
            // Handle SPECIFIC Backend Errors
            print("API Error: \(apiError.detail)")
            
            await MainActor.run {
                self.errorMessage = apiError.detail // e.g. "Incorrect password"
                self.isLoading = false
            }
            
        } catch {
            // Handle Generic Errors (Network offline, etc.)
            print("Generic Reset Password Error: \(error.localizedDescription)")
            
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
