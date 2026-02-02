////
////  CCTVViewModel.swift
////  Optix-Person_Tracker_for_Homes-iOS
////
////  Created by Hussnain on 26/1/26.
////
//
//import Foundation
//import Combine
//import SwiftData
//import SwiftUI
//
//@MainActor
//class CCTVViewModel: ObservableObject {
//    
//    @Published var cctvServiceObject = CCTVService()
//    @Published var cctvlist: [CCTV] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var cctvReponse: CCTVResponse?
//    
//    func fetchCCTVlist(context: ModelContext) async {
//        
//        self.loadFromCache(context: context)
//        isLoading = true
//        errorMessage = nil
//        
//        do{
//            // Call API
//            let fetchedData = try await withCheckedThrowingContinuation { continuation in
//                cctvServiceObject.fetchAllCameras(
//                    username: SessionManager.shared.currentUsername,
//                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
//                    userId: SessionManager.shared.currentUserID?.uuidString ?? ""
//                ) { result in
//                    switch result {
//                    case .success(let data): continuation.resume(returning: data)
//                    case .failure(let error): continuation.resume(throwing: error)
//                    }
//                }
//            }
//            self.cctvReponse = fetchedData
//            self.isLoading = false
//            self.cacheData(context: context, response: fetchedData)
//            print("Dashboard updated from API")
//        }
//        catch{
//            print("API Error: \(error.localizedDescription)")
//            self.errorMessage = error.localizedDescription
//            self.isLoading = false
//            
//            // Fallback to offline data
//            loadFromCache(context: context)
//        }
//    }
//    
//    // Loading from Swift Data
//    func loadFromCache(context: ModelContext) {
//        
//        // Since we can't use @Query, we use FetchDescriptor
//        let descriptor = FetchDescriptor<CCTVCache>()
//        
//        do {
//            let results = try context.fetch(descriptor)
//            for cached in results {
//                self.cctvlist.append(cached.toResponse())
//            }
//            print("Loaded data from Offline Cache")
//        } catch {
//            print("Failed to fetch cache: \(error)")
//        }
//    }
//    
//    // saving data to SwiftData
//    func cacheData(context: ModelContext, response: CCTVResponse) {
//        do {
//            // Clear old cache manually using Batch Delete
//            try context.delete(model: CCTVCache.self)
//            
//            // Convert & Save
//            if response.cctvlist == nil { return }
//            for object in response.cctvlist! {
//                let newCCTVCache = CCTVCache(id: object.id, name: object.name, location: object.location, cctvdescription: object.cctvDescription, videoURL: object.videoURL, isPrivate: object.isPrivate, floorId: object.floorId)
//                
//                context.insert(newCCTVCache)
//                try context.save()
//            }
//            
//        } catch {
//            print("Caching failed: \(error)")
//        }
//    }
//}
//


//
//  CCTVViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
class CCTVViewModel: ObservableObject {
    
    @Published var cctvServiceObject = CCTVService()
    @Published var cctvlist: [CCTV] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var cctvReponse: CCTVResponse?
    @Published var cameraGraph: CameraGraphResponse?
    
    func fetchCCTVlist(context: ModelContext) async {
        
        // Load cache first so user sees something instantly
        self.loadFromCache(context: context)
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                cctvServiceObject.fetchAllCameras(
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
            if let newCameras = fetchedData.cctvlist {
                self.cctvlist = newCameras
            }
            
            self.isLoading = false
            self.cacheData(context: context, response: fetchedData)
            print("CCTV updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    // Loading from Swift Data
    func loadFromCache(context: ModelContext) {
        let descriptor = FetchDescriptor<CCTVCache>()
        
        do {
            let results = try context.fetch(descriptor)
            
            // 2. CRITICAL FIX: Empty the list before appending to avoid duplicates
            var loadedList: [CCTV] = []
            
            for cached in results {
                loadedList.append(cached.toResponse())
            }
            
            self.cctvlist = loadedList
            print("Loaded \(loadedList.count) cameras from Offline Cache")
            
        } catch {
            print("Failed to fetch cache: \(error)")
        }
    }
    
    // Saving data to SwiftData
    func cacheData(context: ModelContext, response: CCTVResponse) {
        do {
            try context.delete(model: CCTVCache.self)
            
            guard let cameras = response.cctvlist else { return }
            
            for object in cameras {
                let newCCTVCache = CCTVCache(
                    id: object.id,
                    name: object.name,
                    location: object.location,
                    cctvdescription: object.cctvDescription,
                    videoURL: object.videoURL,
                    isPrivate: object.isPrivate,
                    floorId: object.floorId
                )
                context.insert(newCCTVCache)
            }
            
            try context.save()
            
        } catch {
            print("Caching failed: \(error)")
        }
    }
    
    func fetchCameraGraph() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                cctvServiceObject.fetchCameraGraph(
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
            
            self.cameraGraph = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            //            if let newCameras = fetchedData.connections {
            //                self.cctvlist = newCameras
            //            }
            
            self.isLoading = false
            //self.cacheData(context: context, response: fetchedData)
            print("CCTV updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // MOCK DATA (Matching your JSON example)
            //        let mockJSON = """
            //            {
            //              "connections" : {
            //              "H-Gate Cam": [
            //                false,
            //                false,
            //                true
            //                ],
            //              "H-Kitchen Cam": [
            //                false,
            //                false,
            //                true
            //                ],
            //              "H-Lounge Cam": [
            //                false,
            //                false,
            //                true
            //                ]
            //              }
            //            }
            //            """
            //
            //        if let data = mockJSON.data(using: .utf8) {
            //            do {
            //                let response = try JSONDecoder().decode(CameraGraphResponse.self, from: data)
            //                self.cameraGraph = response.connections
            //                print("Graph Loaded: \(response.connections)")
            //            } catch {
            //                print("Graph Parsing Error: \(error)")
            //            }
            //        }
        }
    }
}
