//
//  SignupQuestionView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct SignupQuestionView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModelObject: AuthViewModel
    @State var conditionOfError: Bool = false
    @State var messageOfError: String = ""
    @State var signupSuccessful: Bool = false
    
    let securityQuestions = [
        "What is your mother’s maiden name?",
        "What was the name of your first pet?",
        "In what city were you born?",
        "What was the make of your first car?",
        "What is the name of your favorite childhood teacher?"
    ]
    @EnvironmentObject var AuthViewModelObject: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Setup your Security Question")
                    .bold()
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 30)
                Spacer()
            }
            HStack {
                Text("Choose a question and answer to help recover your account if you ever forget your password.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline)
            }
            .padding(.bottom, 60)
            
            Text("Choose a Question:")
                .bold()
                .padding(.horizontal, 14)
            Picker("Select a question", selection: $authViewModelObject.security_question){
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
            SecureField("Enter your answer", text: $authViewModelObject.security_answer)
                    .textCase(.lowercase)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 140)
            Spacer()
            HStack(alignment: .center) {
                PrimaryButton(buttonText: "Next", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    
                    if authViewModelObject.security_answer.isEmpty {
                        messageOfError = "Please fill up required field."
                        conditionOfError = true
                        return
                    }
                    
                    await authViewModelObject.signupUser(name: authViewModelObject.name, username: authViewModelObject.username, password: authViewModelObject.password, security_question: authViewModelObject.security_question, security_answer: authViewModelObject.security_answer)
                    if AuthViewModelObject.errorMessage != nil {
                        messageOfError = AuthViewModelObject.errorMessage!
                        conditionOfError = true
                        
                    }
                    else{
                        messageOfError = "Sign up Successful"
                        signupSuccessful =  true
                    }
                }, isLoading: authViewModelObject.isLoading)
                .padding(.bottom, 20)

            }
            Spacer()
            .padding(.all, 30)
        }
        .alert(messageOfError, isPresented: $conditionOfError, actions: {
            Button("Ok", role: .cancel){
                conditionOfError = false
                authViewModelObject.errorMessage = nil
                authViewModelObject.password = ""
                authViewModelObject.confirmPassword = ""
                authViewModelObject.navPath.removeLast(1)
            }
        })
        .alert(messageOfError, isPresented: $signupSuccessful, actions: {
            Button("Ok", role: .cancel){
                conditionOfError = false
                authViewModelObject.username = ""
                authViewModelObject.name = ""
                authViewModelObject.security_question = "What is your mother’s maiden name?"
                authViewModelObject.security_answer = ""
                authViewModelObject.password = ""
                authViewModelObject.confirmPassword = ""
                authViewModelObject.errorMessage = nil
                authViewModelObject.navPath.removeLast(2)
            }
        })
        .padding(.all, 30)
    }
}
//#Preview {
//    authViewModelObject
//    SignupQuestionView()
//        .environmentObject(authViewModelObject)
//}
