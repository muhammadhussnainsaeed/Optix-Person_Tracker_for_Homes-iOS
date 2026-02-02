//
//  MainTabView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI

struct MainTabView: View {
    // We store the selected tab here so we can change it programmatically if needed
    // (e.g., clicking a notification takes you straight to .alerts)
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
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
                Text("Family")
            }
            .tag(AppTab.family)
            .tabItem {
                Label(AppTab.family.title, systemImage: AppTab.family.icon)
            }
            
            // TAB 4: ALERTS
            NavigationStack {
                Text("Alerts")
            }
            .tag(AppTab.alerts)
            .tabItem {
                Label(AppTab.alerts.title, systemImage: AppTab.alerts.icon)
            }
            
            // TAB 5: SETTINGS
            NavigationStack {
                Button {
                    SessionManager.shared.logout()
                } label: {
                    Text("Logout")
                }
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
    }
}

#Preview {
    MainTabView()
}
