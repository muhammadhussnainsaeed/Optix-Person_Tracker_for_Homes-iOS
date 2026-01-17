//
//  SignupView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 13/1/26.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @State var username: String = ""
    @State var password: String = ""
    @State var isNextTapped: Bool = false
    
    var body: some View {
        NavigationStack {
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
                        TextField("enter your username", text: $username)
                            .padding()
                            .frame(height: 50)
                            .glassEffect()
                            .padding(.bottom, 30)
                            
                        
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
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
                
                HStack(alignment: .center) {
                    Button {
                        print("Sign In Action")
                        isNextTapped = true
                    } label: {
                        Text("Next")
                            .bold()
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color("custom_yellow"))
                    .clipShape(Capsule())
                    .glassEffect()
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
                }
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
            .navigationDestination(isPresented: $isNextTapped) {
                            SignupQuestionView()
                        }
        }
    }
}

#Preview {
    SignupView()
}
