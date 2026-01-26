//
//  NetworkImageView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 25/1/26.
//

import SwiftUI

struct NetworkImageView: View {
    let urlString: String?
    
    // Replace this with your actual server IP/Domain
    // ⚠️ IMPORTANT: Don't forget the 'http://' and port if needed
    let baseURL = "http://192.168.100.31:8888/"
    
    var fullURL: URL? {
        // If string is nil or empty, return nil
        guard let path = urlString, !path.isEmpty else { return nil }
        
        // If it's already a full URL, use it. Otherwise, prepend base URL.
        if path.hasPrefix("http") {
            return URL(string: path)
        } else {
            return URL(string: baseURL + path)
        }
    }
    
    var body: some View {
        if let url = fullURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    // 1. Loading State
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                    
                case .success(let image):
                    // 2. Success State
                    image
                        .resizable()
                        .scaledToFill()
                        
                case .failure:
                    // 3. Error State (Failed to download)
                    Color.gray.opacity(0.3)
                        .overlay(
                            Image(systemName: "photo.badge.exclamationmark")
                                .foregroundStyle(.gray)
                        )
                        
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            // 4. No URL provided State
            Color.gray.opacity(0.2)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(.gray)
                )
        }
    }
}

#Preview {
    NetworkImageView(urlString: "/media")
}
