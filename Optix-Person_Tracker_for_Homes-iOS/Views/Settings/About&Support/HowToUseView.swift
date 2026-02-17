//
//  HowToUseView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 16/2/26.
//

import SwiftUI

import SwiftUI

struct HowToUseView: View {
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to Optix")
                            .font(.title3)
                            .fontWeight(.bold)
                            //.foregroundStyle(Color("custom_blue")) // Use your app's primary color
                        
                        Text("Optix helps you keep track of your loved ones and secure your home using smart presence detection. Here is how to get started.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: - 1. Connection
                Section(header: Text("1. Connection")) {
                    Text("To use Optix, your phone needs to talk to your home system.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Label {
                        VStack(alignment: .leading) {
                            Text("Wi-Fi")
                                .fontWeight(.medium)
                            Text("Make sure your phone is connected to your home Wi-Fi network.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "wifi")
                            .foregroundStyle(.blue)
                    }
                    .padding(.vertical, 4)
                    
                    Label {
                        VStack(alignment: .leading) {
                            Text("System Status")
                                .fontWeight(.medium)
                            Text("Ensure your main Optix Hub (computer) is turned on and running.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "desktopcomputer")
                            .foregroundStyle(.blue)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - 2. Family & Faces
                Section(header: Text("2. Family & Faces")) {
                    Text("Teach Optix to recognize the people in your home.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Label {
                        VStack(alignment: .leading) {
                            Text("Add a Person")
                                .fontWeight(.medium)
                            Text("Go to the **Family** tab and tap **+**.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "photo.stack")
                                .foregroundStyle(.orange)
                            Text("Photos Requirement")
                                .fontWeight(.medium)
                        }
                        
                        Text("You must select exactly **3 clear photos** of their face.")
                            .font(.caption)
                        
                        Text("💡 **Success Tip:** Use photos with good lighting. Avoid sunglasses, masks, or heavy shadows.")
                            .font(.caption)
                            .padding(8)
                            .background(Color.yellow.opacity(0.15))
                            .cornerRadius(8)
                        
                        Text("**Why 3?** This helps our smart system learn to recognize them accurately from different angles.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - 3. Monitoring
                Section(header: Text("3. Monitoring")) {
                    Text("Keep an eye on what matters most.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Label {
                        VStack(alignment: .leading) {
                            Text("Live View")
                                .fontWeight(.medium)
                            Text("Tap any camera on the Dashboard to see a live video feed.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "play.tv.fill")
                            .foregroundStyle(.red)
                    }
                    
                    Label {
                        VStack(alignment: .leading) {
                            Text("Camera Network")
                                .fontWeight(.medium)
                            Text("Use the **Network View** to see active cameras and their connections.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "network")
                            .foregroundStyle(.blue)
                    }
                }
                
                // MARK: - 4. Troubleshooting
                Section(header: Text("4. Troubleshooting")) {
                    Text("Having trouble connecting?")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Label("Check that your Wi-Fi is on.", systemImage: "checkmark.circle")
                    Label("Ensure the Optix Hub computer hasn't gone to sleep.", systemImage: "checkmark.circle")
                    
                    VStack(alignment: .leading) {
                        Text("⚠️ \"Missing Field\" Error")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                        Text("This usually means a profile is missing a name or doesn't have exactly 3 photos.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                
                // MARK: - 5. Privacy
                Section {
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "lock.shield.fill")
                            .font(.title)
                            .foregroundStyle(.green)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Your Privacy First")
                                .font(.headline)
                            
                            Text("All face recognition and video processing happen locally in your home. Your personal photos and data never leave your secure home network.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("How to Use")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HowToUseView()
}
