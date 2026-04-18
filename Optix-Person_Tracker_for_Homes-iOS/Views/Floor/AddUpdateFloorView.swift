//
//  AddUpdateFloorView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 28/3/26.
//

import SwiftUI

struct AddUpdateFloorView: View {

    @StateObject var floorViewModelObject = FloorViewModel()
    @Environment(\.dismiss) var dismiss
    
    let isUpdate: Bool
    @State var floorId = UUID()
    @State var title: String = ""
    @State var description: String = ""
    
    @Environment(\.dismiss) private var dismissRoot
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    @State var isShowingFloorPlanSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    
                    //Username TextField
                    Text("Name:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter Floor name", text: $title)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect() // Assuming you have this extension
                        .padding(.bottom, 30)
                    
                    Text("Description:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter Floor description", text: $description)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 80)
                                    
                    //.padding(.bottom, 170)
                    
                    HStack(alignment: .center) {
                        
                        PrimaryButton(buttonText: "Next", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                            if isUpdate{
                                print("update")
                            }
                            else{
                                if title.isEmpty || description.isEmpty{
                                    error = true
                                    alertMessage = "Please enter all the fields"
                                    isPresentAlert.toggle()
                                    return
                                }
                                Task{
                                    await floorViewModelObject.createFloor(title: title, description: description)
                                    if (floorViewModelObject.errorMessage != nil){
                                        alertMessage = floorViewModelObject.errorMessage ?? ""
                                        error.toggle()
                                        isPresentAlert.toggle()
                                    }
                                    else{
                                        isShowingFloorPlanSheet.toggle()
                                    }
                                }
                            }
                            
                        }, isLoading: floorViewModelObject.isLoading)
                    }
                    Spacer()
                }
                .padding(.all, 30)
            }
            .scrollIndicators(.hidden)
            .navigationTitle(isUpdate ? "Edit Floor Plan" : "Add Floor Plan")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowingFloorPlanSheet) {
            AddUpdateFloorPlanView(floorId: UUID(uuidString: floorViewModelObject.addUpdateFloorResponse!.id) ?? UUID(), floorTitle:  floorViewModelObject.addUpdateFloorResponse!.title, onDismissAll: {
                dismissRoot()
            })
                .presentationDragIndicator(.visible)
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

//#Preview {
//    AddUpdateFloorView(isUpdate: true, isRootPresented: true)
//}
