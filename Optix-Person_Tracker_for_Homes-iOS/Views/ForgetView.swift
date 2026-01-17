//
//  ForgetView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct ForgetView: View {
    @Environment(\.dismiss) var dismiss
    @State var username: String = ""
    @State var isNextTapped: Bool = false
    @State var question: String = "What is your mother’s maiden name?"
    @State var answer: String = ""
    let securityQuestions = [
        "What is your mother’s maiden name?",
        "What was the name of your first pet?",
        "In what city were you born?",
        "What was the make of your first car?",
        "What is the name of your favorite childhood teacher?"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Forgot Your Account Password?")
                        .bold()
                        .font(.title)
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                HStack {
                    Text("Don’t worry! Reset it using your security question.")
                        .font(.subheadline)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 60)
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Username:")
                            .bold()
                            .padding(.horizontal, 14)
                        TextField("Enter your username", text: $username)
                            .textCase(.lowercase)
                            .padding()
                            .frame(height: 50)
                            .glassEffect() // Assuming you have this extension
                            .padding(.bottom, 30)
                        
                        Text("Choose a Question:")
                            .bold()
                            .padding(.horizontal, 14)
                        Picker("Select a question", selection: $question){
                            ForEach(securityQuestions, id: \.self) { question in
                                Text(question).tag(question)
                            }
                            
                        }
                        .pickerStyle(.menu)
                        .clipShape(Capsule())
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .glassEffect()
                        .padding(.bottom, 30)
                        
                        Text("Your Answer:")
                            .bold()
                            .padding(.horizontal, 14)
                        SecureField("Enter your answer", text: $answer)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 50)
                                .glassEffect()
                                .padding(.bottom, 140)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
                
                HStack(alignment: .center) {
                    Button {
                        print("Forgot In Action")
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
                Spacer()
            }
            .navigationDestination(isPresented: $isNextTapped) {
                            ForgotNewPasswordView()
                        }
        }
    }
}

#Preview {
    ForgetView()
}
