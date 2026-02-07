//
//  CCTVCameraDetailsView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 28/1/26.
//

import SwiftUI

struct CCTVCameraDetailsView: View {
    //@Environment(\.dismiss) var dismiss
    let camera: CCTV
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if !camera.isPrivate{
                        NetworkStreamPlayer(urlString: camera.videoURL)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color.black)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        }
                    else{
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .foregroundStyle(Color("custom_color"))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                            .overlay {
                                HStack{
                                    Image(systemName: "video.slash.fill")
                                        .foregroundStyle(Color.red)
                                        .font(.headline)
                                    Text("CCTV Camera is Private")
                                        .font(.callout)
                                }
                            }
                    }
                    VStack{
                        HStack(){
                            Text("Name: ")
                                .bold()
                            Text("\(camera.name)")
                            Spacer()
                        }
                        HStack{
                            Text("Location: ")
                                .bold()
                            Text("\(camera.location)")
                            Spacer()
                        }
                        HStack(alignment: .top){
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
                    .padding(.top, 50)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                }
                .padding(.top, 15)
                .padding(.horizontal,30)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("\(camera.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CCTVCameraDetailsView(camera: CCTV(id: UUID(), name: "Main Gate", location: "Main Gate", cctvDescription: "This is a cctv camera and this camera in 2000 years old and this a gift from my forefathers.", videoURL: "http://192.168.100.133:8080/video", isPrivate: false, floorId: UUID()))
}
