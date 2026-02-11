//
//  FamilyViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 10/2/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
class FamilyViewModel: ObservableObject {
    
    @Published var familyServiceObject = FamilyService()
    @Published var familyMemberList : [Family] = []
    @Published var familyMemberResponse : FamilyMemberResponse?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Getting Family Members
    func fetchFamilyMemberList(context: ModelContext) async {
            
        self.loadFromCache(context: context)
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                familyServiceObject.fetchAllFamilyMembers(
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
            
            self.familyMemberResponse = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            if let familymember = fetchedData.familyMemberList {
                self.familyMemberList = familymember
            }
            
            self.isLoading = false
           self.cacheData(context: context, response: fetchedData)
            print("Family Member updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    // Loading from Swift Data
    func loadFromCache(context: ModelContext) {
        let descriptor = FetchDescriptor<FamilyMemberCache>()
        
        do {
            let results = try context.fetch(descriptor)
            
            // 2. CRITICAL FIX: Empty the list before appending to avoid duplicates
            var loadedList: [Family] = []
            
            for cached in results {
                loadedList.append(cached.toResponse())
            }
            
            self.familyMemberList = loadedList
            print("Loaded \(loadedList.count) Family Members from Offline Cache")
            
        } catch {
            print("Failed to fetch cache: \(error)")
        }
    }
    
    // Saving data to SwiftData
    func cacheData(context: ModelContext, response: FamilyMemberResponse) {
        do {
            try context.delete(model: FamilyMemberCache.self)
            
            guard let members = response.familyMemberList else { return }
            
            for object in members {
                
                let convertedPhotos = object.photos.map { apiPhoto in
                                FamilyMemberPhoto(photo: apiPhoto.photo)
                            }
                            
                            // 3. Initialize the cache object with the converted array
                            let newMember = FamilyMemberCache(
                                id: object.id,
                                name: object.name,
                                relationship: object.relationship,
                                photos: convertedPhotos
                            )
                context.insert(newMember)
            }
            
            try context.save()
            
        } catch {
            print("Caching failed: \(error)")
        }
    }
}
