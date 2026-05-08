//
//  MonitoringRuleDetailView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 8/5/26.
//

import SwiftUI

import SwiftUI

struct MonitoringRuleDetailView: View {
    
    // Pass the entire rule object directly!
    let rule: MonitoringRule
    
    let autoColumns = [
        GridItem(.adaptive(minimum: 100), spacing: 25)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: - 1. Rule Name
                Text("Name:")
                    .bold()
                    .padding(.horizontal, 14)
                
                Text(rule.ruleName)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect()
                    .padding(.bottom, 30)
                
                // MARK: - 2. Family Member Info
                Text("Assigned Family Member:")
                    .bold()
                    .padding(.horizontal, 14)
                
                HStack(spacing: 15) {
                    // Profile Picture Logic
                    if !rule.photo.isEmpty, let url = URL(string: rule.photo) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text(rule.personName)
                            .foregroundColor(.primary)
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color("custom_color"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
                .padding(.bottom, 30)
                
                // MARK: - 3. Linked Cameras
                Text("Monitored Cameras:")
                    .bold()
                    .padding(.horizontal, 14)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 120)
                    .foregroundStyle(Color("custom_color"))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .overlay {
                        VStack(spacing: 20) {
                            // Safely unwrap the optional cameras array
                            let linkedCameras = rule.cameras ?? []
                            
                            if linkedCameras.isEmpty {
                                Text("No cameras linked to this rule.")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            } else {
                                cameraGridLoop(list: linkedCameras)
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 25)
                    }
                    .padding(.bottom, 30)
                
                // MARK: - 4. Time Interval (Conditional)
                if let startTime = rule.fromTime, let endTime = rule.toTime, !startTime.isEmpty, !endTime.isEmpty {
                    Text("Time Interval:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Start Time:")
                            Spacer()
                            Text(startTime)
                                .bold()
                        }
                        
                        HStack {
                            Text("End Time:")
                            Spacer()
                            Text(endTime)
                                .bold()
                        }
                    }
                    .padding()
                    .glassEffect()
                    .padding(.bottom, 30)
                }
                
                // MARK: - 5. Status
                Text("Status:")
                    .bold()
                    .padding(.horizontal, 14)
                
                HStack {
                    Circle()
                        .fill(rule.isActive ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    
                    Text(rule.isActive ? "Active" : "Inactive")
                        .bold()
                        .foregroundColor(rule.isActive ? .green : .red)
                    
                    Spacer()
                }
                .padding()
                .frame(height: 50)
                .glassEffect()
                .padding(.bottom, 40)
                
                Spacer()
            }
            .padding(.all, 30)
        }
        .navigationTitle("Rule Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    @ViewBuilder
    func cameraGridLoop(list: [CamerasObject]) -> some View {
        LazyVGrid(columns: autoColumns, spacing: 25) {
            ForEach(list) { camera in
                CameraNetworkItem(status: true, cameraName: camera.name) { }
            }
        }
    }
}
