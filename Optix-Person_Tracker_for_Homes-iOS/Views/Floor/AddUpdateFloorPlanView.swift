//
//  AddUpdateFloorPlanView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/4/26.
//

import SwiftUI
import Combine
import WebKit

struct AddUpdateFloorPlanView: View {
    
    @StateObject var floorViewModelObject = FloorViewModel()
    @StateObject private var webBridge = WebBridge()
    @State var isAddCamera: Bool = false
    var floorId: UUID
    var floorTitle: String
    // UI State
    @State private var showingCameraForm = false
    @State private var cameraName = ""
    @State private var cameraLocation = ""
    @State private var activeTool = "none"
    
    var onDismissAll: () -> Void
    
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    // Replace with your actual Mac/Server IP
    let serverURL = URL(string: "http://192.168.100.8:8888/editor")!
    
    var body: some View {
        ZStack {
            // 1. The Konva Web Engine
            WebViewContainer(url: serverURL, bridge: webBridge)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .cornerRadius(20)
                .shadow(color: .primary.opacity(0.2) ,radius: 5)
                .padding(.top, 90)
                
                //.padding()
                
            VStack{
                HStack{
                    Text("Title:")
                    Text("\(floorTitle)")
                        .bold()
                    Spacer()
                    Button {
                        print("")
                        if !isAddCamera{
                            isAddCamera = true
                        }
                        else{
                            Task{
                                await floorViewModelObject.createFloorData(planData: webBridge.latestJSON, floorId: floorId)
                                if (floorViewModelObject.errorMessage != nil){
                                    alertMessage = floorViewModelObject.errorMessage ?? ""
                                    error.toggle()
                                    isPresentAlert.toggle()
                                }
                                else{
                                    alertMessage = floorViewModelObject.addUpdateFloorPlanResponse?.message ?? ""
                                    isPresentAlert.toggle()
                                }
                            }
                            onDismissAll()
                        }
                        
                    } label: {
                        Text(isAddCamera ? "Save" : "Next")
                            .frame(width: 50, height: 20)
                            .foregroundStyle(.black)
                            //.padding(8)
                            //.background(Color.customYellow)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.customYellow)

                }
                Spacer()
            }
            //.padding(.top)
            .padding(.vertical, 35)
            .padding(.horizontal, 30)
            
            VStack {
                Spacer()
                
                // 2. Add Camera Button (Floating above bottom bar)
                
                
                
                if isAddCamera{
                    
                    Button {
                        showingCameraForm = true
                        print("Map")
                    } label: {
                        Label("Add Camera", systemImage: "plus")
                    }
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 5)
                    .buttonStyle(.glassProminent)
                    .tint(Color("custom_blue"))
                    .padding(.bottom, 10)
                    
                }
                else{
                    HStack(spacing: 20) {
                        ToolButton(title: "Wall", color: .gray, isSelected: activeTool == "wall") {
                            selectTool("wall")
                        }
                        ToolButton(title: "Window", color: .blue, isSelected: activeTool == "window") {
                            selectTool("window")
                        }
                        ToolButton(title: "Door", color: .brown, isSelected: activeTool == "door") {
                            selectTool("door")
                        }
                        ToolButton(title: "Text", color: .black, isSelected: activeTool == "text") {
                            selectTool("text")
                        }
                    }
                    .padding()
                    .padding(.top, 5)
                    //.background(Color.white)
                    //.padding(.top, 40)
                    .padding(.horizontal, 5)
                    .glassEffect()
                    //.padding()
                    //.background(Color.white)
                    //.cornerRadius(35)
                    //.shadow(color: .primary.opacity(0.2) ,radius: 5)
                }
                    // 3. Bottom Tool Bar (Wall, Window, Door)
                
                
            }
            .padding(.bottom, 30)
        }
        .interactiveDismissDisabled()
        .ignoresSafeArea(.all)
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                if !error {
                    onDismissAll()
                }
            }
        } message: {
            Text(alertMessage)
        }
        // 4. Camera Data Form Popup
        .sheet(isPresented: $showingCameraForm) {
            UpdateCCTVView(isUpdate: false,
                           floorId: floorId,
                           onSave: { newCamId, newCamName in
                
                // This runs when the user taps "OK" on the success alert!
                // Tell Javascript to spawn the camera icon
                let jsCode = "spawnCamera('\(newCamId.uuidString)', '\(newCamName)')"
                webBridge.evaluateJS(jsCode)
            })
                .presentationDragIndicator(.visible)
        }
    }
    
    private func selectTool(_ tool: String) {
        if activeTool == tool {
            activeTool = "none" // Deselect if tapped again
        } else {
            activeTool = tool
        }
        webBridge.evaluateJS("setTool('\(activeTool)')")
    }
    
}

struct WebViewContainer: UIViewRepresentable {
    let url: URL
    let bridge: WebBridge
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = bridge.makeWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

//#Preview {
//    AddUpdateFloorPlanView(floorName: "test")
//}
