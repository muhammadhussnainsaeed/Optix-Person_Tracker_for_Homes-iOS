//
//  SmartBoundriesService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import Foundation

class SmartBoundriesService{
    
    func fetchAllMonitoringRules(username: String, jwtToken: String, userId: String, completion: @escaping (Result<MonitoringRuleResponse, Error>) -> Void){
        
        let urlString = "/rules/fetch_all?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)"
        
        // Making the Get Request
        NetworkManager.shared.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /rule/fetch_all: \(error)")
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
                let noDataError = NSError(domain: "Monitoring Rules List", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let monitoringRulesListData = try decoder.decode(MonitoringRuleResponse.self, from: data)
                
                // Success
                completion(.success(monitoringRulesListData))
                
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
    
    func deleteMonitoringRule(username: String, jwtToken: String, userId: String, ruleId: String, completion: @escaping (Result<UpdateDeleteMonitoringRuleResponse, Error>) -> Void) {
        
        // Map directly to your FastAPI MonitoringRuleDeleteRequest schema
        let credentials: [String: Any] = [
            "user_id": userId,
            "username": username,
            "rule_id": ruleId,
            "jwt_token": jwtToken
        ]
        
        // Note: Method is "post" because the FastAPI route is @router.post("/rules/delete")
        NetworkManager.shared.request(url: "/rules/delete", method: "post", body: credentials) { data, response, error in
            
            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }
            
            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {
                
                // If status is NOT success (e.g., 400, 401, 404, 500)
                if !(200...299).contains(httpResponse.statusCode) {
                    
                    // Attempt to decode the specific "detail" from the FastAPI backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {
                        
                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }
                    
                    // CRITICAL: Stop execution here.
                    return
                }
            }
            
            // Handle Data Decoding (Only runs if Status Code was 200 or any other success code)
            guard let data = data else {
                let noDataError = NSError(domain: "Delete Monitoring Rule", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(UpdateDeleteMonitoringRuleResponse.self, from: data)
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
    
    func updateMonitoringRule(ruleId: String, username: String, jwtToken: String,
        userId: String, ruleName: String, personId: String, cameraIds: [String],
        fromTime: String?, toTime: String?, isActive: Bool,
        completion: @escaping (Result<UpdateDeleteMonitoringRuleResponse, Error>) -> Void
    ) {
        
        // Construct the base parameters matching the Pydantic model
        var params: [String: Any] = [
            "rule_id": ruleId,
            "username": username,
            "jwt_token": jwtToken,
            "user_id": userId,
            "rule_name": ruleName,
            "person_id": personId,
            "is_active": isActive,
            "camera_ids": cameraIds // Array of Strings for your junction table
        ]
        
        // Safely append optional time strings if they exist
        if let fromTime = fromTime {
            params["from_time"] = fromTime
        }
        
        if let toTime = toTime {
            params["to_time"] = toTime
        }

        // Method is "post" because the FastAPI route is @router.post("/rules/update")
        NetworkManager.shared.request(url: "/rules/update", method: "post", body: params) { data, response, error in

            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }

            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {

                // If status is NOT success (e.g., 400, 401, 404, 500)
                if !(200...299).contains(httpResponse.statusCode) {

                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {

                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }

                    // CRITICAL: Stop execution here.
                    return
                }
            }

            // Handle Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Update Monitoring Rule", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(UpdateDeleteMonitoringRuleResponse.self, from: data)
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
    
    func toggleMonitoringRule(
        ruleId: String,
        username: String,
        jwtToken: String,
        userId: String,
        isActive: Bool,
        completion: @escaping (Result<UpdateDeleteMonitoringRuleResponse, Error>) -> Void
    ) {
        
        // Construct the payload matching the Pydantic model
        let params: [String: Any] = [
            "username": username,
            "jwt_token": jwtToken,
            "user_id": userId,
            "rule_id": ruleId,
            "is_active": isActive // Swift Bool maps perfectly to JSON true/false
        ]
        
        // Method is "post" because the FastAPI route is @router.post("/rules/toggle")
        NetworkManager.shared.request(url: "/rules/toggle", method: "post", body: params) { data, response, error in

            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }

            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {

                // If status is NOT success (e.g., 400, 401, 404, 500)
                if !(200...299).contains(httpResponse.statusCode) {

                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {

                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }

                    // CRITICAL: Stop execution here.
                    return
                }
            }

            // Handle Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Toggle Monitoring Rule", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(UpdateDeleteMonitoringRuleResponse.self, from: data)
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
    
    func fetchRuleCameras(
        ruleId: String,
        username: String,
        jwtToken: String,
        userId: String,
        completion: @escaping (Result<FetchRuleCamerasResponse, Error>) -> Void
    ) {
        
        // Construct URL with Query Parameters for a GET request
        var components = URLComponents(string: "/rules/cameras")
        components?.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "jwt_token", value: jwtToken),
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "rule_id", value: ruleId)
        ]
        
        guard let urlString = components?.string else {
            completion(.failure(NSError(domain: "Fetch Cameras", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        // Method is "get" and body is nil, as GET requests do not have a body
        NetworkManager.shared.request(url: urlString, method: "get", body: nil) { data, response, error in

            if let error = error {
                print("Network failed: \(error)")
                completion(.failure(error))
                return
            }

            // Check HTTP Status Code
            if let httpResponse = response as? HTTPURLResponse {

                // If status is NOT success (e.g., 400, 401, 404, 500)
                if !(200...299).contains(httpResponse.statusCode) {

                    // Attempt to decode the specific "detail" from the backend
                    if let data = data,
                       let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let detail = errorJson["detail"] as? String {

                        let apiError = APIError(statusCode: httpResponse.statusCode, detail: detail)
                        completion(.failure(apiError))
                    } else {
                        // FALLBACK: If JSON is invalid or missing
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }

                    // CRITICAL: Stop execution here.
                    return
                }
            }

            // Handle Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Fetch Cameras", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(FetchRuleCamerasResponse.self, from: data)
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
    
    func createMonitoringRule(
        ruleName: String,
        personId: String,
        userId: String,
        username: String,
        jwtToken: String,
        cameraIds: [String],
        fromTime: String?,
        toTime: String?,
        isActive: Bool,
        completion: @escaping (Result<UpdateDeleteMonitoringRuleResponse, Error>) -> Void
    ) {
        
        // Construct the payload matching the Pydantic model
        var params: [String: Any] = [
            "rule_name": ruleName,
            "person_id": personId,
            "user_id": userId,
            "username": username,
            "jwt_token": jwtToken,
            "camera_ids": cameraIds, // Maps to camera_ids: List[str]
            "is_active": isActive
        ]
        
        // Safely append optional time strings if they exist
        if let fromTime = fromTime {
            params["from_time"] = fromTime
        }
        
        if let toTime = toTime {
            params["to_time"] = toTime
        }

        // Method is "post" because the FastAPI route is @router.post("/rules/create")
        NetworkManager.shared.request(url: "/rules/create", method: "post", body: params) { data, response, error in

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
                        // FALLBACK: If JSON is invalid or missing
                        let genericError = APIError(statusCode: httpResponse.statusCode, detail: "Server error (Code: \(httpResponse.statusCode))")
                        completion(.failure(genericError))
                    }

                    // CRITICAL: Stop execution here.
                    return
                }
            }

            // Handle Data Decoding
            guard let data = data else {
                let noDataError = NSError(domain: "Create Monitoring Rule", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(UpdateDeleteMonitoringRuleResponse.self, from: data)
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

