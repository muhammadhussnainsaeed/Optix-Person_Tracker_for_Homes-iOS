//
//  SignupView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 13/1/26.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var conditionOfError: Bool = false
    @State var messageOfError: String = ""
    @EnvironmentObject var authViewModelObject: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Signup for an Account")
                    .bold()
                    .font(.title)
                Spacer()
            }
            .padding(.horizontal, 30)
            
            HStack {
                Text("Welcome! Setup your Account")
                    .font(.subheadline)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 60)
            ScrollView{
                VStack(alignment: .leading){
                    Text("Name:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter your name", text: $authViewModelObject.name)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                        
                    
                    Text("Username:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter your username", text: $authViewModelObject.username)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect() // Assuming you have this extension
                        .padding(.bottom, 30)
                    
                    Text("Password:")
                        .bold()
                        .padding(.horizontal, 14)
                    SecureField("Enter your password", text: $authViewModelObject.password)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                    
                    Text("Confirm Password:")
                        .bold()
                        .padding(.horizontal, 14)
                    SecureField("Re-enter your password", text: $authViewModelObject.confirmPassword)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 30)
            
            HStack(alignment: .center) {
                
                PrimaryButton(buttonText: "Next", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    
                    if authViewModelObject.username == "" || authViewModelObject.password == "" || authViewModelObject.confirmPassword == "" || authViewModelObject.name == "" {
                        messageOfError = "Please fill in all required fields."
                        conditionOfError = true
                        return
                    }
                    
                    if !Validator.shared.isPasswordValid(authViewModelObject.password){
                        messageOfError = "Password must be 8+ chars with at least one number and uppercase letter."
                        conditionOfError = true
                        print(authViewModelObject.password)
                        return
                    }
                    
                    if !Validator.shared.isPasswordConfirmationValid(password: authViewModelObject.password, confirmPassword: authViewModelObject.confirmPassword) {
                        messageOfError = "Passwords do not match."
                        conditionOfError = true
                        print(authViewModelObject.password)
                        print(authViewModelObject.confirmPassword)
                        return
                    }
                    authViewModelObject.navPath.append(AuthRoute.signupQuestion)
                }, isLoading: authViewModelObject.isLoading)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 30)
            HStack(){
                Spacer()
                
                Button {
                    print("")
                    dismiss()
                } label: {
                    Text("Already have an account? Sign in")
                        .font(.footnote)
                        .foregroundColor(Color.primary)
                }
                Spacer()
            }
            Spacer()
        }
        .alert(messageOfError, isPresented: $conditionOfError, actions: {
            Button("Ok", role: .cancel){
                conditionOfError = false
            }
        })
    }
}

#Preview {
    SignupView()
}
