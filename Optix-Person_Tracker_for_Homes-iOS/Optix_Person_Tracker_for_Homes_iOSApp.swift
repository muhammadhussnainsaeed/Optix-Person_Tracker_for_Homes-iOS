//
//  Optix_Person_Tracker_for_Homes_iOSApp.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 13/1/26.
//

import SwiftUI
import SwiftData

@main
struct Optix_Person_Tracker_for_Homes_iOSApp: App {
    
    @StateObject var session = SessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                DashboardView()
            }
            else{
                LoginView()
            }
        }
    }
}
