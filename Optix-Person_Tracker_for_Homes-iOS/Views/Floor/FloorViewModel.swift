//
//  FloorViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/2/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

class FloorViewModel: ObservableObject {
    
    @Published var floorServiceObject = FloorService()
    @Published var floorlist: [Floor] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var cctvReponse: FloorResponse?
    @Published var addUpdateFloorResponse: addUpdateFloorResponse?
    @Published var addUpdateFloorPlanResponse: addUpdateFloorPlanResponse?
    @Published var floorPlanResponse: FloorPlan?
    
    // Fetch the Floor plan list
    func fetchFloorlist(context: ModelContext) async {
        
        // Load cache first so user sees something instantly
        self.loadFromCache(context: context)
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                floorServiceObject.fetchAllFloors(
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
            
            self.cctvReponse = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            if let newFloor = fetchedData.floorList {
                self.floorlist = newFloor
            }
            
            self.isLoading = false
            self.cacheData(context: context, response: fetchedData)
            print("Floor updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    // Loading from Swift Data
    func loadFromCache(context: ModelContext) {
        let descriptor = FetchDescriptor<FloorCache>()
        
        do {
            let results = try context.fetch(descriptor)
            
            // 2. CRITICAL FIX: Empty the list before appending to avoid duplicates
            var loadedList: [Floor] = []
            
            for cached in results {
                loadedList.append(cached.toResponse())
            }
            
            self.floorlist = loadedList
            print("Loaded \(loadedList.count) Floor from Offline Cache")
            
        } catch {
            print("Failed to fetch cache: \(error)")
        }
    }
    
    // Saving data to SwiftData
    func cacheData(context: ModelContext, response: FloorResponse) {
        do {
            try context.delete(model: FloorCache.self)
            
            guard let floors = response.floorList else { return }
            
            for object in floors {
                let newFloorCache = FloorCache(
                    id: object.id,
                    title: object.title,
                    floorDescription: object.description
                )
                context.insert(newFloorCache)
            }
            
            try context.save()
            
        } catch {
            print("Caching failed: \(error)")
        }
    }
    
    // Creating the new Floor
    func createFloor(title: String, description: String) async {
        
        isLoading = true
        errorMessage = nil

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                floorServiceObject.createFloor(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", title: title, description: description){ result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }

            self.addUpdateFloorResponse = fetchedData

//            // 1. UPDATE LIST: Use the fresh API data immediately
//            if let familymember = fetchedData.familyMemberList {
//                self.familyMemberList = familymember
//            }

            self.isLoading = false
           //self.cacheData(context: context, response: fetchedData)
            //print("D")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false

            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    // Creating the floor plan data
    func createFloorData(planData: String, floorId: UUID) async {
        
        isLoading = true
        errorMessage = nil

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                
                floorServiceObject.createFloorPlan(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", floorId: floorId.uuidString, planData: planData){ result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }

            self.addUpdateFloorPlanResponse = fetchedData

//            // 1. UPDATE LIST: Use the fresh API data immediately
//            if let familymember = fetchedData.familyMemberList {
//                self.familyMemberList = familymember
//            }

            self.isLoading = false
           //self.cacheData(context: context, response: fetchedData)
            //print("D")

        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false

            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    // Fetch the Floor plan data
    func fetchFloorData(floorId: UUID) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                floorServiceObject.getFloorPlan(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? "",
                    floorId: floorId.uuidString
                ) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.floorPlanResponse = fetchedData
            self.isLoading = false
            
        } catch {
            print("API Error floor: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

}
