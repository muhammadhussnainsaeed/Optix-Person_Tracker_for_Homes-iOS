//
//  ImageView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 14/2/26.
//

import SwiftUI

struct ImageView: View {
    
    let urlString: String?
    let localImage: UIImage?
    let baseURL = "http://192.168.100.8:8000/"
    
    var fullURL: URL? {
        guard let path = urlString, !path.isEmpty else { return nil }
        if path.hasPrefix("http") { return URL(string: path) }
        else { return URL(string: baseURL + path) }
    }
    
    
    
    var body: some View {
        Group {
            if let uiImage = localImage {
                Image(uiImage: uiImage)
                    .resizable()
            }
            else if let url = fullURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                        }
                    case .failure:
                        placeholderView
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            else {
                placeholderView
            }
        }
        // 2. These modifiers apply to whatever view is returned above
        .scaledToFill()
        // 3. This is the crucial part that replaces GeometryReader logic:
        //    It allows the image to fill the frame you give it in the parent view.
        .clipped()
    }
    
    var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(20) // Add padding so icon isn't huge
                .foregroundStyle(.gray)
        }
    }
    
}

#Preview {
    ImageView(urlString: "media/persons/4f9e6836-cd16-4ae3-9206-fea37dff3520_1.jpg", localImage: nil)
        .frame(width: 150, height: 150)
}
