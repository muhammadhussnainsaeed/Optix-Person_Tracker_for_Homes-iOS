import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
class CCTVViewModel: ObservableObject {
    
    @Published var cctvServiceObject = CCTVService()
    @Published var cctvlist: [CCTV] = []
    @Published var cctvNetworkList: [CCTVNetworkItem] = []
    @Published var cctvReponse: CCTVResponse?
    @Published var cameraGraph: CameraGraphResponse?
    @Published var cctvResponseForCamera: CCTVResponseForUpdateDelete?
    @Published var cctvNetworkResponse: CCTVNetworkResponse?
    @Published var cctvNetworkUpdateResponse: CCTVResponseForNetworkUpdate?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Getting Cameras
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
    
    // Fething the data for Camera Graph
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
            
            self.isLoading = false
            print("CCTV Graph updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Updating the Camera
    func updateCamera(cctvObjectForUpadte: CCTV) async{
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                cctvServiceObject.updateCamera(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", cameraToUpdate: cctvObjectForUpadte) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.cctvResponseForCamera = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            print("Camera has been updated")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
    
    // Deleting the Camera
    func deleteCamera(cameraId: UUID) async{
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                cctvServiceObject.deleteCamera(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", cameraId: cameraId) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.cctvResponseForCamera = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            print("Camera has been deleted")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
    
    // Getting Camera Network
    func fetchCameraNetwork(cameraId: UUID) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                cctvServiceObject.fetchCameraNetwork(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", cameraId: cameraId.uuidString)
                    { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.cctvNetworkResponse = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            if let newCameras = fetchedData.cameraList {
                self.cctvNetworkList = newCameras
            }
            
            self.isLoading = false
            print("CCTV Network updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    // Updating the Camera Network
    func updateCameraNetwork(cameraId: UUID, newNetwork: [CCTVNetworkItem]) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                
                cctvServiceObject.updateCameraNetwork(username: SessionManager.shared.currentUsername, jwtToken: SessionManager.shared.getAuthToken() ?? "", userId: SessionManager.shared.currentUserID?.uuidString ?? "", cameraId: cameraId.uuidString, cameraList: newNetwork){ result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.cctvNetworkUpdateResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            print("Camera Network has been updated")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
}

