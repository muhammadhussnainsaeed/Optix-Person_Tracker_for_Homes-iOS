//
//  CCTVService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import Foundation
import SwiftUI

class CCTVService {
    
    private let Network = NetworkManager()
    
    // To fetch all the cameras of the user
    func fetchAllCameras(username: String, jwtToken: String, userId: String, completion: @escaping (Result<CCTVResponse, Error>) -> Void){
        
        let urlString = "/camera/fetch_all?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)"
        
        // Making the Get Request
        Network.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /camera/fetch_all: \(error)")
                completion(.failure(error))
                return
            }
            
            // Handle HTTP Status Codes
            if let httpResponse = response as? HTTPURLResponse {
                
                // Check if status is NOT 200-299
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // Fallback for generic server errors (e.g. 500)
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    return // Stop here on error
                }
            }
            
            // Handle Success Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Fetch all Camera", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let cctvListData = try decoder.decode(CCTVResponse.self, from: data)
                
                // Success
                completion(.success(cctvListData))
                
            } catch {
                print("Decoding failed: \(error)")
                // Debugging: Print raw JSON if decoding fails
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response causing error: \(str)")
                }
                completion(.failure(error))
            }
        }
        
    }
    
    // To fetch Cameras Relationship Matirx
    func fetchCameraGraph(username: String, jwtToken: String, userId: String, completion: @escaping (Result<CameraGraphResponse, Error>) -> Void){
        
        let urlString = "/camera/graph?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)"
        
        // Making the Get Request
        Network.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /camera/fetch_all: \(error)")
                completion(.failure(error))
                return
            }
            
            // Handle HTTP Status Codes
            if let httpResponse = response as? HTTPURLResponse {
                
                // Check if status is NOT 200-299
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // Fallback for generic server errors (e.g. 500)
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    return // Stop here on error
                }
            }
            
            // Handle Success Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Cameras Graph", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let cctvNetworkData = try decoder.decode(CameraGraphResponse.self, from: data)
                
                // Success
                completion(.success(cctvNetworkData))
                
            } catch {
                print("Decoding failed: \(error)")
                // Debugging: Print raw JSON if decoding fails
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response causing error: \(str)")
                }
                completion(.failure(error))
            }
        }
        
    }
    
    // To update the camera
    func updateCamera(username: String, jwtToken: String, userId: String, cameraToUpdate: CCTV, completion: @escaping (Result<CCTVResponseForUpdateDelete, Error>) -> Void){
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "camera_id": cameraToUpdate.id.uuidString, "name": cameraToUpdate.name, "location": cameraToUpdate.name, "video_url": cameraToUpdate.videoURL, "description": cameraToUpdate.cctvDescription, "is_private": cameraToUpdate.isPrivate, "jwt_token": jwtToken, "floor_id": cameraToUpdate.floorId.uuidString]
        
        Network.request(url: "/camera/update", method: "put", body: credentials) {
            data, response, error in
            
            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }
            
            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {
                
                // If status is NOT success (e.g., 400, 401, 500)
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing (common in 500 errors) any other errors
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    
                    // CRITICAL: Stop execution here.
                    return
                }
            }
            
            // Handle Data Decoding (Only runs if Status Code was 200 or any other other success code)
            guard let data = data else {
                let noDataError = NSError(domain: "Upadte Camera", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(CCTVResponseForUpdateDelete.self, from: data)
                completion(.success(responseData))
            } catch {
                print("Decoding failed: \(error)")
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(str)")
                }
                completion(.failure(error))
            }
        }
    }
    
    // To delete the Camera
    func deleteCamera(username: String, jwtToken: String, userId: String, cameraId: UUID, completion: @escaping (Result<CCTVResponseForUpdateDelete, Error>) -> Void){
     
        let credentials: [String: Any] = ["user_id": userId, "username": username, "camera_id": cameraId.uuidString, "jwt_token": jwtToken]
        
        Network.request(url: "/camera/delete", method: "delete", body: credentials) {
            data, response, error in
            
            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }
            
            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {
                
                // If status is NOT success (e.g., 400, 401, 500)
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing (common in 500 errors) any other errors
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    
                    // CRITICAL: Stop execution here.
                    return
                }
            }
            
            // Handle Data Decoding (Only runs if Status Code was 200 or any other other success code)
            guard let data = data else {
                let noDataError = NSError(domain: "Delete Camera", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(CCTVResponseForUpdateDelete.self, from: data)
                completion(.success(responseData))
            } catch {
                print("Decoding failed: \(error)")
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(str)")
                }
                completion(.failure(error))
            }
        }
    }
    
    // To fetch Camera Network of a Camera.
    func fetchCameraNetwork(username: String, jwtToken: String, cameraId: String, completion: @escaping (Result<CCTVNetworkResponse, Error>) -> Void){
        
        let urlString = "/camera/network/fetch?username=\(username)&jwt_token=\(jwtToken)&camera_id=\(cameraId)"
        
        // Making the Get Request
        Network.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /camera/network/fetch: \(error)")
                completion(.failure(error))
                return
            }
            
            // Handle HTTP Status Codes
            if let httpResponse = response as? HTTPURLResponse {
                
                // Check if status is NOT 200-299
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // Fallback for generic server errors (e.g. 500)
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    return // Stop here on error
                }
            }
            
            // Handle Success Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Camera Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let cctvNetworkData = try decoder.decode(CCTVNetworkResponse.self, from: data)
                
                // Success
                completion(.success(cctvNetworkData))
                
            } catch {
                print("Decoding failed: \(error)")
                // Debugging: Print raw JSON if decoding fails
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response causing error: \(str)")
                }
                completion(.failure(error))
            }
        }
        
    }
    
    // Update the Camera Network of a Camera.
    func updateCameraNetwork(username: String, jwtToken: String, userId: String, cameraId: String, cameraList: [CCTVNetworkItem], completion: @escaping (Result<CCTVResponseForNetworkUpdate, Error>) -> Void) {
        
        let cameraListString : [String] = cameraList.map { $0.id.uuidString }
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "jwt_token": jwtToken, "camera_id": cameraId, "connected_camera_id" : cameraListString]
        
        Network.request(url: "/camera/network/update", method: "put", body: credentials) {
            data, response, error in
            
            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }
            
            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {
                
                // If status is NOT success (e.g., 400, 401, 500)
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing (common in 500 errors) any other errors
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    
                    // CRITICAL: Stop execution here.
                    return
                }
            }
            
            // Handle Data Decoding (Only runs if Status Code was 200 or any other other success code)
            guard let data = data else {
                let noDataError = NSError(domain: "Upadte Camera Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(CCTVResponseForNetworkUpdate.self, from: data)
                completion(.success(responseData))
            } catch {
                print("Decoding failed: \(error)")
                if let str = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(str)")
                }
                completion(.failure(error))
            }
        }
        
    }
    
}
