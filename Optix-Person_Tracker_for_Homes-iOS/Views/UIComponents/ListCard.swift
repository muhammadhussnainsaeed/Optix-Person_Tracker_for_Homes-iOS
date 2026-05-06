//
//  ListCard.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/5/26.
//

import SwiftUI

enum ListCardStyle{
    case family
    case all
}


struct ListCard: View {
    let cardType: ListCardStyle
    let id: UUID
    let name: String
    let relationship: String
    let type: String
    let photo: String
    var body: some View {
        HStack{
            if cardType == .family{
                VStack{
                    HStack{
                        Text("\(name)")
                        //.font(.caption)
                        Spacer()
                    }
                    //Spacer()
                    HStack{
                        Text("\(relationship)")
                            .foregroundStyle(Color.secondary)
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                }
                .padding(.horizontal, 10)
            }
            else{
                HStack(spacing: 15) {
                    // Optimized Image Loading
                    ImageView(urlString: photo, localImage: nil)
                        .frame(width: 60, height: 60)
                        .cornerRadius(13)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Show relationship for Family, otherwise show the type (Unwanted/Guest)
                        Text(cardType == .family ? relationship : type)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }
                    Spacer()
                }
            }
            //.padding(12)
        }
    }
}

#Preview {
    ListCard(cardType: .all, id: UUID(), name: "Ali Khan", relationship: "Father", type: "Family", photo: "")
}
