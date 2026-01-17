//
//  SignupQuestionView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct SignupQuestionView: View {
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
                Spacer()
                HStack(alignment: .center) {
                    Button {
                        print("Sign up Action")
                    } label: {
                        Text("Sign up")
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
                }
                Spacer()
                .padding(.all, 30)
            }
            .padding(.all, 30)
        }
    }
}
#Preview {
    SignupQuestionView()
}
