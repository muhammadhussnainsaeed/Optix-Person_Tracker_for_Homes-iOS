//
//  FamilyMemberLogListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 1/3/26.
//

import SwiftUI
import SwiftData

struct FamilyMemberLogListView: View {
    @StateObject var familyViewModelObject = FamilyViewModel()
    @Environment(\.modelContext) private var context
    
    //@State private var showDeleteAlert = false
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var familyLogObjectForDetails: Logs?
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView {
                    VStack(spacing: 12) {
                        
                        if familyViewModelObject.familyMemberLogsList.isEmpty {
                            // Cleaner Empty State
                            HStack(spacing: 10) {
                                Image(systemName: "person.2.slash")
                                    .font(.system(size: 20))
                                Text("No Family member found!")
                                    .font(.headline)
                            }
                            .foregroundStyle(.primary)
                            .padding(.top, 50)
                            
                        } else {
                            ForEach(familyViewModelObject.familyMemberLogsList) { log in
                                InfoCard(cardType: .familylog, id: log.id, name: log.name, roomName: log.roomName, floorName: log.floorTitle, description: "", detected_date: AppFormatter.shared.getFormattedDate(from: log.detectedAt), detected_time: AppFormatter.shared.getFormattedTime(from: log.detectedAt), photo: log.personPhoto, relationship: "") {
                                    familyLogObjectForDetails = log
                                }
                                .contextMenu {
//                                    Button {
//                                        print("Edit Tapped")
//                                        familyLogObjectForDetails = log
//                                    } label: {
//                                        Text("Edit")
//                                    }
//                                    
//                                    Button(role: .destructive) {
//                                        print("Delete Tapped")
//                                        showDeleteAlert.toggle()
//                                        memberObjectForDelete = member
//                                    } label: {
//                                        Text("Delete")
//                                    }
                                }
                            }
                            // Move padding to the container for cleaner code
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20) // Add breathing room at top/bottom
                }
                // 3. Standard Sheet Header
                .navigationTitle("All Family Member Logs")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack{
                    if familyViewModelObject.isLoading {
                        HStack{
                            ProgressView()
                                .tint(.customBlue)
                            Text("Connecting...")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .padding(2)
                        .frame(width: 130, height: 30)
                        .glassEffect()
                        .padding()
                        
                    }
                    Spacer()
                }
            }
        }
//        .alert("Delete Family Member?", isPresented: $showDeleteAlert) {
//            Button("Cancel", role: .cancel) { }
//            Button("Delete", role: .destructive) {
//                if let member = memberObjectForDelete {
//                    Task{
//                        await familyViewModelObject.deleteFamilyMember(memberId: member.id)
//                        if (familyViewModelObject.errorMessage != nil){
//                            alertMessage = familyViewModelObject.errorMessage ?? ""
//                            error.toggle()
//                            isPresentAlert.toggle()
//                        }
//                        else{
//                            alertMessage = familyViewModelObject.addUpdateDeleteMemberResponse?.message ?? ""
//                            isPresentAlert.toggle()
//                         }
//                    }
//                    print("Deleted \(member.name)")
//                }
//            }
//        }message: {
//                    Text("Are you sure you want to delete this Family Member? Log related to this Family Member will also be deleted and this action cannot be undone.")
//        }
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                if error {
                    error.toggle()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .onAppear(){
            Task{
                await familyViewModelObject.fetchFamilyMembersLogList(context: context)
            }
        }
        .refreshable {
            Task{
                await familyViewModelObject.fetchFamilyMembersLogList(context: context)
            }
        }
        .sheet(item: $familyLogObjectForDetails) { LogObject in
            FamilyLogDetailsView(member: LogObject)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    FamilyMemberLogListView()
}
