//
//  CameraListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import SwiftUI

struct CameraListView: View {
    
    // 1. Add Dismiss Environment to close the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var showDeleteAlert = false
    @State private var cameraToDelete : CCTV?
    @State private var cameraToUpdate : CCTV?
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var cameraObjectForDetails : CCTV?
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    
    var body: some View {
        // 2. Wrap in NavigationStack to get a Title Bar
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
                                    photo: ""
                                ) {
                                    print("Tapped \(camera.name)")
                                    cameraObjectForDetails = camera
                                }
                                .contextMenu {
                                    Button {
                                        print("Edit Tapped")
                                        cameraToUpdate = camera
                                    } label: {
                                        Text("Edit")
                                    }
                                    
                                    Button(role: .destructive) {
                                        print("Delete Tapped")
                                        showDeleteAlert.toggle()
                                        cameraToDelete = camera
                                    } label: {
                                        Text("Delete")
                                    }
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
        }
        .alert("Delete Camera?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let camera = cameraToDelete {
                    Task{
                        await cctvViewModelObject.deleteCamera(cameraId: camera.id)
                        if (cctvViewModelObject.errorMessage != nil){
                            alertMessage = cctvViewModelObject.errorMessage ?? ""
                            error.toggle()
                            isPresentAlert.toggle()
                        }
                        else{
                            alertMessage = cctvViewModelObject.cctvResponseForCamera?.message ?? ""
                            isPresentAlert.toggle()
                         }
                    }
                    print("Deleted \(camera.name)")
                }
            }
        }message: {
                    Text("Are you sure you want to delete this camera? Log related to this camera will also be deleted and this action cannot be undone.")
        }
        .sheet(item: $cameraToUpdate) { camera in
            UpdateCCTVView(isUpdate: true, cameraId: camera.id, floorId: camera.floorId, name: camera.name, location: camera.location, description: camera.cctvDescription, videoFeedURL: camera.videoURL, isPrivate: camera.isPrivate)
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $cameraObjectForDetails) { camera in
                    CCTVCameraDetailsView(camera: camera)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
                }
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
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                print("Okay")
            }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    CameraListView()
}
