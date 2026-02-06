//
//  UpdateCCTVView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 5/2/26.
//

import SwiftUI

struct UpdateCCTVView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let isUpdate: Bool
    @State var cameraId = UUID()
    @State var floorId = UUID()
    @State var name: String = ""
    @State var location: String = ""
    @State var description: String = ""
    @State var videoFeedURL: String = ""
    @State var isPrivate: Bool = true
    
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    
    var buttonText: String {
        isUpdate ? "Update" : "Save"
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    
                    //Username TextField
                    Text("Name:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter camera name", text: $name)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect() // Assuming you have this extension
                        .padding(.bottom, 30)
                    
                    //Password Text Field
                    Text("Location:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter camera location", text: $location)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                    
                    Text("Video Feed URL:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter camera feed URL", text: $videoFeedURL)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                    
                    Text("Private:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    Picker("Select the Option", selection: $isPrivate) {
                        Text("Yes")
                            .tag(true)
                        Text("No")
                            .tag(false)
                    }
                    //.padding(.leading, 30)
                    //.frame(height: 100)
                    .pickerStyle(.palette)
                    .padding(.bottom, 40)
                    
                    Text("Description:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter camera description", text: $description)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 80)
                                    
                    //.padding(.bottom, 170)
                    
                    HStack(alignment: .center) {
                        
                        PrimaryButton(buttonText: isUpdate ? "Update" : "Save", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                            Task{
                                await cctvViewModelObject.updateCamera(cctvObjectForUpadte: CCTV(id: cameraId, name: name, location: location, cctvDescription: description, videoURL: videoFeedURL, isPrivate: isPrivate, floorId: floorId))
                                if (cctvViewModelObject.errorMessage != nil){
                                    alertMessage = cctvViewModelObject.errorMessage ?? ""
                                    error.toggle()
                                    isPresentAlert.toggle()
                                }
                                else{
                                    alertMessage = cctvViewModelObject.cctvResponseForCamera?.message ?? ""
                                    isPresentAlert.toggle()
                                 }
                            }

                        }, isLoading: cctvViewModelObject.isLoading)
                    }
                    Spacer()
                }
                .padding(.all, 30)
            }
            .navigationTitle("Edit CCTV Camera")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    dismiss()
                }

            }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    UpdateCCTVView(isUpdate: true)
}
