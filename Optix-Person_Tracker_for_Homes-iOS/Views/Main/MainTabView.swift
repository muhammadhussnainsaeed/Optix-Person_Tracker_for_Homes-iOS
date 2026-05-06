//
//  MainTabView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI
import Combine

struct MainTabView: View {
    // We store the selected tab here so we can change it programmatically if needed
    // (e.g., clicking a notification takes you straight to .alerts)
    @State private var selectedTab: AppTab = .home
    @StateObject var session = SessionManager.shared
    
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        ZStack(alignment: .top){
            TabView(selection: $selectedTab) {
                
                // TAB 1: HOME
                NavigationStack {
                    HomeView()
                }
                .tag(AppTab.home)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                
                // TAB 2: CCTV
                NavigationStack {
                    CCTVView()
                }
                .tag(AppTab.cctv)
                .tabItem {
                    Label(AppTab.cctv.title, systemImage: AppTab.cctv.icon)
                }
                
                // TAB 3: FAMILY
                NavigationStack {
                    FamilyView()
                }
                .tag(AppTab.family)
                .tabItem {
                    Label(AppTab.family.title, systemImage: AppTab.family.icon)
                }
                
                // TAB 4: ALERTS
                NavigationStack {
                    AlertsView()
                }
                .tag(AppTab.alerts)
                .tabItem {
                    Label(AppTab.alerts.title, systemImage: AppTab.alerts.icon)
                }
                
                // TAB 5: SETTINGS
                NavigationStack {
                    SettingsView()
                }
                .tag(AppTab.settings)
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.icon)
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            // Optional: Custom Tab Bar Color
            .tint(Color("custom_blue"))
            
            if notificationManager.showBanner, let alert = notificationManager.currentAlert {
                NotificationBanner(packet: alert)
                    .padding(.top, 16) // Give it breathing room from the dynamic island/notch
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .onAppear {
            // Assuming your session manager holds the user object or ID
            // Convert the UUID to a string here using .uuidString
            if let userUUID = session.currentUserID {
                notificationManager.startListening(for: userUUID.uuidString)
            }
        }
        // Note: Adjust `session.currentUser?.id` to whatever your
        // SessionManager actually calls its UUID property (e.g., session.userId).
    }
}

#Preview {
    MainTabView()
}
