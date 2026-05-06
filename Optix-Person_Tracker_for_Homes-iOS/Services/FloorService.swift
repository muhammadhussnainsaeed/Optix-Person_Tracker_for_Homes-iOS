//
//  FloorService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/2/26.
//

import Foundation

class FloorService {
    
    // Used to fetch all floor plans
    func fetchAllFloors(username: String, jwtToken: String, userId: String, completion: @escaping (Result<FloorResponse, Error>) -> Void){
        
        let urlString = "/floor/fetch_all?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)"
        
        // Making the Get Request
        NetworkManager.shared.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /fetch/fetch_all: \(error)")
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
                let noDataError = NSError(domain: "Floor List", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let floorListData = try decoder.decode(FloorResponse.self, from: data)
                
                // Success
                completion(.success(floorListData))
                
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
    
    // Used to create a floor plan
    func createFloor(username: String, jwtToken: String, userId: String, title: String, description: String, completion: @escaping (Result<addUpdateFloorResponse, Error>) -> Void){
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "title": title, "description": description, "jwt_token": jwtToken]
        
        NetworkManager.shared.request(url: "/floor/add", method: "post", body: credentials) {
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
                let noDataError = NSError(domain: "Create Floor", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateFloorResponse.self, from: data)
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

    // Used to update a floor plan
    func updateFloor(username: String, jwtToken: String, userId: String, title: String, description: String, floorId: String, completion: @escaping (Result<addUpdateFloorResponse, Error>) -> Void){
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "floor_id": floorId, "title": title, "description": description, "jwt_token": jwtToken]
        
        NetworkManager.shared.request(url: "/floor/update", method: "put", body: credentials) {
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
                let noDataError = NSError(domain: "Create Floor", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateFloorResponse.self, from: data)
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
    
    // Used to delete a floor plan
    func deleteFloor(username: String, jwtToken: String, userId: String, floorId: String, completion: @escaping (Result<addUpdateFloorResponse, Error>) -> Void){
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "floor_id": floorId, "jwt_token": jwtToken]
        
        NetworkManager.shared.request(url: "/floor/delete", method: "delete", body: credentials) {
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
                let noDataError = NSError(domain: "Delete Floor", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateFloorResponse.self, from: data)
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
    
    // Used to create a floor plan data
    func createFloorPlan(username: String, jwtToken:String, userId: String, floorId: String, planData: String, completion: @escaping (Result<addUpdateFloorPlanResponse, Error>) -> Void){
        
        guard let konvaData = planData.data(using: .utf8),
              let planDataDict = try? JSONSerialization.jsonObject(with: konvaData, options: []) as? [String: Any] else {
            print("Failed to parse Konva JSON")
            //print(konvaData)
            return
        }
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "floor_id": floorId, "jwt_token": jwtToken, "plan_data": planDataDict]
        
        NetworkManager.shared.request(url: "/floor/add_floor_data", method: "post", body: credentials) {
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
                let noDataError = NSError(domain: "Create Floor Plan Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateFloorPlanResponse.self, from: data)
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
    
    // Used to update a floor plan data
    func updateFloorPlan(username: String, jwtToken:String, userId: String, floorId: String, planData: String, completion: @escaping (Result<addUpdateFloorPlanResponse, Error>) -> Void){
        
        guard let konvaData = planData.data(using: .utf8),
              let planDataDict = try? JSONSerialization.jsonObject(with: konvaData, options: []) as? [String: Any] else {
            print("Failed to parse Konva JSON")
            //print(konvaData)
            return
        }
        
        let credentials: [String: Any] = ["user_id": userId, "username": username, "floor_id": floorId, "jwt_token": jwtToken, "plan_data": planDataDict]
        
        NetworkManager.shared.request(url: "/floor/update_floor_data", method: "put", body: credentials) {
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
                let noDataError = NSError(domain: "Update Floor Plan Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateFloorPlanResponse.self, from: data)
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
    
    // Used to fetch a floor plan data
    func getFloorPlan(username: String, jwtToken: String, userId: String, floorId: String ,completion: @escaping (Result<FloorPlan, Error>) -> Void){
     
        let urlString = "/floor/get_floor_data?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)&floor_id=\(floorId)"
        
        // Making the Get Request
        NetworkManager.shared.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /fetch/fetch_all: \(error)")
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
                let noDataError = NSError(domain: "Floor Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let floorData = try decoder.decode(FloorPlan.self, from: data)
                
                // Success
                completion(.success(floorData))
                
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
    
}
