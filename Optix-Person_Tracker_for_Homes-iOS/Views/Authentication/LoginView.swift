//
//  LoginView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var conditionOfError: Bool = false
    @State var messageOfError: String = ""
    
    //var AuthViewModelObject = AuthViewModel()
    
    @StateObject private var authViewModelObject = AuthViewModel()
    var body: some View {
        NavigationStack(path: $authViewModelObject.navPath) {
            VStack(alignment: .leading) {
                
                //Top Headings
                HStack {
                    Text("Log In to your Account")
                        .bold()
                        .font(.title)
                        .padding(.top, 30)
                    Spacer()
                }
                HStack {
                    Text("Welcome back! Please Login to continue")
                        .font(.subheadline)
                }
                .padding(.bottom, 60)
                
                //Username TextField
                Text("Username:")
                    .bold()
                    .padding(.horizontal, 14)
                TextField("Enter your username", text: $username)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect() // Assuming you have this extension
                    .padding(.bottom, 30)
                
                //Password Text Field
                Text("Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Enter your password", text: $password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 40)
                
                HStack {
                    Spacer()
                    
                    Button {
                        print("")
                        authViewModelObject.navPath.append(AuthRoute.forgetPassword)
                    } label: {
                        Text("Trouble signing in? Recover now!")
                            .font(.footnote)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                
                .padding(.bottom, 170)
                
                HStack(alignment: .center) {
                    
                    PrimaryButton(buttonText: "Sign in", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                        if username == "" || password == "" {
                            messageOfError = "We need your info to get you in!"
                            conditionOfError = true
                            return
                        }
                        await authViewModelObject.loginUser(username: username, password: password)
                        if authViewModelObject.errorMessage != nil {
                            messageOfError = authViewModelObject.errorMessage!
                            conditionOfError = true
                        }
                    }, isLoading: authViewModelObject.isLoading)
                    .padding(.bottom, 20)
                }
                HStack(){
                    Spacer()
                    
                    Button {
                        print("press signup button")
                        authViewModelObject.navPath.append(AuthRoute.signup)
                        
                    } label: {
                        Text("Don't have an account? Sign up")
                            .font(.footnote)
                            .foregroundColor(Color.primary)
                    }
                    Spacer()
                }
                Spacer()
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signup:
                    SignupView() // Step 1 View
                case .signupQuestion:
                    SignupQuestionView() // Step 2 View
                case .forgetPassword:
                    ForgetView()
                case .newPassword:
                    ForgotNewPasswordView()
                }
            }
            .alert(messageOfError, isPresented: $conditionOfError, actions: {
                Button("Ok", role: .cancel){
                    conditionOfError = false
                }
            })
            .padding(.all, 30)
        }
        .environmentObject(authViewModelObject)
    }
}
#Preview {
    LoginView()
}
