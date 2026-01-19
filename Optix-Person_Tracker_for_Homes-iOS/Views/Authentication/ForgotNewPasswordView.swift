//
//  ForgotNewPasswordView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct ForgotNewPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModelObject: AuthViewModel
    @State var conditionOfError: Bool = false
    @State var messageOfError: String = ""
    @State var resetSuccessful: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Set Your New Password ")
                    .bold()
                    .font(.title)
                    .padding(.top, 30)
                Spacer()
            }
            HStack {
                Text("Create a strong password to secure your account.")
                    .font(.subheadline)
            }
            .padding(.bottom, 60)
            
            Text("New Password:")
                .bold()
                .padding(.horizontal, 14)
            SecureField("Enter your new password", text: $authViewModelObject.password)
                .textInputAutocapitalization(.never)
                .padding()
                .frame(height: 50)
                .glassEffect()
                .padding(.bottom, 30)
            
            Text("Confirm Password:")
                .bold()
                .padding(.horizontal, 14)
            SecureField("Confirm your password", text: $authViewModelObject.confirmPassword)
                .textInputAutocapitalization(.never)
                .padding()
                .frame(height: 50)
                .glassEffect()
                .padding(.bottom, 240)
            
            HStack(alignment: .center) {
                
                PrimaryButton(buttonText: "Change Password", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    
                    if authViewModelObject.password == "" || authViewModelObject.confirmPassword == "" {
                        messageOfError = "Please fill in all required fields."
                        conditionOfError = true
                        return
                    }
                    
                    await authViewModelObject.resetUserPassword(username: authViewModelObject.username, security_question: authViewModelObject.security_question, security_answer: authViewModelObject.security_answer, new_password: authViewModelObject.password)
                    
                    if authViewModelObject.errorMessage != nil {
                        messageOfError = authViewModelObject.errorMessage!
                        conditionOfError = true
                        
                    }
                    else{
                        resetSuccessful =  true
                    }
                    
                }, isLoading: authViewModelObject.isLoading)
                .padding(.bottom, 30)
            }
            Spacer()
        }
        .alert(messageOfError, isPresented: $conditionOfError, actions: {
            Button("Ok", role: .cancel){
                conditionOfError = false
                authViewModelObject.errorMessage = ""
                authViewModelObject.password = ""
                authViewModelObject.confirmPassword = ""
                authViewModelObject.navPath.removeLast(1)
            }
        })
        .alert("Password Reset Successful", isPresented: $resetSuccessful, actions: {
            Button("Ok", role: .cancel){
                resetSuccessful = false
                authViewModelObject.username = ""
                authViewModelObject.security_question = "What is your mother’s maiden name?"
                authViewModelObject.security_answer = ""
                authViewModelObject.password = ""
                authViewModelObject.confirmPassword = ""
                authViewModelObject.errorMessage = ""
                authViewModelObject.navPath.removeLast(2)
            }
        })
        .padding(.all, 30)
    }
}

#Preview {
    ForgotNewPasswordView()
}
