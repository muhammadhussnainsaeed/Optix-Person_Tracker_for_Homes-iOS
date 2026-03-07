//
//  InvestigateFamilyLogListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/3/26.
//

import SwiftUI

struct InvestigateFamilyLogListView: View {
    
    var familyLogs : [Logs] = []
    
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var familyLogObjectForDetails: Logs?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(familyLogs) { log in
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
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Family Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $familyLogObjectForDetails) { LogObject in
            FamilyLogDetailsView(member: LogObject)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    InvestigateFamilyLogListView()
}
