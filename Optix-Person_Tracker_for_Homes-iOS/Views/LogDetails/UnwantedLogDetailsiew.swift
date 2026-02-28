//
//  UnwantedLogDetailsiew.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 28/2/26.
//

import SwiftUI

struct UnwantedLogDetailsiew: View {
    let unwawntedPerson: Logs
    let baseURL: String = "http://192.168.100.8:8000/"
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if unwawntedPerson.snapshotURL == "" || true {
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
                        NetworkVideoPlayer(videoURL: URL(string: baseURL)!.appendingPathComponent(unwawntedPerson.snapshotURL ?? ""))
                            .aspectRatio(16/9, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Text("\(Text(unwawntedPerson.name).fontWeight(.bold)) is spotted in \(Text(unwawntedPerson.roomName).fontWeight(.bold)) on the \(Text(unwawntedPerson.floorTitle).fontWeight(.bold)).")
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
                            Text("\(AppFormatter.shared.getFormattedDate(from: unwawntedPerson.detectedAt))")
                            Spacer()
                            Text("\(AppFormatter.shared.getFormattedTime(from: unwawntedPerson.detectedAt))")
                        }
                        if unwawntedPerson.exitedAt != nil {
                            Text("Exited:")
                                .bold()
                            HStack{
                                Text("\(AppFormatter.shared.getFormattedDate(from: unwawntedPerson.exitedAt!))")
                                Spacer()
                                Text("\(AppFormatter.shared.getFormattedTime(from: unwawntedPerson.exitedAt!))")
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
                    
                    VStack(alignment: .leading){
                        if unwawntedPerson.interactions != nil {
                            HStack{
                                Text("Interactions")
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.top, 18)
                                    .font(.footnote)
                                Spacer()
                            }
                            ForEach(unwawntedPerson.interactions!, id: \.self) {
                                object in
                                ObjectCard(object: object, backgroundColor: "custom_blue", fontColor: .white)
                            }
                        }
                    }
                    //.font(.caption2)
                }
                .padding(.top, 15)
                .padding(.horizontal,30)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Family Log Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(){
            
        }
    }
}

#Preview {
    UnwantedLogDetailsiew(unwawntedPerson: Logs(
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
