//
//  WebBridge.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/4/26.
//

import Foundation
import WebKit
import Combine

// 🚀 Add WKNavigationDelegate here
class WebBridge: NSObject, ObservableObject, WKScriptMessageHandler, WKNavigationDelegate {
    var webView: WKWebView?
    
    @Published var latestJSON: String = "{}"
    @Published var isSaving: Bool = false
    
    // 🚀 NEW: Tracks when the HTML is fully loaded
    @Published var isPageLoaded: Bool = false
    
    func makeWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        let controller = WKUserContentController()
        // This matches the JS 'window.webkit.messageHandlers.optixBridge'
        controller.add(self, name: "optixBridge")
        config.userContentController = controller
        
        let wv = WKWebView(frame: .zero, configuration: config)
        
        // 🚀 NEW: Tell the webview that this class will handle its navigation events
        wv.navigationDelegate = self
        
        wv.isOpaque = false
        wv.backgroundColor = .clear
        wv.isInspectable = true
        wv.scrollView.isScrollEnabled = false // Let Konva handle dragging
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        self.webView = wv
        return wv
    }
    
    // 🚀 NEW: This fires automatically when the FastAPI HTML page finishes loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.isPageLoaded = true
        }
    }
    
    func evaluateJS(_ code: String) {
        webView?.evaluateJavaScript(code, completionHandler: { _, error in
            if let error = error { print("JS Error: \(error)") }
        })
    }
    
    // Receives the JSON data from JS `notifyNativeSave()`
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "optixBridge", let jsonString = message.body as? String {
            DispatchQueue.main.async {
                self.latestJSON = jsonString
            }
            print(jsonString)
            print("Received JSON from Konva! Ready to send to FastAPI /api/save")
            // TODO: Use URLSession here to POST jsonString to your FastAPI backend
        }
    }
}
