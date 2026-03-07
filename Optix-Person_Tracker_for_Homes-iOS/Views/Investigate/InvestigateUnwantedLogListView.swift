//
//  InvestigateUnwantedLogListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/3/26.
//

import SwiftUI

struct InvestigateUnwantedLogListView: View {
    
    var unwantedLogs : [Logs] = []
    
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var unwantedLogObjectForDetails: Logs?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(unwantedLogs) { log in
                        InfoCard(cardType: .alert, id: log.id, name: log.name, roomName: log.roomName, floorName: log.floorTitle, description: "", detected_date: AppFormatter.shared.getFormattedDate(from: log.detectedAt), detected_time: AppFormatter.shared.getFormattedTime(from: log.detectedAt), photo: log.personPhoto, relationship: "") {
                                unwantedLogObjectForDetails = log
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
                .padding(.vertical, 20) // Add breathing room at top/bottom
            }
            // 3. Standard Sheet Header
            .navigationTitle("Unwanted Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $unwantedLogObjectForDetails) { LogObject in
            UnwantedLogDetailsiew(unwantedPerson: LogObject)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    InvestigateUnwantedLogListView()
}
