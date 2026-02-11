//
//  InfoCard.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import SwiftUI

enum InfoCardStyle {
    case family
    case familylog
    case cctv
    case alert
    case floorPlan
    
    // Background Color
    var backgroundColor: Color {
        switch self {
        case .familylog: return Color("custom_light_ blue")
        case .family: return Color("custom_light_blue")
        case .cctv:   return Color("custom_color")
        case .alert:  return Color("custom_blue")
        case .floorPlan: return Color("custom_color")
        }
    }
    
    // Text Color
    var textColor: Color {
        switch self {
        case .familylog: return .primary
        case .family: return .primary
        case .cctv:   return .primary
        case .alert:  return .white
        case .floorPlan: return .primary
        }
    }
}

struct InfoCard: View {
    let cardType: InfoCardStyle
    let id: UUID
    let name: String
    let roomName: String
    let floorName: String
    let description: String
    let detected_date: String
    let detected_time: String
    let photo: String
    let relationship: String
    let action: () -> Void
    var body: some View {
        
        if cardType == .family{
            Button {
                print("\(photo)")
                action()
            } label: {
                HStack{
                    VStack{
                        NetworkImageView(urlString: photo)
                            .frame(width: 60, height: 60)
                            .cornerRadius(13)
                    }
                    VStack{
                        HStack{
                            Text("\(Text("Name: ").fontWeight(.bold))\(name)")
                                .font(.caption)
                                .foregroundColor(cardType.textColor)
                            Spacer()
                        }
                        //Spacer()
                        HStack{
                            Text("\(Text("Relationship:").fontWeight(.bold)) \(relationship)")
                                .font(.caption)
                                .foregroundColor(cardType.textColor)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 10)
                    VStack{
                        RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
                        Spacer()
                    }
                }
                .padding(12)
                .frame(height: 85)
                .frame(maxWidth: .infinity)
                .background(Color(cardType.backgroundColor))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
        }
        
        if cardType == .alert || cardType == .familylog {
            
            Button {
                action()
            } label: {
                HStack{
                    VStack{
                        NetworkImageView(urlString: photo)
                            .frame(width: 60, height: 60)
                            .cornerRadius(13)
                    }
                    VStack{
                        HStack{
                           Text("\(Text(name).fontWeight(.bold)) is spotted in \(Text(roomName).fontWeight(.bold)) on the \(Text(floorName).fontWeight(.bold))")
                                .font(.caption)
                                .foregroundColor(cardType.textColor)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        //Spacer()
                        HStack{
                            HStack{
                                Text("\(detected_date)")
                                    .font(.caption)
                                    .foregroundStyle(cardType.textColor)
                                Spacer()
                                Text("\(detected_time)")
                                    .font(.caption)
                                    .foregroundStyle(cardType.textColor)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    VStack{
                        RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
                        Spacer()
                    }
                }
                .padding(12)
                .frame(height: 85)
                .frame(maxWidth: .infinity)
                .background(Color(cardType.backgroundColor))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
        }
        else {
            if cardType == .cctv {
                Button {
                    action()
                } label: {
                    HStack{
                        VStack{
                            Image("camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(13)
                        }
                        VStack{
                            HStack{
                                Text("\(Text("Name: ").fontWeight(.bold))\(name)")
                                    .font(.caption)
                                    .foregroundColor(cardType.textColor)
                                Spacer()
                            }
                            //Spacer()
                            HStack{
                                Text("\(Text("Description:").fontWeight(.bold)) \(description)")
                                    .font(.caption)
                                    .foregroundColor(cardType.textColor)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                //Text("\(description)")
                            }
                        }
                        .padding(.horizontal, 10)
                        VStack{
                            RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
                            Spacer()
                        }
                    }
                    .padding(12)
                    .frame(height: 85)
                    .frame(maxWidth: .infinity)
                    .background(Color(cardType.backgroundColor))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                }
            }
            else {
                if cardType == .floorPlan {
                    Button {
                        action()
                    } label: {
                        HStack{
                            VStack{
                                Image("floor_plan")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(13)
                            }
                            VStack{
                                HStack{
                                    Text("\(Text("Title: ").fontWeight(.bold))\(floorName)")
                                        .font(.caption)
                                        .foregroundColor(cardType.textColor)
                                    Spacer()
                                }
                                //Spacer()
                                HStack{
                                    Text("\(Text("Description:").fontWeight(.bold)) \(description)")
                                        .font(.caption)
                                        .foregroundColor(cardType.textColor)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 10)
                            VStack{
                                RoundButton(buttonColor: "custom_yellow", buttonArrowColor: .black)
                                Spacer()
                            }
                        }
                        .padding(12)
                        .frame(height: 85)
                        .frame(maxWidth: .infinity)
                        .background(Color(cardType.backgroundColor))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    }
                }
            }
        }
    }
}

#Preview {
    InfoCard(cardType: .family, id: UUID(), name: "Room 1", roomName: "Room 1", floorName: "First Floor",description: "This is a room 1 and this is a back door sdfuje fwefwe wefnwe webfwbef weufbwe weufwe wefbwe weufbwe weufwe ", detected_date: "Octcuber 12, 2025", detected_time: "12:00 AM",photo: "",relationship: "Sister", action: {
        print("")
    })
}
