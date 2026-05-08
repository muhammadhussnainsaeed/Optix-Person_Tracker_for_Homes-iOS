//
//  SmartBoundriesCard.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import SwiftUI

struct SmartBoundriesCard: View {
    let id: UUID
    let title: String
    let name: String
    let photo: String
    let isActive: Bool
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack{
                VStack{
                    ImageView(urlString: photo, localImage: nil)
                        .frame(width: 60, height: 60)
                        .cornerRadius(13)
                }
                VStack{
                    HStack{
                        Text("\(Text("Title: ").fontWeight(.bold))\(title)")
                            .font(.caption)
                            .foregroundColor(Color.primary)
                            .lineLimit(1)
                        Spacer()
                    }
                    //Spacer()
                    HStack{
                        Text("\(Text("Name:").fontWeight(.bold)) \(name)")
                            .font(.caption)
                            .foregroundColor(Color.primary)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        
                    }
                }
                .padding(.horizontal, 10)
                VStack{
                    //Spacer()
                    HStack{
                        Image(systemName: "circle.fill")
                            .symbolEffect(.pulse, isActive: isActive)
                            
                            .font(.system(size: 7))
                            .scaledToFit()
                        Text(isActive ? "Active" :  "Inactive")
                            .font(.caption)
                    }
                    .foregroundStyle(isActive ? Color.green: Color.gray)
                }
                .padding(.horizontal)
                Spacer()
                VStack{
                    RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
                    Spacer()
                }
            }
            .padding(12)
            .frame(height: 85)
            .frame(maxWidth: .infinity)
            .background(Color("custom_light_blue"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
        }
    }
}

#Preview {
    SmartBoundriesCard(id: UUID(), title: "Baby protection is working anf ", name: "Muhammad Ali", photo: "", isActive: true){
        print("")
    }
    SmartBoundriesCard(id: UUID(), title: "Baby protection is working anf ", name: "Muhammad Ali", photo: "", isActive: false){
        print("")
    }
}
