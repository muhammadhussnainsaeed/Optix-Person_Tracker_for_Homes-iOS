//
//  NetworkVideoPlayer.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/2/26.
//

import SwiftUI
import AVKit

// MARK: - 1. Native UIKit AVPlayerViewController Wrapper
struct AVControllerView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Force the native controls to show (including the full-screen button)
        controller.showsPlaybackControls = true
        controller.allowsPictureInPicturePlayback = true
        
        // Ensures the 16:9 video fits perfectly without cropping
        controller.videoGravity = .resizeAspect
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Keep the player updated if the state changes
        if uiViewController.player != player {
            uiViewController.player = player
        }
    }
}

// MARK: - 2. Your Main View
struct NetworkVideoPlayer: View {
    let videoURL: URL
    
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            if let player = player {
                // Use the newly created UIKit wrapper
                AVControllerView(player: player)
            } else {
                Color.black // Black background while initializing
            }
        }
        // Maintain your exact 16:9 shape and 205 max height
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    // MARK: - Setup
    private func setupPlayer() {
        // Initialize the video player but DO NOT call .play()
        if player == nil {
            player = AVPlayer(url: videoURL)
        }
    }
}

#Preview {
    NetworkVideoPlayer(videoURL: URL(string: "http://192.168.100.8:8000/media/snapshots/snapshot_family.mp4")!)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.black)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
        .aspectRatio(16/9, contentMode: .fit)
        //.frame(maxHeight: 205)
        //.clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
}
