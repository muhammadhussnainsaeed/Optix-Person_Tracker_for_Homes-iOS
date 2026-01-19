//
//  DashboardView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 18/1/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack{
            Text("Welcome, \(SessionManager.shared.currentName)")

            Button {
                SessionManager.shared.logout()
            } label: {
                Text("Logout")
            }

        }
        
    }
}

#Preview {
    DashboardView()
}
