//
//  Optix_Person_Tracker_for_Homes_iOSApp.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 13/1/26.
//

//import SwiftUI
//import SwiftData
//
//@main
//struct Optix_Person_Tracker_for_Homes_iOSApp: App {
//    
//    @StateObject var session = SessionManager.shared
//    
//    var body: some Scene {
//        WindowGroup {
//            if session.isLoggedIn {
//                MainTabView()
//                    .modelContainer(for: [DashboardCache.self, RecentLogSD.self, ObjectInterationSD.self, CCTVCache.self, FloorCache.self, FamilyMemberCache.self])
//            }
//            else{
//                LoginView()
//            }
//        }
//    }
//}
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
    
    // 1. State to control the splash screen visibility
    @State private var showSplashScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // MARK: - Layer 1: The Main App Logic
                // This loads underneath the splash screen so it's ready when video ends
                Group {
                    if session.isLoggedIn {
                        MainTabView()
                            .modelContainer(for: [
                                DashboardCache.self,
                                RecentLogSD.self,
                                ObjectInterationSD.self,
                                CCTVCache.self,
                                FloorCache.self,
                                FamilyMemberCache.self,
                                LogsCache.self,
                                FamilyMemberLogCache.self,
                                UnwantedPersonLogCache.self,
                                ObjectsCache.self
                            ])
                    } else {
                        LoginView()
                    }
                }
                
                // MARK: - Layer 2: Custom Video Splash (On Top)
                if showSplashScreen {
                    VideoSplashView {
                        // This closure runs when the video finishes
                        withAnimation(.easeOut(duration: 1.0 )) {
                            showSplashScreen = false
                        }
                    }
                    .transition(.opacity) // Fades out smoothly
                    .zIndex(1) // Ensures it stays on top of the app
                }
            }
        }
    }
}
