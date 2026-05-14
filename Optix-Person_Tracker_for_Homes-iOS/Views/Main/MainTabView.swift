//
//  MainTabView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI
import Combine

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    
    // FIX 1: Use @ObservedObject for a shared singleton instance
    @ObservedObject var session = SessionManager.shared
    
    // This is the ONE global manager for the app
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
            .tint(Color("custom_blue"))
            
            // BANNER OVERLAY
            if notificationManager.showBanner, let alert = notificationManager.currentAlert {
                NotificationBanner(packet: alert)
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .onAppear {
            // Initial check when app loads
            if session.getNotification, let userUUID = session.currentUserID {
                notificationManager.startListening(for: userUUID.uuidString)
            }
        }
        // FIX 2: Listen to the SessionManager toggle globally here
        .onChange(of: session.getNotification) { oldValue, newValue in
            if newValue {
                if let userUUID = session.currentUserID {
                    notificationManager.startListening(for: userUUID.uuidString)
                }
            } else {
                // Instantly kills the websocket app-wide when toggled off
                notificationManager.stopListening()
            }
        }
    }
}

#Preview {
    MainTabView()
}
