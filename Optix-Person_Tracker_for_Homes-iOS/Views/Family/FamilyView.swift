//
//  FamilyView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 8/2/26.
//

import SwiftUI

struct FamilyView: View {
    
    @State var isShowingSheetFamilyList: Bool = false
    @State var isShowingSheetFamilyLogsList: Bool = false
    
    var body: some View {
        ZStack(alignment: .top){
            
            ScrollView{
                // Spacer for Header
                Color.clear.frame(height: 120)
                
                // MARK: - LIST 1: The First 3 Cameras
                HStack{
                    Text("Family Members")
                    Spacer()
                    Button {
                        isShowingSheetFamilyList = true
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
                
                if true {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 20))
                            Text("No Family member found!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Tap the + button to add one.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                }
//                else{
//                    
//                    // USE FOREACH (Safely loops through topCameras)
//                    ForEach(topCameras) { camera in
//                        InfoCard(cardType: .cctv, id: camera.id, name: camera.name, roomName: "", floorName: "", description: camera.cctvDescription, detected_date: "", detected_time: "", photo: "") {
//                            print("Tapped \(camera.videoURL)")
//                            
//                            cameraObjectForDetails = camera
//                        }
//                        .contextMenu {
//                            Button {
//                                print("Edit Tapped")
//                                cameraToUpdate = camera
//                            } label: {
//                                Text("Edit")
//                            }
//                            
//                            Button(role: .destructive) {
//                                print("Delete Tapped")
//                                showDeleteAlert.toggle()
//                                cameraToDelete = camera
//                            } label: {
//                                Text("Delete")
//                            }
//                        }
//                        .padding(.horizontal, 30)
//                        .padding(.bottom, 7)
//                    }
//                }
                
                // MARK: - LIST 2: The First 3 Cameras
                HStack{
                    Text("Family Logs")
                    Spacer()
                    Button {
                        print("View All")
                        isShowingSheetFamilyLogsList.toggle()
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
                
                if true {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "text.page.slash")
                                .font(.system(size: 20))
                            Text("No Member has been detected!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Refresh the Screen to update!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                }
//                else{
//                    
//                    // USE FOREACH (Safely loops through bottomCameras)
//                    ForEach(topCameras) { camera in
//                        InfoCard(cardType: .cctv, id: camera.id, name: camera.name, roomName: "", floorName: "", description: camera.cctvDescription, detected_date: "", detected_time: "", photo: "") {
//                            cameraForNetwork = camera
//                            print("Tapped \(camera.name)")
//                        }
//                        .padding(.horizontal, 30)
//                        .padding(.bottom, 7)
//                    }
//                }
                
                // Bottom Padding for TabBar
                Color.clear.frame(height: 140)
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack{
                // MARK: - Floating Header
                VStack(alignment: .leading) {
                    HStack {
                        Text("Family")
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
//                if cctvViewModelObject.isLoading {
//                    HStack{
//                        ProgressView()
//                            .tint(.customBlue)
//                        Text("Connecting...")
//                            .font(.caption)
//                            .foregroundColor(.primary)
//                    }
//                    .padding(2)
//                    .frame(width: 130, height: 30)
//                    .glassEffect()
//                    Spacer()
//                }
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        //isShowingSheetMatrix = true
                    } label: {
                        Image(systemName: "plus")
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
    }
}

#Preview {
    FamilyView()
}
