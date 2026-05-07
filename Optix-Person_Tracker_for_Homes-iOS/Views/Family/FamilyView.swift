//
//  FamilyView.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 8/2/26.
//

import SwiftUI
import SwiftData

struct FamilyView: View {
    
    @State var isShowingSheetFamilyList: Bool = false
    @State var isShowingSheetFamilyLogsList: Bool = false
    @State var isShowingSheetAddMember: Bool = false
    
    @State private var showDeleteAlert = false
    @State private var isPresentAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var error: Bool = false
    
    @State var familyLogObjectForDetails: Logs?
    @State var memberObjectForDetails: Family?
    @State var memberObjectForUpdate: Family?
    @State var memberObjectForDelete: Family?
    @State var logObjectForCorrection: Logs?
    
    @Environment(\.modelContext) private var context
    @StateObject var familyViewModelObject = FamilyViewModel()
    
    var topFamilyMembers: [Family] {
        // This grabs the first 3. If there are only 2, it grabs 2. No crash.
        Array(familyViewModelObject.familyMemberList.prefix(3))
    }
    
    var topFamilyMemberLogs: [Logs] {
        // This grabs the first 3. If there are only 2, it grabs 2. No crash.
        Array(familyViewModelObject.familyMemberLogsList.prefix(3))
    }
    
    var body: some View {
        ZStack(alignment: .top){
            
            ScrollView{
                // Spacer for Header
                Color.clear.frame(height: 120)
                
                // MARK: - LIST 1: The First 3 Cameras
                HStack{
                    Text("Family Members")
                    Spacer()
                    Button {
                        isShowingSheetFamilyList.toggle()
                        print("View All")
                    } label: {
                        HStack{
                            Text("View all")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                if topFamilyMembers.isEmpty {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 20))
                            Text("No Family member found!")
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
                    .padding(.bottom, 50)
                }
                else{
                    
                    // USE FOREACH (Safely loops through topFamilyMembers)
                    ForEach(topFamilyMembers) { member in
                        InfoCard(cardType: .family, id: member.id, name: member.name, roomName: "", floorName: "", description: "", detected_date: "", detected_time: "", photo: "\(member.photos[0].photo)", relationship: member.relationship) {
                            print("Tapped \(member.name)")
                            
                            memberObjectForDetails = member
                        }
                        .contextMenu {
                            Button {
                                print("Edit Tapped")
                                memberObjectForUpdate = member
                            } label: {
                                Text("Edit")
                            }
                            
                            Button(role: .destructive) {
                                print("Delete Tapped")
                                showDeleteAlert.toggle()
                                memberObjectForDelete = member
                            } label: {
                                Text("Delete")
                            }
                            
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                    }
                }
                
                // MARK: - LIST 2: The First 3 Cameras
                HStack{
                    Text("Family Logs")
                    Spacer()
                    Button {
                        print("View All")
                        isShowingSheetFamilyLogsList.toggle()
                    } label: {
                        HStack{
                            Text("View all")
                                .font(.footnote)
                                .foregroundStyle(Color.primary)
                            RoundButton(buttonColor: "custom_blue", buttonArrowColor: .white)
                        }
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if topFamilyMemberLogs.isEmpty {
                    VStack{
                        HStack(spacing: 10) {
                            Image(systemName: "text.page.slash")
                                .font(.system(size: 20))
                            Text("No Member has been detected!")
                                .font(.headline)
                        }
                        .padding(.top, 50)
                        HStack{
                            Text("Refresh the Screen to update!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color.secondary)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 50)
                }
                else{
                    
                    // USE FOREACH (Safely loops through bottomCameras)
                    ForEach(topFamilyMemberLogs) { log in
                        InfoCard(cardType: .familylog, id: log.id, name: log.name, roomName: log.roomName, floorName: log.floorTitle, description: "", detected_date: AppFormatter.shared.getFormattedDate(from: log.detectedAt), detected_time: AppFormatter.shared.getFormattedTime(from: log.detectedAt), photo: log.personPhoto, relationship: "") {
                            familyLogObjectForDetails = log
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                print("Wrong Detection?")
                                logObjectForCorrection = log
                            } label: {
                                Text("Wrong Detection?")
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 7)
                    }
                }
                
                // Bottom Padding for TabBar
                Color.clear.frame(height: 140)
            }
            .ignoresSafeArea()
            .scrollIndicators(.hidden)
            
            VStack{
                // MARK: - Floating Header
                VStack(alignment: .leading) {
                    HStack {
                        Text("Family")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            //isShowingSheetFloor = true
                            print("Map")
                        } label: {
                            Label("Smart Boundaries", systemImage: "heart.text.square.fill")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .buttonStyle(.glassProminent)
                        .tint(Color("custom_blue"))
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
                if familyViewModelObject
                    .isLoading {
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
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        isShowingSheetAddMember = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .bold()
                            .frame(width: 40, height: 50)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)
                    .buttonStyle(.glassProminent)
                    .tint(Color("custom_blue"))
                }

            }
        }
        .alert("Delete Family Member?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let member = memberObjectForDelete {
                    Task{
                        await familyViewModelObject.deleteFamilyMember(memberId: member.id)
                        if (familyViewModelObject.errorMessage != nil){
                            alertMessage = familyViewModelObject.errorMessage ?? ""
                            error.toggle()
                            isPresentAlert.toggle()
                        }
                        else{
                            alertMessage = familyViewModelObject.addUpdateDeleteMemberResponse?.message ?? ""
                            isPresentAlert.toggle()
                         }
                    }
                    print("Deleted \(member.name)")
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
        .sheet(item: $memberObjectForDetails) { member in
                    FamilyMemberDetailView(member: member)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(320)])
                }
        .sheet(item: $memberObjectForUpdate) { member in
                    AddUpdateFamilyMemberView(isUpdate: true, member: member)
                        .presentationDragIndicator(.visible)
                }
        .sheet(isPresented: $isShowingSheetFamilyList, content: {
            FamilyMemberListView()
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isShowingSheetFamilyLogsList, content: {
            FamilyMemberLogListView()
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isShowingSheetAddMember, content: {
            AddUpdateFamilyMemberView(isUpdate: false, member: nil)
                .presentationDragIndicator(.visible)
        })
        .sheet(item: $logObjectForCorrection, content: { log in
            LogCorrectionView(logId: log.id)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(350)])
        })
        .onAppear(){
            Task{
                await familyViewModelObject.fetchFamilyMemberList(context: context)
                await familyViewModelObject.fetchFamilyMembersLogList(context: context)
            }
        }
        .sheet(item: $familyLogObjectForDetails) { LogObject in
            FamilyLogDetailsView(member: LogObject)
                .presentationDragIndicator(.visible)
        }
        .refreshable {
            Task{
                await familyViewModelObject.fetchFamilyMemberList(context: context)
                await familyViewModelObject.fetchFamilyMembersLogList(context: context)
            }
        }
    }
}

#Preview {
    FamilyView()
}
