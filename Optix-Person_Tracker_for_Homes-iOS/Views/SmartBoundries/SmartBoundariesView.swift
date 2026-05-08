//
//  SmartBoundariesView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import SwiftUI
import SwiftData

struct SmartBoundariesView: View {
    
    @StateObject var smartBoundriesViewModelObject = SmartBoundriesViewModel()
    @State var smartBoundriesToDelete: MonitoringRule?
    @State var smartBoundriesToUpdate: MonitoringRule?
    @State var smartBoundriesToToggle: MonitoringRule?
    @State var smartBoundriesForDetails: MonitoringRule?
    @State var isShowingSheetAddRule: Bool = false
    @State var showDeleteAlert: Bool = false
    @Environment(\.modelContext) private var context
    
    
    @State var alertMessage: String = ""
    @State var error: Bool = false
    @State var isPresentAlert: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                // Spacer for Floating Header
                Color.clear.frame(height: 120)
                
                // Section Title
                HStack{
                    Text("Smart Boundaries")
                    Spacer()
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    
                    // CASE 1: Floor list is Empty
                    if smartBoundriesViewModelObject.monitoringRuleList.isEmpty {
                        VStack{
                            HStack(spacing: 10) {
                                Image(systemName: "heart.text.square")
                                    .font(.system(size: 20))
                                Text("No Monitoring Rules found!")
                                    .font(.headline)
                            }
                            .padding(.top, 50)
                            HStack{
                                Text("Tap the + button to add one.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.top, 5)
                            
                        }
                        
                        // CASE 2: List of Floors
                    } else {
                        ForEach(smartBoundriesViewModelObject.monitoringRuleList) { rule in
                            SmartBoundriesCard(id: UUID(uuidString: rule.id) ?? UUID(), title: rule.ruleName, name: rule.personName, photo: rule.photo, isActive: rule.isActive, action: {
                                smartBoundriesForDetails = rule
                            })
                            .contextMenu {
                                Button{
                                    print("Activate/Deactivate Tapped")
                                    Task{
                                        await smartBoundriesViewModelObject.toggleMonitoringRule(ruleId: UUID(uuidString: rule.id) ?? UUID(), isActive: rule.isActive ? false : true)
                                    }
                                } label: {
                                    Text(rule.isActive ? "Deactivate" : "Activate")
                                }
                                Button {
                                    print("Edit Tapped")
                                    smartBoundriesToUpdate = rule
                                } label: {
                                    Text("Edit")
                                }
                                
                                Button(role: .destructive) {
                                    print("Delete Tapped")
                                    showDeleteAlert.toggle()
                                    smartBoundriesToDelete = rule
                                } label: {
                                    Text("Delete")
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                Spacer()
                
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isShowingSheetAddRule = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .bold()
                            .frame(width: 40, height: 50)
                    }
                    .padding(20)
                    .buttonStyle(.glassProminent)
                    .tint(Color("custom_blue"))
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 10)
            
            // MARK: - Layer 2: Floating Header
            VStack{
                VStack(alignment: .leading) {
                    HStack {
                        Text("Smart Boundries")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                
                if smartBoundriesViewModelObject.isLoading {
                    HStack{
                        ProgressView()
                            .tint(.customBlue)
                        Text("Connecting...")
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                    }
                    .padding(2)
                    .frame(width: 130, height: 30)
                    .glassEffect()
                }
                
                Spacer()
            }
        }
        .onAppear(){
            Task{
                await smartBoundriesViewModelObject.fetchAllMonitoringRules()
                print(smartBoundriesViewModelObject.monitoringRuleList)
            }
        }
        .refreshable {
            Task{
                await smartBoundriesViewModelObject.fetchAllMonitoringRules()
            }
        }
        .alert("Delete Smart Boundries?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let rule = smartBoundriesToDelete {
                    Task{
                        await smartBoundriesViewModelObject.deleteMonitoringRule(ruleId: UUID(uuidString: rule.id) ?? UUID())
                        if (smartBoundriesViewModelObject.errorMessage != nil){
                            alertMessage = smartBoundriesViewModelObject.errorMessage ?? ""
                            error.toggle()
                            isPresentAlert.toggle()
                        }
                        else{
                            alertMessage = smartBoundriesViewModelObject.updateDeleteMonitoringRuleResponse?.message ?? ""
                            isPresentAlert.toggle()
                        }
                    }
                    print("Deleted \(rule.ruleName)")
                }
            }
        }message: {
            Text("Are you sure you want to delete this camera? Log related to this camera will also be deleted and this action cannot be undone.")
        }
        .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
            Button("OK", role: .cancel) {
                if error{
                    error.toggle()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $isShowingSheetAddRule, content: {
            AddUpdateMonitoringRuleView(isUpdate: false)
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $smartBoundriesForDetails, content: { rule in
            MonitoringRuleDetailView(rule: rule)
        })
        .sheet(item: $smartBoundriesToUpdate, content: { rule in
            // 1. Determine if this rule has a time interval enabled
            let hasTime = (rule.fromTime != nil && rule.toTime != nil)
            
            // 2. Safely parse UUIDs (Assuming your rule object uses String IDs. If they are already UUIDs, just pass `rule.id`)
            let safeRuleId = UUID(uuidString: rule.id) ?? UUID()
            let safePersonId = UUID(uuidString: rule.personId)
            
            AddUpdateMonitoringRuleView(
                isUpdate: true,
                ruleId: safeRuleId,
                ruleName: rule.ruleName,
                selectedFamilyMemberId: safePersonId,
                
                // Note: linkedCameras and unlinkedCameras are intentionally omitted here
                // because your `onAppear` task automatically fetches them using the ruleId!
                
                hasTimeInterval: hasTime,
                fromTime: convertDBTimeToDate(timeString: rule.fromTime),
                toTime: convertDBTimeToDate(timeString: rule.toTime, isDefaultEnd: true),
                isActive: rule.isActive
            )
        })
    }
    // MARK: - Time Conversion Helper
    func convertDBTimeToDate(timeString: String?, isDefaultEnd: Bool = false) -> Date {
        guard let timeString = timeString, !timeString.isEmpty else {
            // Return current time for 'fromTime', or 1 hour later for 'toTime' if null
            return isDefaultEnd ? Date().addingTimeInterval(3600) : Date()
        }
        
        let formatter = DateFormatter()
        
        // Attempt 1: Parse with Timezone (e.g., "14:30:00+05:00")
        formatter.dateFormat = "HH:mm:ssZZZZZ"
        if let date = formatter.date(from: timeString) {
            return date
        }
        
        // Attempt 2: Fallback to plain 24-hour time if backend stripped timezone (e.g., "14:30:00")
        formatter.dateFormat = "HH:mm:ss"
        if let date = formatter.date(from: timeString) {
            return date
        }
        
        // Final Fallback if parsing fails
        print("Warning: Could not parse database time string: \(timeString)")
        return isDefaultEnd ? Date().addingTimeInterval(3600) : Date()
    }
}
#Preview {
    SmartBoundariesView()
}
