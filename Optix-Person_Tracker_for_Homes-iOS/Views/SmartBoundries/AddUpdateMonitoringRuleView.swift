//
//  AddUpdateMonitoringRuleView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 8/5/26.
//

import SwiftUI
import SwiftData

struct AddUpdateMonitoringRuleView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    // Core properties
    let isUpdate: Bool
    @State var ruleId = UUID()
    @State var ruleName: String = ""
    
    // Family Member Selection
    @State var selectedFamilyMemberId: UUID? = nil
    
    // Camera Network Logic
    @State var linkedCameras: [CamerasObject] = []
    @State var unlinkedCameras: [CamerasObject] = []
    
    // Time Interval Logic
    @State var hasTimeInterval: Bool = false
    @State var fromTime: Date = Date()
    @State var toTime: Date = Date().addingTimeInterval(3600) // Default to 1 hour later
    
    
    // Status Logic
    @State var isActive: Bool = true
    
    // Alert Handling
    @State var alertMessage: String = ""
    @State var isPresentAlert: Bool = false
    @State var error: Bool = false
    
    // ViewModels
    @StateObject var smartBoundriesViewModelObject = SmartBoundriesViewModel()
    @StateObject var cctvViewModelObject = CCTVViewModel()
    // Assuming you have this
    //@StateObject var familyViewModel = FamilyViewModel() // Assuming you have this for getting family members
    
    let autoColumns = [
            GridItem(.adaptive(minimum: 100), spacing: 25)
        ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // MARK: - 1. Name TextField
                    Text("Name:")
                        .bold()
                        .padding(.horizontal, 14)
                    TextField("Enter rule name", text: $ruleName)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(height: 50)
                        .glassEffect()
                        .padding(.bottom, 30)
                    
                    // MARK: - 2. Family Member Picker
                    Text("Select Family Member:")
                        .bold()
                        .padding(.horizontal, 14)
                    Picker(selection: $selectedFamilyMemberId) {
                        
                        // 1. Default / Unknown Option
                        HStack {
                            ZStack {
                                Color.gray.opacity(0.2)
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(18)
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                            Text("Select a Family Member")
                            Spacer()
                        }
                        .tag(nil as UUID?)
                        
                        // 2. Loop through your fetched family members
                        ForEach(smartBoundriesViewModelObject.familyMembersList, id: \.id) { member in
                            ListCard(
                                cardType: .family,
                                id: UUID(uuidString: member.id) ?? UUID(),
                                name: member.name,
                                relationship: member.relationship,
                                type:"FAMILY", // Hardcoded or map it if you have it in your struct
                                photo: member.photo ?? ""
                            )
                            // Do the UUID conversion directly in the tag
                            .tag(UUID(uuidString: member.id) as UUID?)
                        }
                        
                    } label: {
                        // Keep your nice custom UI for the button here!
                    }
                    .pickerStyle(.navigationLink)
                    .padding(.bottom, 30)
                    
                    // MARK: - 3. Linked Cameras
                    Text("Linked Cameras:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .foregroundStyle(Color("custom_color"))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        .overlay {
                            ScrollView {
                                VStack(spacing: 20) {
                                    cameraGridLoop(list: linkedCameras, isLinked: true)
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 25)
                            }
                            .scrollIndicators(.hidden)
                        }
                        .padding(.bottom, 20)
                    
                    // MARK: - 4. Unlinked Cameras
                    Text("Unlinked Cameras:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .foregroundStyle(Color("custom_color"))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        .overlay {
                            ScrollView {
                                VStack(spacing: 20) {
                                    cameraGridLoop(list: unlinkedCameras, isLinked: false)
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 25)
                            }
                            .scrollIndicators(.hidden)
                        }
                        .padding(.bottom, 30)
                    
                    // MARK: - 5. Time Interval
                    Text("Time Interval:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    VStack {
                        Toggle("Enable Time Limit", isOn: $hasTimeInterval)
                            //.padding(.horizontal, 14)
                            .padding(.bottom, 10)
                        
                        if hasTimeInterval {
                            DatePicker("Start Time", selection: $fromTime, displayedComponents: .hourAndMinute)
                                .environment(\.dynamicTypeSize, .small)
                            
                            DatePicker("End Time", selection: $toTime, displayedComponents: .hourAndMinute)
                                .environment(\.dynamicTypeSize, .small)
                        }
                    }
                    .padding()
                    //.glassEffect()
                    .padding(.bottom, 30)
                    
                    // MARK: - 6. Status Picker
                    Text("Status:")
                        .bold()
                        .padding(.horizontal, 14)
                    
                    Picker("Select the Option", selection: $isActive) {
                        Text("Active")
                            .tag(true)
                        Text("InActive")
                            .tag(false)
                    }
                    .pickerStyle(.palette)
                    .padding(.bottom, 40)
                    
                    // MARK: - 7. Save Button
                    HStack(alignment: .center) {
                        PrimaryButton(buttonText: isUpdate ? "Update" : "Save", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                            
                            // 1. Validation Logic
                            if ruleName.isEmpty {
                                triggerAlert(message: "Please enter a rule name.", isError: true)
                                return
                            }
                            if selectedFamilyMemberId == nil {
                                triggerAlert(message: "Please select a family member.", isError: true)
                                return
                            }
                            if hasTimeInterval && toTime <= fromTime {
                                triggerAlert(message: "End time must be greater than Start time.", isError: true)
                                return
                            }
                            
                            // 2. Format Dates to Time Strings if enabled
                            var fromTimeString: String? = nil
                            var toTimeString: String? = nil

                            if hasTimeInterval {
                                let formatter = DateFormatter()
                                // Using standard Internet Date Time format which outputs like: "2026-05-08T14:30:00Z"
                                formatter.dateFormat = "HH:mm:ssZZZZZ"
                                    
                                fromTimeString = formatter.string(from: fromTime)
                                toTimeString = formatter.string(from: toTime)
                            }
                            
                            // Extract UUIDs from Linked Cameras
                            let linkedUUIDs = linkedCameras.compactMap { UUID(uuidString: $0.id) }
                            
                            Task {
                                if isUpdate {
                                    await smartBoundriesViewModelObject.updateMonitoringRule(
                                        ruleId: ruleId,
                                        ruleName: ruleName,
                                        personId: selectedFamilyMemberId!,
                                        cameraIds: linkedUUIDs,
                                        fromTime: fromTimeString,
                                        toTime: toTimeString,
                                        isActive: isActive
                                    )
                                } else {
                                     //Assumes a createMonitoringRule function exists
                                    await smartBoundriesViewModelObject.createMonitoringRule(
                                        ruleName: ruleName,
                                        personId: selectedFamilyMemberId!,
                                        cameraIds: linkedUUIDs,
                                        fromTime: fromTimeString,
                                        toTime: toTimeString,
                                        isActive: isActive
                                    )
                                }
                                
                                if let errorMsg = smartBoundriesViewModelObject.errorMessage {
                                    triggerAlert(message: errorMsg, isError: true)
                                } else {
                                    triggerAlert(message: isUpdate ? "Rule updated successfully!" : "Rule created successfully!", isError: false)
                                }
                            }
                        }, isLoading: smartBoundriesViewModelObject.isLoading)
                    }
                    Spacer()
                }
                .padding(.all, 30)
            }
            .navigationTitle(isUpdate ? "Edit Rule" : "Add Rule")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                Task{
                    await smartBoundriesViewModelObject.fetchAllFamilyMembers()
                            
                            if isUpdate {
                                // Fetch previously linked and unlinked cameras
                                await smartBoundriesViewModelObject.fetchRuleCameras(ruleId: ruleId)
                                
                                // Wait for the ViewModel to populate its arrays, then assign to local View state
                                self.linkedCameras = smartBoundriesViewModelObject.linkedCameras
                                self.unlinkedCameras = smartBoundriesViewModelObject.unlinkedCameras
                            } else {
                                // For a NEW rule, you would likely fetch ALL cameras as "Unlinked"
                                // from your cctvViewModel, mapping them to RuleCamera structs.
                                // Example mapping assuming you have access to CCTV list:
                                
                                await cctvViewModelObject.fetchCCTVlist(context: context)
                                 self.unlinkedCameras = cctvViewModelObject.cctvlist.map { CamerasObject(id: $0.id.uuidString, name: $0.name) }
                            }
                }
            }
            .alert(error ? "Error" : "Success", isPresented: $isPresentAlert) {
                Button("OK", role: .cancel) {
                    if !error { dismiss() }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    @ViewBuilder
        func cameraGridLoop(list: [CamerasObject], isLinked: Bool) -> some View {
            LazyVGrid(columns: autoColumns, spacing: 25) {
                ForEach(list) { camera in
                    CameraNetworkItem(status: isLinked, cameraName: camera.name) {
                        if isLinked {
                            print("Unlinking camera: \(camera.name)")
                            unlinkedCameras.append(camera)
                            linkedCameras.removeAll { $0.id == camera.id }
                        } else {
                            print("Linking camera: \(camera.name)")
                            linkedCameras.append(camera)
                            unlinkedCameras.removeAll { $0.id == camera.id }
                        }
                    }
                }
            }
        }
    func triggerAlert(message: String, isError: Bool) {
            self.alertMessage = message
            self.error = isError
            self.isPresentAlert = true
        }
}
//#Preview {
//    AddUpdateMonitoringRuleView()
//}
