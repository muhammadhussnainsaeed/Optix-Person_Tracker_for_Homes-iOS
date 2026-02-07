//
//  CameraNetworkView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/2/26.
//

import SwiftUI

struct CameraNetworkView: View {
    
    @Environment(\.modelContext) private var context
    @State var directConnectedList: [CCTVNetworkItem] = []
    @State var otherList: [CCTVNetworkItem] = []
    
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    let autoColumns = [
        GridItem(.adaptive(minimum: 100), spacing: 25)
    ]
    let camera: CCTV
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - 1. Top Info Card
                VStack {
                    HStack {
                        Text("Name: ")
                            .bold()
                        Text("\(camera.name)")
                        Spacer()
                    }
                    HStack {
                        Text("Location: ")
                            .bold()
                        Text("\(camera.location)")
                        Spacer()
                    }
                    HStack(alignment: .top) {
                        Text("\(Text("Description:").fontWeight(.bold)) \(camera.cctvDescription)")
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                }
                .font(.caption)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("custom_color"))
                .cornerRadius(20)
                .padding(.top, 20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                
                // MARK: - 2. Direct Path Section
                HStack {
                    Text("Direct Path with:")
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 11)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .foregroundStyle(Color("custom_color"))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .overlay {
                        ScrollView {
                            VStack(spacing: 20) {
                                // USE THE HELPER HERE
                                cameraGridLoop(list: directConnectedList, isConnected: true)
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 25)
                        }
                        .scrollIndicators(.hidden)
                    }
                
                // MARK: - 3. Others Section
                HStack {
                    Text("Others:")
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 11)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .foregroundStyle(Color("custom_color"))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .overlay {
                        ScrollView {
                            VStack(spacing: 20) {
                                // USE THE HELPER HERE
                                cameraGridLoop(list: otherList, isConnected: false)
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 25)
                        }
                        .scrollIndicators(.hidden)
                    }
                
                Spacer()
                
                // MARK: - 4. Save Button
                PrimaryButton(buttonText: "Save", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                    // Action code...
                }, isLoading: cctvViewModelObject.isLoading)
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 30)
            .navigationTitle("Camera Network")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await loadData()
                }
            }
            .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - The ViewBuilder for the Loop
    // This handles the Logic and the Grid only
    @ViewBuilder
    func cameraGridLoop(list: [CCTVNetworkItem], isConnected: Bool) -> some View {
        LazyVGrid(columns: autoColumns, spacing: 25) {
            ForEach(list) { item in
                // Logic: Find the matching camera object from the full list using the ID
                if let match = cctvViewModelObject.cctvlist.first(where: { $0.id == item.id }) {
                    CameraNetworkItem(status: isConnected, cameraName: match.name) {
                        // Toggle Logic can go here
                        if isConnected {
                            print("Removing connection from: \(match.name)")
                            otherList.append(CCTVNetworkItem(id: match.id))
                            directConnectedList.removeAll { $0.id == match.id }
                            // Remove from direct, add to others
                        } else {
                            print("Adding connection to: \(match.name)")
                            // Remove from others, add to direct
                            directConnectedList.append(CCTVNetworkItem(id: match.id))
                            otherList.removeAll { $0.id == match.id }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    func loadData() async {
        await cctvViewModelObject.fetchCameraNetwork(cameraId: camera.id)
        
        if let errMsg = cctvViewModelObject.errorMessage {
            alertMessage = errMsg
            error = true
            isPresentAlert = true
        }
        
        await cctvViewModelObject.fetchCCTVlist(context: context)
        makeList()
    }
    
    func makeList() {
        directConnectedList = cctvViewModelObject.cctvNetworkList
        otherList.removeAll()
        
        let connectedIDs = Set(directConnectedList.map { $0.id })
        
        for cctv in cctvViewModelObject.cctvlist {
            if !connectedIDs.contains(cctv.id) && cctv.id != camera.id {
                otherList.append(CCTVNetworkItem(id: cctv.id))
            }
        }
    }
}

#Preview {
    CameraNetworkView(camera: CCTV(id: UUID(), name: "Main Camera", location: "Room 1", cctvDescription: "This is a test description", videoURL: "", isPrivate: false, floorId: UUID()))
}
