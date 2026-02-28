//
//  PrimaryButton.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 18/1/26.
//

import SwiftUI

struct PrimaryButton: View {
    
    let buttonText: String
    let buttonTextColor: Color
    let buttonColor: String
    let action: () async -> Void
    @State var isLoading: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                Task{
                    await action()
                }
                print("")
            } label: {
                ZStack{
                    if isLoading {
                        ProgressView()
                            .tint(buttonTextColor)
                            .bold()
                            .font(.headline)
                            //.foregroundStyle(buttonTextColor)
                            .padding(.vertical, 22)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                    }
                    else{
                        Text("\(buttonText)")
                            .bold()
                            .font(.headline)
                            .foregroundStyle(buttonTextColor)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .disabled(isLoading)
            .background(Color("\(buttonColor)"))
            .clipShape(Capsule())
            .glassEffect()
        }
    }
}

#Preview {
    PrimaryButton(buttonText: "Next", buttonTextColor: .white, buttonColor: "custom_blue", action:{
        print("hello")
    }, isLoading: true)
}
