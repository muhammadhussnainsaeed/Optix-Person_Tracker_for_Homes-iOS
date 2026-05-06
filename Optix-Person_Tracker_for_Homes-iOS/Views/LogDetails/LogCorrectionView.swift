//
//  LogCorrectionView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/5/26.
//

import SwiftUI

struct LogCorrectionView: View {
    let logId : UUID
    @State var personId: UUID?
    @StateObject var logViewModelObject = LogViewModel()
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select the correct person from the database to update the activity log.")) {
                    
                    Picker(selection: $personId) {
                        HStack{
                            ZStack {
                                Color.gray.opacity(0.2)
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(18) // Add padding so icon isn't huge
                                    .foregroundStyle(.gray)
                                
                                //                                //.foregroundColor(.secondary)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                            Text("Unknown / Not in list")
                            Spacer()
                        }
                        .tag(nil as UUID?)
                        
                        ForEach(logViewModelObject.personList) { person in
                            let idAsUUID = UUID(uuidString: person.id)
                            ListCard(
                                cardType: .all,
                                id: idAsUUID ?? UUID(),
                                name: person.name,
                                relationship: "Family Member",
                                type: person.personType,
                                photo: person.photo ?? ""
                            )
                            .tag(idAsUUID as UUID?)
                        }
                    } label: {
                    }
                    .pickerStyle(.navigationLink)
                    
                    PrimaryButton(buttonText: "Update", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                        print("button press")
                    }, isLoading: false)
                    
                }
            }
            .navigationTitle("Identify Person")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await logViewModelObject.fetchPersonList()
                }
            }
        }
    }
}

//#Preview {
//    LogCorrectionView()
//}
