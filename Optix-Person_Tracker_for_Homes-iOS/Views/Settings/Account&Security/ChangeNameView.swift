//
//  ChangeNameView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 22/2/26.
//

import SwiftUI

struct ChangeNameView: View {
    
    @StateObject var settingViewModelObject = SettingsViewModel()
    
    @State private var familyName = SessionManager.shared.currentName
    @State private var isPresentedAlert = false
    @State private var alertMessage: String = ""
    @State var error: Bool = false
    
    @Environment(\.dismiss) var dismiss // Lets us close the screen programmatically
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Name:")
                    .bold()
                    .padding(.horizontal, 14)
                TextField("Enter your name", text: $familyName)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(height: 50)
                    .glassEffect()
                    .padding(.bottom, 60)
                PrimaryButton(buttonText: "Update", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    if familyName.isEmpty{
                        alertMessage = "Please enter your name"
                        error = true
                        isPresentedAlert.toggle()
                        return
                    }
                    else{
                        Task{
                            await settingViewModelObject.updateName(name: familyName)
                            if (settingViewModelObject.errorMessage != nil){
                                alertMessage = settingViewModelObject.errorMessage ?? ""
                                error.toggle()
                                isPresentedAlert.toggle()
                            }
                            else{
                                alertMessage = settingViewModelObject.updateNameReponse?.message ?? ""
                                isPresentedAlert.toggle()
                             }
                        }
                    }
                    
                    //dismiss()
                    
                }, isLoading: false)
            }
            .padding(.all, 30)
        }
        
        .navigationTitle("Update Family Name")
        .alert(error ? "Error" : "Success", isPresented: $isPresentedAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    familyName = ""
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
    ChangeNameView()
}
