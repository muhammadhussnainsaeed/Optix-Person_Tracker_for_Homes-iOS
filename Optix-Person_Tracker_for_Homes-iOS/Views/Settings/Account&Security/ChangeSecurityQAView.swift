//
//  ChangeSecurityQAView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 22/2/26.
//

import SwiftUI

struct ChangeSecurityQAView: View {
    
    @State private var password = ""
    @State private var security_question = "What is your mother’s maiden name?"
    @State private var security_answer = ""
    
    
    @State private var isPresentedAlert = false
    @State private var alertMessage: String = ""
    @State var error: Bool = false

    @StateObject var settingViewModelObject = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    let questions = [
        "What is your mother’s maiden name?",
        "What was the name of your first pet?",
        "In what city were you born?",
        "What was the make of your first car?"
    ]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                Text("Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Enter your password", text: $password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 30)
                
                Text("Choose a Question:")
                    .bold()
                    .padding(.horizontal, 14)
                Picker("Select a question", selection: $security_question){
                    ForEach(questions, id: \.self) { question in
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
                SecureField("Enter your answer", text: $security_answer)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 60)
                
                PrimaryButton(buttonText: "Update", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    
                    if password == "" || security_answer == "" {
                        alertMessage = "Please fill in all required fields."
                        isPresentedAlert = true
                        error = true
                        return
                    }
                    
                    Task{
                        await settingViewModelObject.updateSecurityQuestionAnswer(password: password, securityQuestion: security_question, securityAnswer: security_answer)
                        if (settingViewModelObject.errorMessage != nil){
                            alertMessage = settingViewModelObject.errorMessage ?? ""
                            error.toggle()
                            isPresentedAlert.toggle()
                        }
                        else{
                            alertMessage = settingViewModelObject.updateSecurityQuestionResponse?.message ?? ""
                            isPresentedAlert.toggle()
                        }
                    }
                }, isLoading: settingViewModelObject.isLoading)
            }
            .padding(.all, 30)
        }
        .navigationTitle("Security Q&A")
        .alert(error ? "Error" :"Success", isPresented: $isPresentedAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    password = ""
                    security_answer = ""
                    security_question = "What is your mother’s maiden name?"
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
    ChangeSecurityQAView()
}
