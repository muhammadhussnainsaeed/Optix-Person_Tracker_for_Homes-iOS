//
//  AlertsView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/3/26.
//

import SwiftUI

struct AlertsView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject var alertsViewModelObject = AlertsViewModel()
    
    @State var unwantedPersonLogObjectForDetails: Logs?
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                
                Color.clear.frame(height: 120)
                
                // MARK: - LIST 1: The First 3 Cameras
                HStack{
                    Text("Movement Logs")
                    Spacer()
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                if alertsViewModelObject.unwantedPersonLogsList.isEmpty {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "text.page.slash")
                                .font(.system(size: 20))
                            Text("No Person has been detected!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Refresh the screen to update!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                }
                else{
                    
                     //USE FOREACH (Safely loops through topFamilyMembers)
                    ForEach(alertsViewModelObject.unwantedPersonLogsList) { log in
                        InfoCard(cardType: .alert, id: log.id, name: log.name, roomName: log.roomName, floorName: log.floorTitle, description: "", detected_date: AppFormatter.shared.getFormattedDate(from: log.detectedAt), detected_time: AppFormatter.shared.getFormattedTime(from: log.detectedAt), photo: log.personPhoto, relationship: "") {
                            unwantedPersonLogObjectForDetails = log
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                        //                                            .contextMenu {
                        //                                                Button {
                        //                                                    print("Edit Tapped")
                        //                                                    memberObjectForUpdate = member
                        //                                                } label: {
                        //                                                    Text("Edit")
                        //                                                }
                        //
                        //                                                Button(role: .destructive) {
                        //                                                    print("Delete Tapped")
                        //                                                    showDeleteAlert.toggle()
                        //                                                    memberObjectForDelete = member
                        //                                                } label: {
                        //                                                    Text("Delete")
                        //                                                }
                        //                                            }
                    }
                }
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack{
                // MARK: - Floating Header
                VStack(alignment: .leading) {
                    HStack {
                        Text("Alerts")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                if false {
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
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear(){
            Task{
                await alertsViewModelObject.fetchUnwantedPersonLogList(context: context)
            }
        }
        .refreshable {
            Task{
                await alertsViewModelObject.fetchUnwantedPersonLogList(context: context)
            }
        }
        .sheet(item: $unwantedPersonLogObjectForDetails) { member in
            UnwantedLogDetailsiew(unwantedPerson: member)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.large])
                }
    }
}

#Preview {
    AlertsView()
}
