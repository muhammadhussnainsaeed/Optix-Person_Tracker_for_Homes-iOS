//
//  NotificationsView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/2/26.
//

import SwiftUI

struct NotificationsView: View {
    @State var unauthorizedAccessAlert: Bool = true
    var body: some View {
        NavigationStack{
            VStack(spacing: 15){
                HStack{
                    Toggle(isOn: $unauthorizedAccessAlert) {
                        Text("Unauthorized Alert")
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationsView()
}
