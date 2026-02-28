//
//  RoundButton.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI

struct RoundButton: View {
    let buttonColor: String
    let buttonArrowColor: Color
    var body: some View {
        ZStack{
            Circle()
                .foregroundStyle(Color(buttonColor))
                .frame(width: 20, height: 20)
            Image(systemName: "arrow.up.forward")
                .bold()
                .foregroundStyle(buttonArrowColor)
                .font(.caption2)
        }
        .glassEffect()
        .tint(Color("Custom_yellow"))
    }
}

#Preview {
    RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
}
