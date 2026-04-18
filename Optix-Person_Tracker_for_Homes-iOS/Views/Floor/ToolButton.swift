//
//  ToolButton.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/4/26.
//

import Foundation
import SwiftUI

struct ToolButton: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack{
                // The Tool Icon (Softened the corners of the rectangle)
                Rectangle()
                    .fill(color)
                    .frame(width: 32, height: isSelected ? 6 : 4)
                    .cornerRadius(2)

                // Text dynamically updates weight and color based on selection
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(.primary)
            }
            // Add a hit target padding so it's easy to tap
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            // Modern minimal background highlight
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primary.opacity(0.1) : Color.clear)
            )
            .cornerRadius(40)
        }

//        Button(action: action) {
//            VStack{
//                // The Tool Icon (Softened the corners of the rectangle)
//                Rectangle()
//                    .fill(color)
//                    .frame(width: 32, height: 4)
//                    .cornerRadius(2)
//
//                // Text dynamically updates weight and color based on selection
//                Text(title)
//                    .font(.caption)
//                    .fontWeight(isSelected ? .semibold : .medium)
//                    .foregroundColor(isSelected ? .primary : .secondary)
//            }
//            // Add a hit target padding so it's easy to tap
//            .padding(.vertical, 10)
//            .padding(.horizontal, 16)
//            // Modern minimal background highlight
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
//            )
//            .cornerRadius(40)
//            // Subtle pop effect and dimming
//            //.scaleEffect(isSelected ? 1.05 : 1.0)
//            //.opacity(isSelected ? 1.0 : 0.5)
//            // Smooth native animation
//            //.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
//        }
//        .buttonStyle(PlainButtonStyle()) // Prevents default button flashing
    }
}
