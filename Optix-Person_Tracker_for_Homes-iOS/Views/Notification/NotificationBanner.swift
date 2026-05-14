//
//  NotificationBanner.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 27/4/26.
//
import SwiftUI

struct NotificationBanner: View {
    let packet: AlertPacket
    
    // State for the attention-grabbing pulse animation
    @State private var isPulsing = false
    
    var body: some View {
        HStack(spacing: 16) {
            // 1. Animated Icon Section
            ZStack {
                // Base background
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                // Pulsing ring
                Circle()
                    .stroke(Color.red.opacity(0.4), lineWidth: 1)
                    .frame(width: 44, height: 44)
                    .scaleEffect(isPulsing ? 1.3 : 1.0)
                    .opacity(isPulsing ? 0 : 1)
                
                // Stronger icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 20, weight: .bold))
            }
            
            // 2. High-Contrast Text Section
            VStack(alignment: .leading, spacing: 4) {
                Text(packet.type)
                    .font(.system(size: 16, weight: .bold))
                    //.foregroundColor(.white) // Force white text
                
                Text("\(packet.personName) • \(packet.cameraName) • \(packet.formattedTime)")
                    .font(.system(size: 13, weight: .medium))
                    //.foregroundColor(Color(white: 0.7)) // Light gray
            }
            
            Spacer()
            
            // 3. Actionable Indicator (Optional but good UX
        }
        .padding(16)
        
        // 4. The "Alert" Theme Background
        // Using a sleek, deep dark color to make it pop over the light dashboard
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
        // 5. Red Glowing Shadow instead of a standard black shadow
        .shadow(color: Color.red.opacity(0.25), radius: 20, x: 0, y: 10)
        
        // 6. Subtle red stroke to frame the banner
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .onAppear {
            // Trigger the continuous pulse animation when the banner drops down
            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Preview with Mock Data
#Preview {
    ZStack {
        // Mock app background to see the contrast
        Color(UIColor.systemGray6).ignoresSafeArea()
        
        NotificationBanner(packet: AlertPacket(
            type: "alert",
            userId: "123",
            personId: "456",
            cameraId: "cam_1",
            cameraName: "Front Porch",
            personName: "Unrecognized Individual",
            timestamp: "2025-05-02T12:00:00Z"
        ))
    }
}
