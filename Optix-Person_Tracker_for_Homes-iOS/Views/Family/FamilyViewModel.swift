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
    @Published var addUpdateDeleteMemberResponse: addUpdateDeleteFamilyMemberResponse?
    @Published var logResponse : LogsResponse?
    @Published var familyMemberLogsList : [Logs] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Getting Family Members
    func fetchFamilyMemberList(context: ModelContext) async {
        
        self.loadFromCacheFamilyMember(context: context)
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
    func loadFromCacheFamilyMember(context: ModelContext) {
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
    
    // Creating New family Member
    func addFamilyMember(name: String, relationship: String, photos: [Data]) async {

        isLoading = true
        errorMessage = nil

        var filesToSend: [MediaFile] = []
            let rawDataList = photos // Returns [Data]

            for imageData in rawDataList {
                // "files" matches your Python List[UploadFile]
                let file = MediaFile(data: imageData, forKey: "files")
                filesToSend.append(file)
            }

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                familyServiceObject.createFamilyMember(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", relationship: relationship, name: name, files: filesToSend){ result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }

            self.addUpdateDeleteMemberResponse = fetchedData

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

    // Updating Family Member details
    func updateFamilyMember(memberId: UUID ,name: String, relationship: String, photos: [Data]) async {

        isLoading = true
        errorMessage = nil

        var filesToSend: [MediaFile] = []
            let rawDataList = photos // Returns [Data]

            for imageData in rawDataList {
                // "files" matches your Python List[UploadFile]
                let file = MediaFile(data: imageData, forKey: "files")
                filesToSend.append(file)
            }

        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                familyServiceObject.updateFamilyMember(memberId: memberId.uuidString,username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", relationship: relationship, name: name, files: filesToSend){ result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }

            self.addUpdateDeleteMemberResponse = fetchedData

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
    
    // Deleting Family Member
    func deleteFamilyMember(memberId: UUID) async{
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                familyServiceObject.deleteFamilyMember(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", memberId: memberId.uuidString) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.addUpdateDeleteMemberResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            print("Family Member has been deleted")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }

    // Getting Family Members Logs
    func fetchFamilyMembersLogList(context: ModelContext) async {
        
        // Load cache first so user sees something instantly
        self.loadFromCacheFamilyMemberLogs(context: context)
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                // Replace with your actual logs service call
                familyServiceObject.fetchAllFamilyMembersLogs(
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
            self.familyMemberLogsList = fetchedData.logs
            
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
    func loadFromCacheFamilyMemberLogs(context: ModelContext) {
        // We now fetch the container class, not LogsCache directly
        let descriptor = FetchDescriptor<FamilyMemberLogCache>()
        
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
            
            self.familyMemberLogsList = loadedList
            print("Loaded \(loadedList.count) family logs from Offline Cache")
            
        } catch {
            print("Failed to fetch logs cache: \(error)")
        }
    }
            
    // Saving to SwiftData
    func cacheData(context: ModelContext, response: LogsResponse) {
        do {
            // 1. Delete the old container (Cascade rule will auto-delete the attached LogsCache)
            try context.delete(model: FamilyMemberLogCache.self)
            
            // 2. Create an array to hold the newly mapped SwiftData logs
            var newCachedLogs: [LogsCache] = []
            
            for object in response.logs {
                // Initialize the SwiftData log (which now safely handles interactions natively)
                let newLogCache = LogsCache(from: object)
                newCachedLogs.append(newLogCache)
            }
            
            // 3. Wrap the logs in the Family container
            let familyContainer = FamilyMemberLogCache(log: newCachedLogs)
            
            // 4. Insert the container into the database
            context.insert(familyContainer)
            
            try context.save()
            
        } catch {
            print("Logs caching failed: \(error)")
        }
    }
    
    
//    // Loading from SwiftData Cache
//    func loadFromCacheFamilyMemberLogs(context: ModelContext) {
//        let descriptor = FetchDescriptor<LogsCache>(sortBy: [SortDescriptor(\.detectedAt, order: .reverse)])
//        
//        do {
//            let results = try context.fetch(descriptor)
//            
//            // Empty the list before appending to avoid duplicates
//            var loadedList: [Logs] = []
//            
//            for cached in results {
//                loadedList.append(cached.toResponse())
//            }
//            
//            self.familyMemberLogsList = loadedList
//            print("Loaded \(loadedList.count) logs from Offline Cache")
//            
//        } catch {
//            print("Failed to fetch logs cache: \(error)")
//        }
//    }
//        
//    // Saving to SwiftData
//    func cacheData(context: ModelContext, response: LogsResponse) {
//        do {
//            // Clear out the old cache completely before saving the new one
//            try context.delete(model: LogsCache.self)
//            
//            for object in response.logs {
//                
//                // 1. Convert the nested structs into SwiftData Models first
//                _ = object.interactions?.map {
//                    ObjectsCache(name: $0.name, movedAt: $0.movedAt)
//                }
//                
//                // 2. Create the main Log Cache Model
//                let newLogCache = LogsCache(from: object)
//                
//                // 3. Insert into database
//                context.insert(newLogCache)
//            }
//            
//            try context.save()
//            
//        } catch {
//            print("Logs caching failed: \(error)")
//        }
//    }
    
    
    
}

