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
    
}
