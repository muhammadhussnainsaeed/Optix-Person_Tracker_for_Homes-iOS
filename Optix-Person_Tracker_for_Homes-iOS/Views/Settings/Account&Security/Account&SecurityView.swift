//
//  Account&SecurityView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/2/26.
//

import SwiftUI

//struct Account_SecurityView: View {
//    
//    // MARK: - UI State
//    @State private var isShowingAlertChangeName = false
//    @State private var isShowingAlertChangePassword = false
//    @State private var isShowingAlertChangeSecurityQnA = false
//    
//    // MARK: - Error State
//    @State private var conditionOfError = false
//    @State private var messageOfError = ""
//    @State private var errorAt = 0 // 1: Name, 2: Password, 3: Q&A
//    
//    // MARK: - Form Data
//    @State private var familyName = ""
//    @State private var oldPassword = ""
//    @State private var newPassword = ""
//    @State private var confirmPassword = ""
//    @State private var security_question = "What is your mother’s maiden name?"
//    @State private var security_answer = ""
//    
//    let securityQuestions = [
//        "What is your mother’s maiden name?",
//        "What was the name of your first pet?",
//        "In what city were you born?",
//        "What was the make of your first car?",
//        "What is the name of your favorite childhood teacher?"
//    ]
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 15) {
//                
//                // 1. Change Family Name Button
//                SettingsRowButton(title: "Change Family's name") {
//                    isShowingAlertChangeName = true
//                }
//                
//                // 2. Change Password Button
//                SettingsRowButton(title: "Change Password") {
//                    isShowingAlertChangePassword = true
//                }
//
//                // 3. Change Security Q&A Button
//                SettingsRowButton(title: "Change Security Q&A") {
//                    isShowingAlertChangeSecurityQnA = true
//                }
//                
//                Spacer()
//            }
//            .padding(.top, 20)
//            .navigationTitle("Account & Security")
//            .navigationBarTitleDisplayMode(.inline)
//            
//            // MARK: - Alerts
//            
//            // 1. Family Name Alert
//            .alert("Change Family's name", isPresented: $isShowingAlertChangeName) {
//                TextField("Enter Family's name", text: $familyName)
//                
//                Button("Cancel", role: .cancel) { clearFields() }
//                Button("Update") {
//                    if familyName.isEmpty {
//                        showError("Please fill up the required field.", source: 1)
//                        return
//                    }
//                    print("Updated name to: \(familyName)")
//                    clearFields()
//                }
//            } message: {
//                Text("Please enter the new family name.")
//            }
//            
//            // 2. Password Alert
//            .alert("Change Password", isPresented: $isShowingAlertChangePassword) {
//                SecureField("Current password", text: $oldPassword)
//                SecureField("New password", text: $newPassword)
//                SecureField("Confirm new password", text: $confirmPassword)
//                
//                Button("Cancel", role: .cancel) { clearFields() }
//                Button("Update", role: .destructive) {
//                    if oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
//                        showError("Please fill in all required fields.", source: 2)
//                        return
//                    }
//                    if !Validator.shared.isPasswordValid(newPassword) {
//                        showError("Password must be 8+ chars with at least one number and uppercase letter.", source: 2)
//                        return
//                    }
//                    if !Validator.shared.isPasswordConfirmationValid(password: newPassword, confirmPassword: confirmPassword) {
//                        showError("Passwords do not match.", source: 2)
//                        return
//                    }
//                    
//                    print("Password validation passed.")
//                    clearFields()
//                }
//            } message: {
//                Text("Please enter your current password and choose a new, secure password.")
//            }
//            
//            // 3. Security Q&A Alert
//            .alert("Change Security Q&A", isPresented: $isShowingAlertChangeSecurityQnA) {
//                SecureField("Current Password", text: $oldPassword)
//                
//                // NOTE: Pickers don't work in native alerts. Using a TextField instead.
//                TextField("Security Question", text: $security_question)
//                TextField("New Answer", text: $security_answer)
//                
//                Button("Cancel", role: .cancel) { clearFields() }
//                Button("Update", role: .destructive) {
//                    if oldPassword.isEmpty || security_question.isEmpty || security_answer.isEmpty {
//                        showError("Please fill in all required fields.", source: 3)
//                        return
//                    }
//                    
//                    print("Security Q&A updated.")
//                    clearFields()
//                }
//            } message: {
//                Text("Enter your password to update your security question and answer.")
//            }
//            
//            // MARK: - Global Error Alert
//            .alert(messageOfError, isPresented: $conditionOfError) {
//                Button("OK", role: .cancel) {
//                    // Slight delay ensures the error alert dismisses before reopening the form alert
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        switch errorAt {
//                        case 1: isShowingAlertChangeName = true
//                        case 2: isShowingAlertChangePassword = true
//                        case 3: isShowingAlertChangeSecurityQnA = true
//                        default: break
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    /// Triggers the error alert and remembers which form to reopen
//    private func showError(_ message: String, source: Int) {
//        messageOfError = message
//        errorAt = source
//        conditionOfError = true
//    }
//    
//    /// Clears all form fields to prevent old data from showing up on next open
//    private func clearFields() {
//        oldPassword = ""
//        newPassword = ""
//        confirmPassword = ""
//        security_answer = ""
//    }
//}
//
//// MARK: - Reusable Row Component
//struct SettingsRowButton: View {
//    let title: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Text(title)
//                Spacer()
//                RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
//            }
//            .padding(.horizontal)
//            .frame(maxWidth: .infinity)
//            .frame(height: 40)
//        }
//        .foregroundStyle(Color.primary)
//        .padding(.horizontal, 20)
//    }
//}

import SwiftUI

struct Account_SecurityView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                // 1. Change Name Link
                NavigationLink(destination: ChangeNameView()) {
                    SettingsRowContent(title: "Change Family's name")
                }
                
                 //2. Change Password Link
                NavigationLink(destination: ChangePasswordView()) {
                    SettingsRowContent(title: "Change Password")
                }

                // 3. Change Q&A Link
                NavigationLink(destination: ChangeSecurityQAView()) {
                    SettingsRowContent(title: "Change Security Q&A")
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Account & Security")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Account_SecurityView()
}
