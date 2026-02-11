//
//  FamilyMemberDetailView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 11/2/26.
//

import SwiftUI

struct FamilyMemberDetailView: View {
    
    let member: Family
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack(spacing: 40){
                    NetworkImageView(urlString: member.photos[0].photo)
                        .frame(width: 80, height: 80)
                        .cornerRadius(13)
                    NetworkImageView(urlString: member.photos[1].photo)
                        .frame(width: 80, height: 80)
                        .cornerRadius(13)
                    NetworkImageView(urlString: member.photos[2].photo)
                        .frame(width: 80, height: 80)
                        .cornerRadius(13)
                }
                //.padding(.bottom, 10)
                VStack{
                    HStack{
                        Text("Name: ")
                            .bold()
                        Text("\(member.name)")
                        Spacer()
                    }
                    HStack{
                        Text("Relationship: ")
                            .bold()
                        Text("\(member.relationship)")
                        Spacer()
                    }
                }
                .font(.caption)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("custom_light_blue"))
                .cornerRadius(20)
                .padding(.top, 50)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
            .padding(.top, 15)
            .padding(.horizontal,30)
            .scrollIndicators(.hidden)
            .navigationTitle("\(member.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
        //.padding(.bottom)
    }
}

#Preview {
    FamilyMemberDetailView(member: Family(id: UUID(), name: "Hussnain", relationship: "Father", photos: []))
}
