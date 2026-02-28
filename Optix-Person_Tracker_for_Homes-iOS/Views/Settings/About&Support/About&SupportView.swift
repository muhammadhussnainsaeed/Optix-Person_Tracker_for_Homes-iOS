//
//  About&SupportView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/2/26.
//

import SwiftUI

struct About_SupportView: View {
    
    @State var isShowingSheetHowToUse: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 15){
                Button {
                    print("")
                } label: {
                    SettingsRowContent(title: "How to Use")
                }
                
                HStack{
                    Text("version")
                    Spacer()
                    Text("0.1")
                }
                .foregroundStyle(Color.secondary)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("About & Support")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    About_SupportView()
}
