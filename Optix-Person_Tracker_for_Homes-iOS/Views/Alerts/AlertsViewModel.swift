//
//  AlertsViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/3/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
class AlertsViewModel : ObservableObject {
    
    @Published var alertsServiceObject = AlertsService()
    @Published var logResponse : LogsResponse?
    @Published var unwantedPersonLogsList : [Logs] = []
    @Published var unwantedPersonLogs : [Logs] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
        
    // Getting Unwanted Person Logs
    func fetchUnwantedPersonLogList(context: ModelContext) async {
        
        // Load cache first so user sees something instantly
        self.loadFromCacheUnwantedPersonLogs(context: context)
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                // Replace with your actual logs service call
                alertsServiceObject.fetchAllUnwantedPersonLogs(
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
            
            self.logResponse = fetchedData
            
            // UPDATE LIST: Use the fresh API data immediately
            // Since `logs` is not optional in your LogsResponse struct, we assign directly
            self.unwantedPersonLogsList = fetchedData.logs
            
            self.isLoading = false
            self.cacheData(context: context, response: fetchedData)
            print("Logs updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
        
    // Loading from SwiftData Cache
    func loadFromCacheUnwantedPersonLogs(context: ModelContext) {
        // We now fetch the container class, not LogsCache directly
        let descriptor = FetchDescriptor<UnwantedPersonLogCache>()
        
        do {
            let results = try context.fetch(descriptor)
            var loadedList: [Logs] = []
            
            // Get the first (and ideally only) FamilyMemberLogCache container
            if let familyCacheContainer = results.first, let cachedLogs = familyCacheContainer.log {
                
                // Sort the extracted logs by date natively in Swift (descending)
                let sortedLogs = cachedLogs.sorted { $0.detectedAt > $1.detectedAt }
                
                for cached in sortedLogs {
                    loadedList.append(cached.toResponse())
                }
            }
            
            self.unwantedPersonLogsList = loadedList
            print("Loaded \(loadedList.count) unwanted person logs from Offline Cache")
            
        } catch {
            print("Failed to fetch logs cache: \(error)")
        }
    }
            
    // Saving to SwiftData
    func cacheData(context: ModelContext, response: LogsResponse) {
        do {
            // 1. Delete the old container (Cascade rule will auto-delete the attached LogsCache)
            try context.delete(model: UnwantedPersonLogCache.self)
            
            // 2. Create an array to hold the newly mapped SwiftData logs
            var newCachedLogs: [LogsCache] = []
            
            for object in response.logs {
                // Initialize the SwiftData log (which now safely handles interactions natively)
                let newLogCache = LogsCache(from: object)
                newCachedLogs.append(newLogCache)
            }
            
            // 3. Wrap the logs in the Unwanted Person Container
            let unwantedPersonContainer = UnwantedPersonLogCache(log: newCachedLogs)
            
            // 4. Insert the container into the database
            context.insert(unwantedPersonContainer)
            
            try context.save()
            
        } catch {
            print("Logs caching failed: \(error)")
        }
    }
    
    // Getting the Unwanted Perons Logs of specific person
    func fetchUnwantedPersonLogs(logId : UUID) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                // Replace with your actual logs service call
                alertsServiceObject.fetchUnwantedPersonLogs(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    logId: logId.uuidString
                ) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.logResponse = fetchedData
            
            // UPDATE LIST: Use the fresh API data immediately
            // Since `logs` is not optional in your LogsResponse struct, we assign directly
            self.unwantedPersonLogs = fetchedData.logs
            
            self.isLoading = false
            print("Logs updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
}
