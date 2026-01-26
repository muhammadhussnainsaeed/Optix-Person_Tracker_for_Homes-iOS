//
//  HomeCard.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI

enum HomeCardStyle {
    case normal
    case add
    case icon
}

struct HomeCard: View {
    @State private var isPressed = false
    let cardType: HomeCardStyle
    let upperCardText: String
    let cardButtonColor: String
    let cardButtonArrowColor: Color
    let lowerCardText: String
    let cardTextColor: Color
    let cardColor: String
    let action: () -> Void
    var body: some View {
        if cardType == .icon{
            VStack{
                Image(systemName: "shield.pattern.checkered")
                    .font(Font.system(size: 40))
                    .foregroundStyle(cardTextColor)
                        // 1. Scale up to 1.3x when pressed, back to 1.0x when released
                        .scaleEffect(isPressed ? 1.3 : 1.0)
                        // 2. Add a spring animation for a bouncy feel
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                        // 3. Use DragGesture to detect touch down and up
            }
            .padding()
            .frame(height: 105)
            .frame(maxWidth: 161)
            .background(Color(cardColor))
            .cornerRadius(15)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
                )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
        }
        else {
            if cardType == .normal{
                VStack{
                    Button {
                        action()
                    } label: {
                        VStack{
                            HStack{
                                Spacer()
                                RoundButton(buttonColor: cardButtonColor, buttonArrowColor: cardButtonArrowColor)
                                    .padding(.top, 5)
                            }
                            Spacer()
                            HStack{
                                Text(upperCardText)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(cardTextColor)
                                Spacer()
                            }
                            HStack{
                                Text(lowerCardText)
                                    .foregroundStyle(cardTextColor)
                                    .font(.caption)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 105)
                .frame(maxWidth: 161)
                .background(Color(cardColor))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
            else{
                VStack{
                    Button {
                        action()
                    } label: {
                        VStack{
                            HStack{
                                Spacer()
                                RoundButton(buttonColor: cardButtonColor, buttonArrowColor: cardButtonArrowColor)
                                    .padding(.top, 5)
                            }
                            Spacer()
                            HStack{
                                Text(upperCardText)
                                    .font(.caption)
                                    .foregroundStyle(cardTextColor)
                                Spacer()
                            }
                            HStack{
                                Text(lowerCardText)
                                    .foregroundStyle(cardTextColor)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 100)
                .frame(maxWidth: 161)
                .background(Color(cardColor))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
        }
    }
}

#Preview {
    HomeCard(cardType: .icon, upperCardText: "3",cardButtonColor: "custom_blue", cardButtonArrowColor: .white, lowerCardText: "Total CCTV Cameras",cardTextColor: .black, cardColor: "custom_color") {
        print("hello")
    }
//    HomeCard(cardType: .add, upperCardText: "New", cardButtonColor: "custom_yellow", cardButtonArrowColor: .black, lowerCardText: "CCTV Camera", cardTextColor: .primary, cardColor: "custom_color") {
//        print("")
//    }
}
