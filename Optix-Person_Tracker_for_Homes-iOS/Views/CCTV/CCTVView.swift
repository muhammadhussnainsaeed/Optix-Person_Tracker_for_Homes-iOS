//
//  CCTVView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import SwiftUI

struct CCTVView: View {
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                HStack{
                    Text("CCTV Cameras")
                    Spacer()
                    Button {
                        print("")
                    } label: {
                        HStack{
                            Text("View all Cameras")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                InfoCard(cardType: .cctv, id: UUID(), name: "Main Gate", roomName: "", floorName: "", description: "this is a room where i will and i grow up there", detected_date: "", detected_time: "", photo: "") {
                    print("")
                }
                .padding(.horizontal,30)
                .padding(.bottom, 7)
                
                InfoCard(cardType: .cctv, id: UUID(), name: "Main Gate", roomName: "", floorName: "", description: "this is a room where i will and i grow up there", detected_date: "", detected_time: "", photo: "") {
                    print("")
                }
                .padding(.horizontal,30)
                .padding(.bottom, 7)
                
                InfoCard(cardType: .cctv, id: UUID(), name: "Main Gate", roomName: "", floorName: "", description: "this is a room where i will and i grow up there", detected_date: "", detected_time: "", photo: "") {
                    print("")
                }
                .padding(.horizontal,30)
                .padding(.bottom, 7)
                
                HStack{
                    Text("Camera Network")
                    Spacer()
                    Button {
                        print("")
                    } label: {
                        HStack{
                            Text("View all Cameras")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            .padding(.top, 70)
            VStack{
                // Floating on top
                VStack(alignment: .leading) {
                    HStack {
                        Text("CCTV")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            print("")
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
                
//                if homeViewModelObject.isLoading {
//                    HStack{
//                        ProgressView()
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
            }
        }
    }
}

#Preview {
    CCTVView()
}
