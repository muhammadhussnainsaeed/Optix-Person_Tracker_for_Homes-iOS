//
//  SmartBoundriesViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import Foundation
import Combine

class SmartBoundriesViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var monitoringRuleList: [MonitoringRule] = []
    @Published var monitoringRuleResponse: MonitoringRuleResponse?
    @Published var smartBoundriesServiceObject =  SmartBoundriesService()
    @Published var updateDeleteMonitoringRuleResponse: UpdateDeleteMonitoringRuleResponse?
    @Published var familyMembersList: [FamilyMemberData] = []
    @Published var otherServiceObject = OtherService()
    
    @Published var linkedCameras: [CamerasObject] = []
    @Published var unlinkedCameras: [CamerasObject] = []
    
    // Fetch the monitoring rules plan list
    func fetchAllMonitoringRules() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                smartBoundriesServiceObject.fetchAllMonitoringRules(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? ""
                ) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.monitoringRuleResponse = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            if let newRule = fetchedData.rules {
                self.monitoringRuleList = newRule
            }
            
            self.isLoading = false
            print("Rules updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
 
    
    // Deleting Monitoring Rule
    func deleteMonitoringRule(ruleId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                smartBoundriesServiceObject.deleteMonitoringRule(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    ruleId: ruleId.uuidString
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // Ensure you have a variable to hold the response, e.g., @Published var deleteRuleResponse: DeleteMonitoringRuleResponse?
            self.updateDeleteMonitoringRuleResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            print("Monitoring Rule has been deleted")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Updating Monitoring Rule
    func updateMonitoringRule(ruleId: UUID, ruleName: String, personId: UUID, cameraIds: [UUID], fromTime: String?, toTime: String?,isActive: Bool) async {
        
        isLoading = true
        errorMessage = nil
        
        // Map UUID arrays to String arrays for the API
        let cameraIdStrings = cameraIds.map { $0.uuidString }

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                smartBoundriesServiceObject.updateMonitoringRule(
                    ruleId: ruleId.uuidString,
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    ruleName: ruleName,
                    personId: personId.uuidString,
                    cameraIds: cameraIdStrings,
                    fromTime: fromTime,
                    toTime: toTime,
                    isActive: isActive
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // Assuming you have an @Published property to hold this response
            self.updateDeleteMonitoringRuleResponse = fetchedData
            
            print("\(fetchedData)")
            self.isLoading = false
            print("Monitoring Rule has been successfully updated")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Toggling Monitoring Rule
    func toggleMonitoringRule(ruleId: UUID, isActive: Bool) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                smartBoundriesServiceObject.toggleMonitoringRule(
                    ruleId: ruleId.uuidString,
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    isActive: isActive
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // Assuming you have an @Published property to hold this response
            self.updateDeleteMonitoringRuleResponse = fetchedData
            
            print("\(fetchedData)")
            self.isLoading = false
            print("Monitoring Rule status toggled successfully to \(isActive ? "active" : "inactive")")
            
            // Optional: If you maintain a local array of rules in this ViewModel,
            // you might want to find the rule in that array and update its `isActive`
            // property here so the UI updates immediately without needing to re-fetch the list.

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func fetchRuleCameras(ruleId: UUID) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                smartBoundriesServiceObject.fetchRuleCameras(
                    ruleId: ruleId.uuidString,
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? ""
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // 1. UPDATE LISTS: Use the fresh API data immediately to drive your UI
            self.linkedCameras = fetchedData.linkedCameras
            self.unlinkedCameras = fetchedData.unlinkedCameras
            
            self.isLoading = false
            print("Successfully fetched \(self.linkedCameras.count) linked and \(self.unlinkedCameras.count) unlinked cameras.")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Assuming you have this in your ViewModel to drive your UI:
    

    // Fetching All  Members
    func fetchAllFamilyMembers() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                otherServiceObject.getAllFamily(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? ""
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // 1. UPDATE LIST: Populate your published array with the inner `data` array
            self.familyMembersList = fetchedData.data
            
            self.isLoading = false
            print("Successfully fetched \(self.familyMembersList.count) family members.")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Creating a Monitoring Rule
    func createMonitoringRule(
        ruleName: String,
        personId: UUID,
        cameraIds: [UUID],
        fromTime: String?,
        toTime: String?,
        isActive: Bool
    ) async {
        
        isLoading = true
        errorMessage = nil
        
        // Map UUID arrays to String arrays for the API
        let cameraIdStrings = cameraIds.map { $0.uuidString }

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
            smartBoundriesServiceObject.createMonitoringRule(
                    ruleName: ruleName,
                    personId: personId.uuidString,
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    cameraIds: cameraIdStrings,
                    fromTime: fromTime,
                    toTime: toTime,
                    isActive: isActive
                ) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // Assuming you have an @Published property to hold this response
            // e.g., @Published var createRuleResponse: CreateMonitoringRuleResponse?
            self.updateDeleteMonitoringRuleResponse = fetchedData
            
            print("\(fetchedData)")
            self.isLoading = false
            print("Monitoring Rule created successfully with ID: \(fetchedData.ruleId)")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
