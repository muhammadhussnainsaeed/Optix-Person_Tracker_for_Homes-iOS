//
//  FloorPlanView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 18/4/26.
//

import SwiftUI

struct FloorPlanView: View {
    
    @StateObject private var webBridge = WebBridge()
    var floorTitle: String
    var floorId: UUID
        // Pass the raw JSON string you got from your database into here
    @State var floorPlanData: String = ""
        
    @Environment(\.dismiss) var dismiss
    @StateObject var floorViewModelObject = FloorViewModel()
    // We use the exact same editor URL, because the JS setViewerMode() function will lock it
    let serverURL = URL(string: "http://192.168.31.205:8888/editor")!
    
    var body: some View {
        ZStack {
            // 1. The Konva Web Engine (Exact same styling as editor)
            WebViewContainer(url: serverURL, bridge: webBridge)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .cornerRadius(20)
                .shadow(color: .primary.opacity(0.2) ,radius: 5)
                .padding(.top, 90)
            
            // 2. Top Header
            VStack{
                HStack{
                    Text("Title:")
                    Text("\(floorTitle)")
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .frame(width: 50, height: 20)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.customYellow)
                }
                Spacer()
            }
            .padding(.vertical, 35)
            .padding(.horizontal, 30)
            
            // Optional: Loading Spinner while the webpage boots up
            if !webBridge.isPageLoaded {
                VStack {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Loading map...")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
            }
        }
        .onAppear(){
            Task{
                await floorViewModelObject.fetchFloorData(floorId: floorId)
                if floorViewModelObject.errorMessage == nil {
                    floorPlanData = floorViewModelObject.floorPlanResponse?.plan ?? ""
                }
            }
        }
        .ignoresSafeArea(.all)
        // 3. Inject data safely when the page is loaded
        .onChange(of: webBridge.isPageLoaded) { oldValue, newValue in
            if newValue == true {
                webBridge.injectDataAndLockCanvas(floorPlanData: floorPlanData)
            }
        }
    }
}

#Preview {
    FloorPlanView(floorTitle: "test", floorId: UUID())
}
