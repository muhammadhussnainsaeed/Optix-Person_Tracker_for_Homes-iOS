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
    @State var isSignUpTapped: Bool = false
    @State var isForgotTapped: Bool = false
    
    var body: some View {
        NavigationStack() {
            VStack(alignment: .leading) {
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

                Text("Username:")
                    .bold()
                    .padding(.horizontal, 14)
                TextField("Enter your username", text: $username)
                    .textCase(.lowercase)
                    .padding()
                    .frame(height: 50)
                    .glassEffect() // Assuming you have this extension
                    .padding(.bottom, 30)
                
                Text("Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Enter your password", text: $password)
                    .textCase(.lowercase)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 40)
                
                HStack {
                    Spacer()
                    
                    Button {
                        print("")
                        isForgotTapped = true
                    } label: {
                        Text("Trouble signing in? Recover now!")
                            .font(.footnote)
                            .foregroundColor(Color("custom_blue"))
                    }
                    Spacer()
                }
                
                .padding(.bottom, 170)
                
                // ... (Your existing Sign In Button) ...
                HStack(alignment: .center) {
                    Button {
                        print("Sign In Action")
                    } label: {
                        Text("Sign In")
                            .bold()
                            .font(.headline)
                            .foregroundStyle(.black) // Text color on button
                            .padding(.vertical, 18)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color("custom_yellow"))
                    .clipShape(Capsule())
                    .glassEffect()
                    .padding(.bottom, 20)
                }
                HStack(){
                    Spacer()
                    
                    Button {
                        print("press signup button")
                        isSignUpTapped = true

                    } label: {
                        Text("Doesn't have a account? Sign up")
                            .font(.footnote)
                            .foregroundColor(Color.primary)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.all, 30)
            .navigationDestination(isPresented: $isSignUpTapped) {
                            SignupView()
                        }
            .navigationDestination(isPresented: $isForgotTapped) {
                            ForgetView()
                        }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView()
}
