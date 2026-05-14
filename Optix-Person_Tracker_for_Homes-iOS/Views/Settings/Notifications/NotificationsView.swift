//
//  NotificationsView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/2/26.
//
//
//import SwiftUI
//
//struct NotificationsView: View {
//    @State var toggleNotification : Bool = SessionManager.shared.getNotification
//    @StateObject private var notificationManager = NotificationManager()
//    var body: some View {
//        NavigationStack{
//            VStack(spacing: 15){
//                HStack{
//                    Toggle(isOn: $toggleNotification) {
//                        Text("Unauthorized Alert")
//                    }
//                    
//                }
//                
//                Spacer()
//            }
//            .padding(.horizontal, 40)
//            .padding(.top, 20)
//            .navigationTitle("Notifications")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//#Preview {
//    NotificationsView()
//}


import SwiftUI

struct NotificationsView: View {
    // 1. Observe the SessionManager directly
    @ObservedObject var sessionManager = SessionManager.shared
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                HStack {
                    // 2. Bind directly to the manager's property
                    Toggle(isOn: $sessionManager.getNotification) {
                        Text("Unauthorized Alert")
                    }
                    .onChange(of: sessionManager.getNotification) { oldValue, newValue in
                        // 3. React to the toggle changes
                        if newValue {
                            // Start listening if turned on
                            if let userId = sessionManager.currentUserID?.uuidString {
                                notificationManager.startListening(for: userId)
                            }
                        } else {
                            // Stop listening if turned off
                            notificationManager.stopListening()
                        }
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
