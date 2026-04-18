//
//  InvestigateView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/3/26.
//

import SwiftUI
import SwiftData

struct InvestigateView: View {
    
    @State var cameraId: UUID? = nil
    @State var fromDate: Date = Date()
    @State var toDate: Date = Date()
    @State var familyLog: Logs?
    @State var unwantedLog: Logs?
    
    @State var isShowingSheetFamilyLogsList: Bool = false
    @State var isShowingSheetUnwantedLogsList: Bool = false
    
    @State var familyLogObjectForDetails: Logs?
    @State var unwantedLogObjectForDetails: Logs?
    
    @Environment(\.modelContext) private var context
    @StateObject var investigateViewModelObject = InvestigateViewModel()
    
    var type : [String] = ["All", "Family", "Unwanted"]
    @State var selectedType : String = "All"
    
    @StateObject var cctvViewModelObject = CCTVViewModel()
    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollView {
                // Spacer for Floating Header
                Color.clear.frame(height: 120)
                VStack{
                    HStack(spacing: 20){
                        Text("Camera:")
                        Spacer()
                        Picker("Select the Room", selection: $cameraId) {
                            
                            // 1. The "All" option, explicitly tagged as nil
                            Text("All").tag(UUID?.none)
                            
                            // 2. The rest of your dynamically loaded cameras
                            ForEach(cctvViewModelObject.cctvlist) { object in
                                // Wrap the tag in Optional() so the types match perfectly
                                Text(object.name).tag(Optional(object.id))
                            }
                        }
                        .pickerStyle(.menu)
                        .clipShape(Capsule())
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .glassEffect()
                    }
                    .padding(.bottom, 30)
                    
                    HStack{
                        Text("Time Interval:")
                        Spacer()
                    }
                    DatePicker("Start Date", selection: $fromDate, in: ...toDate)
                        .environment(\.dynamicTypeSize, .small)
                    DatePicker("End Date", selection: $toDate, in: ...toDate)
                        //.font(.callout)
                        .environment(\.dynamicTypeSize, .small)
                        .padding(.bottom, 30)
                    
                    HStack(spacing: 20){
                        Text("Type:")
                        Spacer()
                        Picker("Select type", selection: $selectedType){
                            ForEach(type, id: \.self) { obj in
                                Text(obj).tag(obj)
                            }
                            
                        }
                        .pickerStyle(.menu)
                        .clipShape(Capsule())
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .glassEffect()
                    }
                    .padding(.bottom, 20)
                }
                // Section Title
                .padding(.horizontal, 35)
                .padding(.top, 30)
                //.padding(.bottom, 20)
                
                HStack(alignment: .center) {
                    PrimaryButton(buttonText: "Search", buttonTextColor: .black, buttonColor: "custom_yellow", action: {
                        Task{
                            await investigateViewModelObject.investigate(cameraId: cameraId ?? nil, type: selectedType, startDate: fromDate, endDate: toDate)
                            
                            familyLog = investigateViewModelObject.logList.first(where: { $0.eventType == "family_detected" })
                            unwantedLog = investigateViewModelObject.logList.first(where: { $0.eventType == "unwanted_detected" })
                        }
                        
                    }, isLoading: investigateViewModelObject.isLoading)
                    .padding(.all, 30)
                }
                
                // Results Section
                VStack(spacing: 25) {
                    
                    // Family Log Block
                    if let familyLog = familyLog {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Family Logs")
                                Spacer()
                                Button {
                                    isShowingSheetFamilyLogsList.toggle()
                                } label: {
                                    HStack {
                                        Text("View all")
                                            .font(.footnote)
                                            .foregroundStyle(Color.primary)
                                        RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                                    }
                                }
                            }
                            .padding(.horizontal, 35)
                            
                            InfoCard(
                                cardType: .familylog,
                                id: familyLog.id,
                                name: familyLog.name,
                                roomName: familyLog.roomName,
                                floorName: familyLog.floorTitle,
                                description: "",
                                detected_date: AppFormatter.shared.getFormattedDate(from: familyLog.detectedAt),
                                detected_time: AppFormatter.shared.getFormattedTime(from: familyLog.detectedAt),
                                photo: familyLog.personPhoto,
                                relationship: ""
                            ) {
                                familyLogObjectForDetails = unwantedLog
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    
                    // Unwanted Log Block
                    if let unwantedLog = unwantedLog {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Unwanted Logs")
                                Spacer()
                                Button {
                                    isShowingSheetUnwantedLogsList.toggle()
                                } label: {
                                    HStack {
                                        Text("View all")
                                            .font(.footnote)
                                            .foregroundStyle(Color.primary)
                                        RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                                    }
                                }
                            }
                            .padding(.horizontal, 35)
                            
                            InfoCard(
                                cardType: .alert,
                                id: unwantedLog.id,
                                name: unwantedLog.name,
                                roomName: unwantedLog.roomName,
                                floorName: unwantedLog.floorTitle,
                                description: "",
                                detected_date: AppFormatter.shared.getFormattedDate(from: unwantedLog.detectedAt),
                                detected_time: AppFormatter.shared.getFormattedTime(from: unwantedLog.detectedAt),
                                photo: unwantedLog.personPhoto,
                                relationship: ""
                            ) {
                                unwantedLogObjectForDetails = unwantedLog
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
                .padding(.bottom, 150)
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            // MARK: - Layer 2: Floating Header
            VStack{
                VStack(alignment: .leading) {
                    HStack {
                        Text("Investigate")
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
                
                if investigateViewModelObject.isLoading {
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
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $isShowingSheetFamilyLogsList, content: {
            InvestigateFamilyLogListView(familyLogs: investigateViewModelObject.logList.filter({ $0.eventType == "family_detected" }))
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isShowingSheetUnwantedLogsList, content: {
            InvestigateUnwantedLogListView(unwantedLogs: investigateViewModelObject.logList.filter({ $0.eventType == "unwanted_detected" }))
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $familyLogObjectForDetails) { LogObject in
            FamilyLogDetailsView(member: LogObject)
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $unwantedLogObjectForDetails) { LogObject in
            UnwantedLogDetailsiew(unwantedPerson: LogObject)
                .presentationDragIndicator(.visible)
        }
        .onAppear(){
            Task{
                await cctvViewModelObject.fetchCCTVlist(context: context)
            }
        }
    }
}

#Preview {
    InvestigateView()
}
