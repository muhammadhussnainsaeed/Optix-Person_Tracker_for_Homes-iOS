//
//  SettingsRowContent.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 22/2/26.
//

import SwiftUI

struct SettingsRowContent: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .foregroundStyle(Color.primary)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SettingsRowContent(title: "testing it")
}
