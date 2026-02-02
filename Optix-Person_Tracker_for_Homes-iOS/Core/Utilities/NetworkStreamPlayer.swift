////
////  NetworkStreamPlayer.swift
////  Optix-Person_Tracker_for_Homes-iOS
////
////  Created by Hussnain on 28/1/26.
////
//
//import SwiftUI
//import WebKit
//
//struct NetworkStreamPlayer: UIViewRepresentable {
//    let urlString: String?
//    
//    // Your Base URL logic
//    let baseURL = "http://192.168.100.31:8888/"
//    
//    func makeUIView(context: Context) -> WKWebView {
//        // 1. Configure WebView to look like a Video Player
//        let webConfiguration = WKWebViewConfiguration()
//        
//        // This allows inline media playback (crucial for some streams)
//        webConfiguration.allowsInlineMediaPlayback = true
//        
//        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        
//        // 2. Visual Cleanup (Remove scroll, bounce, and white background)
//        webView.scrollView.isScrollEnabled = false
//        webView.scrollView.bounces = false
//        webView.backgroundColor = .black
//        webView.isOpaque = false // Allows black background to show
//        
//        // 3. Scale content to fit the frame automatically
//        webView.contentMode = .scaleAspectFit
//        webView.
//        
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // 4. Construct the Full URL
//        guard let path = urlString, !path.isEmpty else { return }
//        
//        var finalURL: URL?
//        if path.hasPrefix("http") {
//            finalURL = URL(string: path)
//        } else {
//            finalURL = URL(string: baseURL + path)
//        }
//        
//        // 5. Load the Request
//        if let url = finalURL {
//            let request = URLRequest(url: url)
//            // Check if we are already loading this URL to avoid refreshing unnecessarily
//            if uiView.url != url {
//                uiView.load(request)
//            }
//        }
//    }
//}
//
//// Preview
//#Preview {
//    NetworkStreamPlayer(urlString: "http://192.168.100.133:8080/video")
//        .frame(height: 225)
//        .background(Color.black)
//        .cornerRadius(12)
//}


import SwiftUI
import WebKit

struct NetworkStreamPlayer: View {
    let urlString: String?
    @State private var isFullScreen = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) { // Default alignment for the Expand Button
            
            // 1. The Video Stream
            StreamWebView(urlString: urlString)
            
            // 2. The LIVE Badge (Aligned Top-Left)
            VStack {
                HStack {
                    // LIVE Badge Code
                    HStack(spacing: 4) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .symbolEffect(.pulse) // iOS 17+ animation
                            .bold()
                            .font(.caption2)
                        Text("LIVE")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(7)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Push to left
                .padding(12) // Spacing from edge
                
                Spacer() // Pushes everything else down
            }
            
            // 3. The "Full Screen" Button (Aligned Bottom-Right)
            Button {
                isFullScreen = true
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(12)
        }
        // Full Screen Logic (Same as before)
        .fullScreenCover(isPresented: $isFullScreen) {
            VStack{
                StreamWebView(urlString: urlString)
//                VStack(alignment: .center){
//                    Spacer()
//                    HStack(alignment: .center){
//                        Spacer()
//                        StreamWebView(urlString: urlString)
//                            //.ignoresSafeArea()
//                        Spacer()
//                    }
//                    Spacer()
//                }
                VStack{
                    HStack{
                        HStack {
                            Image(systemName: "dot.radiowaves.left.and.right")
                            .symbolEffect(.pulse)
                            Text("LIVE")
                        }
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(.red)
                        .cornerRadius(5)
                        .padding(.leading, 15)
                        Spacer()
                        Button {
                            isFullScreen = false
                        } label: {
                            Image(systemName: "xmark")
                                //.font(.title3.bold())
                                .foregroundStyle(Color.black)
                                .bold()
                                .frame(width: 20, height: 30)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("custom_yellow"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    }
                    //Spacer()
                }
            }
//            ZStack(alignment: .center) {
//                Color.black.ignoresSafeArea()
//                VStack(alignment: .center){
//                    Spacer()
//                    HStack(alignment: .center){
//                        Spacer()
//                        StreamWebView(urlString: urlString)
//                            //.ignoresSafeArea()
//                        Spacer()
//                    }
//                    Spacer()
//                }
//                .overlay {
//                    VStack{
//                        HStack{
//                            HStack {
//                                Image(systemName: "dot.radiowaves.left.and.right")
//                                .symbolEffect(.pulse)
//                                Text("LIVE")
//                            }
//                            .foregroundStyle(.white)
//                            .padding(8)
//                            .background(.red)
//                            .cornerRadius(5)
//                            //.padding(.top, 50) // Adjust for safe area
//                            .padding(.leading, 15)
//                            Spacer()
//                            Button {
//                                isFullScreen = false
//                            } label: {
//                                Image(systemName: "xmark")
//                                    //.font(.title3.bold())
//                                    //.foregroundStyle(.white)
//                                    .bold()
//                                    .frame(width: 20, height: 30)
//                                    //.padding(8)
//    //                                .background(.black.opacity(0.5))
//    //                                .clipShape(Circle())
//                            }
//                            //.frame(width: 70, height: 50)
//                            .buttonStyle(.glass)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 10)
//                            //.padding(20)
//                        }
//                        Spacer()
//                    }
//                }
//                
////                StreamWebView(urlString: urlString)
////                    .ignoresSafeArea()
//                
//                //Spacer()
//                
//                
//                // Close Button
//                
//                
//                // Show LIVE badge in full screen too? (Optional)
//                
//            }
            .background(Color.black)
        }
    }
}

// Internal Engine (No changes needed here)
struct StreamWebView: UIViewRepresentable {
    let urlString: String?
    let baseURL = "http://192.168.100.31:8888/"
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.isUserInteractionEnabled = false
        webView.contentMode = .scaleAspectFit
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let path = urlString, !path.isEmpty else { return }
        var finalURL: URL?
        if path.hasPrefix("http") { finalURL = URL(string: path) }
        else { finalURL = URL(string: baseURL + path) }
        
        if let url = finalURL {
            let request = URLRequest(url: url)
            if uiView.url != url { uiView.load(request) }
        }
    }
}

#Preview {
    NetworkStreamPlayer(urlString: "http://192.168.100.133:8080/video")
        .frame(height: 205)
        .background(Color.black)
        .cornerRadius(12)
        .padding()
}
