//
//  SettingsView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/2/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    var username: String = SessionManager.shared.currentUsername
    
    var name: String = SessionManager.shared.currentName
    
//    var username: String = "alikhan123"
//    var name: String = "Muhammad Ali"
    
    @State private var isShowingSheetAccountSecurity = false
    @State private var isShowingSheetNotifications = false
    @State private var isShowingSheetAboutSupport = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 25){
                Button {
                    isShowingSheetAccountSecurity.toggle()
                } label: {
                    SettingsRowContent(title: "Account & Security")
                }
                
                Button {
                    isShowingSheetNotifications.toggle()
                } label: {
                    SettingsRowContent(title: "Notifications")
                }
                
                Button {
                    isShowingSheetAboutSupport.toggle()
                } label: {
                    SettingsRowContent(title: "About & Support")
                }
                
                Button {
                    print("")
                    SessionManager.shared.logout()
                    //context.delete(DashboardCache.self)
                } label: {
                    HStack{
                        Text("Logout")
                            .foregroundStyle(Color.red)
                        Spacer()
                        ZStack{
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .bold()
                                .foregroundStyle(.red)
                                .font(.callout)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                }
                .foregroundStyle(Color.primary)
                .padding(.horizontal, 20)
            }
            .padding(.top, 150)
            // checking do we have the data
            
            VStack{
                // Floating on top
                VStack(alignment: .leading) {
                    HStack{
                        Text("@\(username)")
                            .foregroundStyle(Color.secondary)
                    }
                    HStack {
                        Text("\(name)'s Family")
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                        Spacer()
                    }
                    //.padding(.bottom, 10)
                }
                .padding(.top, 70)
                .padding(.bottom, 15)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingSheetAccountSecurity, content: {
            Account_SecurityView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300),.large])
        })
        .sheet(isPresented: $isShowingSheetNotifications, content: {
            NotificationsView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
        })
        .sheet(isPresented: $isShowingSheetAboutSupport, content: {
            About_SupportView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(200)])
        })
    }
}

#Preview {
    SettingsView()
}
