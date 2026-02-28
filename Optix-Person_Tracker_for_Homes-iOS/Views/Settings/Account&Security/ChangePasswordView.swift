//
//  ChangePasswordView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 22/2/26.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    
    @State private var isPresentedAlert = false
    @State private var alertMessage: String = ""
    @State var error: Bool = false

    @StateObject var settingViewModelObject = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Current Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Enter your current password", text: $oldPassword)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 30)
                
                Text("New Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Enter New password", text: $newPassword)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 30)
                
                Text("Confirm New Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Confirm New password", text: $confirmPassword)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 60)
                
                PrimaryButton(buttonText: "Update", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    
                    if confirmPassword == "" || newPassword == "" || oldPassword == "" {
                        alertMessage = "Please fill in all required fields."
                        isPresentedAlert = true
                        error = true
                        return
                    }
                    
                    if !Validator.shared.isPasswordValid(newPassword){
                        alertMessage = "Password must be 8+ chars with at least one number and uppercase letter."
                        isPresentedAlert = true
                        error = true
                        return
                    }
                    
                    if !Validator.shared.isPasswordConfirmationValid(password: newPassword, confirmPassword: confirmPassword) {
                        alertMessage = "Passwords do not match."
                        isPresentedAlert = true
                        error = true
                        return
                    }
                    
                    Task{
                        await settingViewModelObject.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
                        if (settingViewModelObject.errorMessage != nil){
                            alertMessage = settingViewModelObject.errorMessage ?? ""
                            error.toggle()
                            isPresentedAlert.toggle()
                        }
                        else{
                            alertMessage = settingViewModelObject.updatePasswordResponse?.message ?? ""
                            isPresentedAlert.toggle()
                         }
                    }
                    
                }, isLoading: settingViewModelObject.isLoading)
            }
            .padding(.all, 30)
        }
        .navigationTitle("Change Password")
        .scrollIndicators(.hidden)
        .alert(error ? "Error" :"Success", isPresented: $isPresentedAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    oldPassword = ""
                    newPassword = ""
                    confirmPassword = ""
                    dismiss()
                }
                error = false
            }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    ChangePasswordView()
}
