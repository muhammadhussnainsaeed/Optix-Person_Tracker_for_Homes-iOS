//
//  CCTVView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import SwiftUI

struct CCTVView: View {
    
    @State private var isShowingSheetCameraList = false
    @State private var isShowingSheetCameraNetworkList = false
    @State private var isShowingSheetMatrix = false
    @State private var isShowingSheetFloor = false
    @State private var showDeleteAlert = false
    @State private var cameraToDelete : CCTV?
    @State private var cameraToUpdate : CCTV?
    @State private var cameraForNetwork : CCTV?
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var cameraObjectForDetails : CCTV?
    @Environment(\.modelContext) private var context
    @StateObject var cctvViewModelObject = CCTVViewModel()

    
    var topCameras: [CCTV] {
        // This grabs the first 3. If there are only 2, it grabs 2. No crash.
        Array(cctvViewModelObject.cctvlist.prefix(3))
    }
    
    var body: some View {
        ZStack(alignment: .top){
            
            ScrollView{
                // Spacer for Header
                Color.clear.frame(height: 120)
                
                // MARK: - LIST 1: The First 3 Cameras
                HStack{
                    Text("CCTV Cameras")
                    Spacer()
                    Button {
                        isShowingSheetCameraList = true
                        print("View All")
                    } label: {
                        HStack{
                            Text("View all")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                if topCameras.isEmpty {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "video.slash")
                                .font(.system(size: 20))
                            Text("No Camera found!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Tap the Floor Plan button to add one.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                } else{
                    
                    // USE FOREACH (Safely loops through topCameras)
                    ForEach(topCameras) { camera in
                        InfoCard(cardType: .cctv, id: camera.id, name: camera.name, roomName: "", floorName: "", description: camera.cctvDescription, detected_date: "", detected_time: "", photo: "") {
                            print("Tapped \(camera.videoURL)")
                            
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
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                    }
                }
                
                // MARK: - LIST 2: The First 3 Cameras
                HStack{
                    Text("Camera Network")
                    Spacer()
                    Button {
                        print("View All")
                        isShowingSheetCameraNetworkList.toggle()
                    } label: {
                        HStack{
                            Text("View all")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if topCameras.isEmpty {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "video.slash")
                                .font(.system(size: 20))
                            Text("No Camera found!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Tap the Floor Plan button to add one.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                } else{
                    
                    // USE FOREACH (Safely loops through bottomCameras)
                    ForEach(topCameras) { camera in
                        InfoCard(cardType: .cctv, id: camera.id, name: camera.name, roomName: "", floorName: "", description: camera.cctvDescription, detected_date: "", detected_time: "", photo: "") {
                            cameraForNetwork = camera
                            print("Tapped \(camera.name)")
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                    }
                }
                
                // Bottom Padding for TabBar
                Color.clear.frame(height: 140)
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack{
                // MARK: - Floating Header
                VStack(alignment: .leading) {
                    HStack {
                        Text("CCTV")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            isShowingSheetFloor = true
                            print("Map")
                        } label: {
                            Label("Floor Plan", systemImage: "map.fill")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .buttonStyle(.glassProminent)
                        .tint(Color("custom_blue"))
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
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
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        isShowingSheetMatrix = true
                    } label: {
                        Image(systemName: "tablecells")
                            .font(.title2)
                            .bold()
                            .frame(width: 40, height: 50)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .buttonStyle(.glassProminent)
                    .tint(Color("custom_blue"))
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
        .sheet(isPresented: $isShowingSheetMatrix, content: {
            RelationshipMatrixView()
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $cameraForNetwork, content: { camera in
            CameraNetworkView(camera: camera)
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $cameraToUpdate) { camera in
            UpdateCCTVView(isUpdate: true,cameraId: camera.id, floorId: camera.floorId, name: camera.name, location: camera.location, description: camera.cctvDescription, videoFeedURL: camera.videoURL, isPrivate: camera.isPrivate)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingSheetCameraList, content: {
            CameraListView()
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isShowingSheetCameraNetworkList, content: {
            CameraNetworkListView()
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $cameraObjectForDetails) { camera in
                    CCTVCameraDetailsView(camera: camera)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.medium])
                }
        .navigationDestination(isPresented: $isShowingSheetFloor, destination: {
            FloorListView()
                .navigationBarBackButtonHidden()
        })
        .onAppear(){
            Task {
                await cctvViewModelObject.fetchCCTVlist(context: context)
            }
        }
        .refreshable {
            Task {
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
    CCTVView()
}
