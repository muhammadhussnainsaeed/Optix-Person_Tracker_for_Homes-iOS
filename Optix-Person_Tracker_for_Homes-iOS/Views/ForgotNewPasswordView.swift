//
//  ForgotNewPasswordView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/1/26.
//

import SwiftUI

struct ForgotNewPasswordView: View {
    @State var newpassword: String = ""
    @State var confirmpassword: String = ""
    @State var isConfirmTapped: Bool = false
    
    var body: some View {
        NavigationStack() {
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
                TextField("Enter your new password", text: $newpassword)
                    .textCase(.lowercase)
                    .padding()
                    .frame(height: 50)
                    .glassEffect() // Assuming you have this extension
                    .padding(.bottom, 30)
                
                Text("Confirm Password:")
                    .bold()
                    .padding(.horizontal, 14)
                SecureField("Confirm your password", text: $confirmpassword)
                    .textCase(.lowercase)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 240)
                
                HStack(alignment: .center) {
                    Button {
                        print("Change In Action")
                        isConfirmTapped = true
                    } label: {
                        Text("Confirm")
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
                Spacer()
            }
            .padding(.all, 30)
            .navigationDestination(isPresented: $isConfirmTapped) {
                LoginView()
            }
        }
    }
}

#Preview {
    ForgotNewPasswordView()
}
