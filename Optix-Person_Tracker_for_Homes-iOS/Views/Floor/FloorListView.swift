//
//  FloorListView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 31/1/26.
//

import SwiftUI

struct FloorListView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject var floorViewModelObject = FloorViewModel()
    @State var floorObjectForDetails: Floor?
    @State private var isShowingAddFloorSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            
            ScrollView {
                // Spacer for Floating Header
                Color.clear.frame(height: 120)
                
                // Section Title
                HStack{
                    Text("Floor Plans")
                    Spacer()
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    
                // CASE 1: Floor list is Empty
                if floorViewModelObject.floorlist.isEmpty {
                        VStack{
                            HStack(spacing: 10) {
                                Image(systemName: "square.dashed")
                                    .font(.system(size: 20))
                                Text("No Floor Plans found!")
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
                        
                    // CASE 2: List of Floors
                    } else {
                        ForEach(floorViewModelObject.floorlist) { floor in
                            InfoCard(
                                cardType: .floorPlan,
                                id: floor.id,
                                name: "",
                                roomName: "",
                                floorName: floor.title,
                                description: floor.description,
                                detected_date: "",
                                detected_time: "",
                                photo: "", relationship: ""
                            ) {
                                print("Tapped \(floor.title)")
                                floorObjectForDetails = floor
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.bottom, 100)
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            // MARK: - Layer 2: Floating Header
            VStack{
                VStack(alignment: .leading) {
                    HStack {
                        Text("Floor Plans")
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
                
                if floorViewModelObject.isLoading {
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
            }
            
            // MARK: - Layer 3: Floating Action Button (Bottom Right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isShowingAddFloorSheet = true
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
        }
        .onAppear {
            Task {
                await floorViewModelObject.fetchFloorlist(context: context)
            }
        }
        .refreshable{
            Task {
                await floorViewModelObject.fetchFloorlist(context: context)
            }
        }
        .sheet(item: $floorObjectForDetails) { floor in
            Text("Details for \(floor.title)")
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingAddFloorSheet) {
            Text("Add Floor View")
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    FloorListView()
}
