//
//  FamilyListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 11/2/26.
//

import SwiftUI

struct FamilyListView: View {
    
    @StateObject var familyViewModelObject = FamilyViewModel()
    @Environment(\.modelContext) private var context

    @State var memberObjectForDetails: Family?
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView {
                    VStack(spacing: 12) { // Add consistent spacing
                        
                        if familyViewModelObject.familyMemberList.isEmpty {
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
                            ForEach(familyViewModelObject.familyMemberList) { member in
                                InfoCard(cardType: .family, id: member.id, name: member.name, roomName: "", floorName: "", description: "", detected_date: "", detected_time: "", photo: "\(member.photos[0].photo)", relationship: member.relationship) {
                                    print("Tapped \(member.name)")
                                    memberObjectForDetails = member
                                }
//                                .contextMenu {
//                                    Button {
//                                        print("Edit Tapped")
//                                        cameraToUpdate = camera
//                                    } label: {
//                                        Text("Edit")
//                                    }
//                                    
//                                    Button(role: .destructive) {
//                                        print("Delete Tapped")
//                                        showDeleteAlert.toggle()
//                                        cameraToDelete = camera
//                                    } label: {
//                                        Text("Delete")
//                                    }
//                                }
                            }
                            // Move padding to the container for cleaner code
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20) // Add breathing room at top/bottom
                }
                // 3. Standard Sheet Header
                .navigationTitle("All Family Members")
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
        .onAppear(){
            Task{
                await familyViewModelObject.fetchFamilyMemberList(context: context)
            }
        }
        .refreshable {
            Task{
                await familyViewModelObject.fetchFamilyMemberList(context: context)
            }
        }
        .sheet(item: $memberObjectForDetails) { member in
                    FamilyMemberDetailView(member: member)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(320)])
                }
    }
}

#Preview {
    FamilyListView()
}
