//
//  UnwantedLogDetailsiew.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 28/2/26.
//

import SwiftUI

struct UnwantedLogDetailsiew: View {
    
    @State var unwantedPersonLogs : [Logs]? = []
    @State var unwantedPerson: Logs
    let baseURL: String = "http://192.168.31.205:8888/"
    
    @StateObject var alertsViewModelObject = AlertsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if unwantedPerson.snapshotURL == "" {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .foregroundStyle(Color("custom_blue"))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                            .overlay {
                                HStack{
                                    Image(systemName: "video.slash.fill")
                                        .foregroundStyle(Color.white)
                                        .font(.headline)
                                    Text("Snapshot disabled for private cameras.")
                                        .font(.footnote)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                            }
                    }
                    else{
                        NetworkVideoPlayer(videoURL: URL(string: baseURL)!.appendingPathComponent(unwantedPerson.snapshotURL ?? ""))
                            .id(unwantedPerson.id)
                            .aspectRatio(16/9, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Text("\(Text(unwantedPerson.name).fontWeight(.bold)) is spotted in \(Text(unwantedPerson.roomName).fontWeight(.bold)) on the \(Text(unwantedPerson.floorTitle).fontWeight(.bold)).")
                                 .font(.caption)
                                 //.foregroundColor()
                                 .lineLimit(2)
                                 .multilineTextAlignment(.leading)
                                 .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.bottom, 6)
                        Text("Entered:")
                            .bold()
                        HStack{
                            Text("\(AppFormatter.shared.getFormattedDate(from: unwantedPerson.detectedAt))")
                            Spacer()
                            Text("\(AppFormatter.shared.getFormattedTime(from: unwantedPerson.detectedAt))")
                        }
                        if unwantedPerson.exitedAt != nil {
                            Text("Exited:")
                                .bold()
                            HStack{
                                Text("\(AppFormatter.shared.getFormattedDate(from: unwantedPerson.exitedAt!))")
                                Spacer()
                                Text("\(AppFormatter.shared.getFormattedTime(from: unwantedPerson.exitedAt!))")
                            }
                        }
                    }
                    .font(.caption)
                    .padding(20)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("custom_blue"))
                    .cornerRadius(20)
                    .padding(.top, 50)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    
                    VStack(alignment: .leading) {
                        // Safely unwrap the interactions and check that it is not empty
                        if let interactions = unwantedPerson.interactions, !interactions.isEmpty {
                            HStack {
                                Text("Interactions")
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.top, 18)
                                    .font(.footnote)
                                Spacer()
                            }
                            
                            // Safely iterate without using !
                            ForEach(interactions, id: \.self) { object in
                                ObjectCard(object: object, backgroundColor: "custom_blue", fontColor: .primary)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading){
                        if unwantedPersonLogs != nil{
                            ForEach(unwantedPersonLogs!, id: \.id){
                                log in
                                InfoCard(
                                    cardType: .alert,
                                    id: log.id,
                                    name: log.name,
                                    roomName: log.roomName,
                                    floorName: log.floorTitle,
                                    description: "",
                                    detected_date: AppFormatter.shared.getFormattedDate(from: log.detectedAt),
                                    detected_time: AppFormatter.shared.getFormattedTime(from: log.detectedAt),
                                    photo: log.personPhoto,
                                    relationship: ""
                                ) {
                                    
                                    let previousPerson = unwantedPerson
                                    
                                    unwantedPerson = log
                                    
                                    unwantedPersonLogs?.removeAll { $0.id == log.id }
                                    
                                    unwantedPersonLogs?.append(previousPerson)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal,30)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Unwanted Log Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(){
            Task{
                await alertsViewModelObject.fetchUnwantedPersonLogs(logId: unwantedPerson.id)
                unwantedPersonLogs = alertsViewModelObject.unwantedPersonLogs
            }
            
            print(unwantedPerson)
        }
    }
}

#Preview {
    UnwantedLogDetailsiew(unwantedPerson: Logs(
        id: UUID(uuidString: "2419a166-a252-4624-84a3-c2f3816761b9")!,
        detectedAt: "2025-12-14T10:32:32.527518+05:00",
        exitedAt: "2025-12-14T13:02:32.527518+05:00",
        snapshotURL: "media/snapshots/snapshot_family.mp4",
        name: "Muhammad Ali Khan",
        personPhoto: "media/persons/9F16004A-A32F-484B-8BD6-2D681E9D202B_0.jpg",
        roomName: "Lounge",
        floorTitle: "First Floor",
        eventType: "",
        interactions: [
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-02-26T20:32:28.48036+05:00"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231"),
            Object(name: "Wallet", movedAt: "2026-01-22T19:26:31.024057"),
            Object(name: "Bag", movedAt: "2026-01-23T11:28:29.457231")
        ]
    ))
}
