//
//  ObjectCard.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 27/2/26.
//

import SwiftUI

struct ObjectCard: View {
    let object: Object
    let backgroundColor: String
    let fontColor: Color
    var body: some View {
        HStack{
            Text("\(object.name)")
                .font(.caption2)
                .bold()
            Spacer()
            Text("\(AppFormatter.shared.getFormattedTime(from: object.movedAt))")
                .font(.caption2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color(backgroundColor))
        .clipShape(.capsule)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
    }
}

#Preview {
    ObjectCard(object: Object(name: "Laptop", movedAt: "12: 30"), backgroundColor: "custom_light_blue", fontColor: .primary)
}
