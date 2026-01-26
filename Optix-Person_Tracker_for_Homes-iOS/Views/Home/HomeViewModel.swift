//
//  HomeViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/1/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor // Ensure UI updates happen on main thread
class HomeViewModel: ObservableObject {
    
    @Published var homeServiceObject = HomeService()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var dashboardResponse: DashboardResponse?
    
    // API Call to get the new data
    func getDashboardStats(context: ModelContext) async {
        
        loadFromCache(context: context)
        isLoading = true
        errorMessage = nil
        
        do {
            // Call API
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                homeServiceObject.getDashboardStats(
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
            
            // Update UI & Cache
            self.dashboardResponse = fetchedData
            self.isLoading = false
            self.cacheData(context: context, response: fetchedData)
            print("Dashboard updated from API")

        } catch {
            // Try loading from Cache
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback to offline data
            loadFromCache(context: context)
        }
    }
    
    // saving data to SwiftData
    func cacheData(context: ModelContext, response: DashboardResponse) {
        do {
            // Clear old cache manually using Batch Delete
            try context.delete(model: DashboardCache.self)
            
            // Convert & Save
            let familyLogSD = response.recentFamilyLog != nil ? RecentLogSD(from: response.recentFamilyLog!) : nil
            let unwantedLogSD = response.recentUnwantedLog != nil ? RecentLogSD(from: response.recentUnwantedLog!) : nil
            
            let newCache = DashboardCache(
                cameraCount: response.cameraCount,
                familyCount: response.familyCount,
                todayEventCount: response.todayEventCount,
                recentFamilyLog: familyLogSD,
                recentUnwantedLog: unwantedLogSD
            )
            
            context.insert(newCache)
            try context.save()
            
        } catch {
            print("Caching failed: \(error)")
        }
    }
    
    // Loading from Swift Data
    func loadFromCache(context: ModelContext) {
        
        // Since we can't use @Query, we use FetchDescriptor
        let descriptor = FetchDescriptor<DashboardCache>()
        
        do {
            let results = try context.fetch(descriptor)
            if let cached = results.first {
                // Convert Cache -> DashboardResponse (So View doesn't know the difference)
                self.dashboardResponse = cached.toResponse()
                print("Loaded data from Offline Cache")
            }
        } catch {
            print("Failed to fetch cache: \(error)")
        }
    }
}
