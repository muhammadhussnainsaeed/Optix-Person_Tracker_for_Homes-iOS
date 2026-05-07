//
//  SmartBoundariesView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import SwiftUI

struct SmartBoundariesView: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                // Spacer for Floating Header
                Color.clear.frame(height: 120)
                
                // Section Title
                HStack{
                    Text("Smart Boundaries")
                    Spacer()
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    
                    // CASE 1: Floor list is Empty
                    //                if floorViewModelObject.floorlist.isEmpty {
                    //                        VStack{
                    //                            HStack(spacing: 10) {
                    //                                Image(systemName: "square.dashed")
                    //                                    .font(.system(size: 20))
                    //                                Text("No Floor Plans found!")
                    //                                    .font(.headline)
                    //                            }
                    //                            .padding(.top, 50)
                    //                            HStack{
                    //                                Text("Tap the + button to add one.")
                    //                                    .font(.caption)
                    //                                    .foregroundStyle(.secondary)
                    //                                    .foregroundStyle(Color.secondary)
                    //                            }
                    //                            .padding(.top, 5)
                    //                        }
                    
                    // CASE 2: List of Floors
                    Text("test")
                    // } else {
                    //                        ForEach(floorViewModelObject.floorlist) { floor in
                    //                            InfoCard(
                    //                                cardType: .floorPlan,
                    //                                id: floor.id,
                    //                                name: "",
                    //                                roomName: "",
                    //                                floorName: floor.title,
                    //                                description: floor.description,
                    //                                detected_date: "",
                    //                                detected_time: "",
                    //                                photo: "", relationship: ""
                    //                            ) {
                    //                                print("Tapped \(floor.title)")
                    //                                floorObjectForDetails = floor
                    //                            }
                    //                            .contextMenu {
                    //                                Button {
                    //                                    print("Edit Tapped")
                    //                                    floorToUpdate = floor
                    //                                } label: {
                    //                                    Text("Edit")
                    //                                }
                    //
                    //                                Button(role: .destructive) {
                    //                                    print("Delete Tapped")
                    //                                    showDeleteAlert.toggle()
                    //                                    floorToDelete = floor
                    //                                } label: {
                    //                                    Text("Delete")
                    //                                }
                    //                            }
                    //                        }
                    //                        .padding(.horizontal, 30)
                    //                    Text("test")
                    //                }
                }
                Spacer()
                // MARK: - Layer 3: Floating Action Button (Bottom Right)
                
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        //isShowingAddFloorSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .bold()
                            .frame(width: 40, height: 50)
                    }
                    .padding(20)
                    .buttonStyle(.glassProminent)
                    .tint(Color("custom_blue"))
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 10)
            
            // MARK: - Layer 2: Floating Header
            VStack{
                VStack(alignment: .leading) {
                    HStack {
                        Text("Smart Boundries")
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
                
                //                if floorViewModelObject.isLoading {
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
                
                Spacer()
            }
        }
    }
}
#Preview {
    SmartBoundariesView()
}
