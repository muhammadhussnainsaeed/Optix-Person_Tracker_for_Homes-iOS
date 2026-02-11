//
//  CameraNetworkListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/2/26.
//

import SwiftUI

struct CameraNetworkListView: View {
    
    @State private var cameraForNetwork : CCTV?
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView {
                    VStack(spacing: 12) { // Add consistent spacing
                        
                        if cctvViewModelObject.cctvlist.isEmpty {
                            // Cleaner Empty State
                            HStack(spacing: 10) {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 20))
                                Text("No cameras found")
                                    .font(.headline)
                            }
                            .foregroundStyle(.primary)
                            .padding(.top, 50)
                            
                        } else {
                            ForEach(cctvViewModelObject.cctvlist) { camera in
                                InfoCard(
                                    cardType: .cctv,
                                    id: camera.id,
                                    name: camera.name,
                                    roomName: camera.location,
                                    floorName: "",
                                    description: camera.cctvDescription,
                                    detected_date: "",
                                    detected_time: "",
                                    photo: "", relationship: ""
                                ) {
                                    print("Tapped \(camera.name)")
                                    cameraForNetwork = camera
                                }
                            }
                            // Move padding to the container for cleaner code
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20) // Add breathing room at top/bottom
                }
                // 3. Standard Sheet Header
                .navigationTitle("All Cameras")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack{
                    if cctvViewModelObject.isLoading {
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
            .sheet(item: $cameraForNetwork, content: { camera in
                CameraNetworkView(camera: camera)
                    .presentationDragIndicator(.visible)
            })
            .onAppear(){
                Task{
                    await cctvViewModelObject.fetchCCTVlist(context: context)
                }
            }
            .refreshable {
                Task{
                    await cctvViewModelObject.fetchCCTVlist(context: context)
                }
            }
        }
    }
}

#Preview {
    CameraNetworkListView()
}
