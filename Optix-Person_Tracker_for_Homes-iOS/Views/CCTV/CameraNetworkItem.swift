//
//  CameraNetworkItem.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/2/26.
//

import SwiftUI

struct CameraNetworkItem: View {
    let status: Bool
    let cameraName: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack{
                HStack{
                    Text("\(cameraName)")
                        .font(.caption)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: status ? "xmark" : "plus")
                        .font(.caption)
                        .foregroundStyle(Color.black)
                }
                .padding(.horizontal, 7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(Color("custom_yellow"))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
        }
    }
}

#Preview {
    CameraNetworkItem(status: false, cameraName: "hello") {
        print("")
    }
}
