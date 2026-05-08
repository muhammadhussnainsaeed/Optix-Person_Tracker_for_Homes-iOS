//
//  OtherService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/5/26.
//

import Foundation

class OtherService{
    
    // To fetch all the persons of the user
    func fetchAllPersons(username: String, jwtToken: String, userId: String, completion: @escaping (Result<AllPersonsList, Error>) -> Void){
        
        let urlString = "/others/get_all_persons?user_id=\(userId)&username=\(username)&jwt_token=\(jwtToken)"
        
        // Making the Get Request
        NetworkManager.shared.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /others/get_all_persons: \(error)")
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
                let noDataError = NSError(domain: "Fetch all Person", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let personListData = try decoder.decode(AllPersonsList.self, from: data)
                
                // Success
                completion(.success(personListData))
                
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
    
    func getAllFamily(
        username: String,
        jwtToken: String,
        userId: String,
        completion: @escaping (Result<GetAllFamilyResponse, Error>) -> Void
    ) {
        
        // Construct URL with Query Parameters for a GET request
        var components = URLComponents(string: "/others/get_all_family")
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "jwt_token", value: jwtToken)
        ]
        
        guard let urlString = components?.string else {
            completion(.failure(NSError(domain: "Get All Family", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        // Method is "get" and body is nil
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
                let noDataError = NSError(domain: "Get All Family", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(GetAllFamilyResponse.self, from: data)
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
    
    // To correct the logs
    func logsCorrection(username: String, userId: String, jwtToken: String, eventId: String, isNewPerson: Bool, personId: String?, completion: @escaping (Result<LogCorrectionResponse, Error>) -> Void) {
        
        var credentials: [String: Any] = ["user_id": userId,"username": username, "jwt_token": jwtToken, "event_id": eventId, "is_new_person": isNewPerson]
        
        if let validPersonId = personId {
                credentials["correct_person_id"] = validPersonId
            }
        
        NetworkManager.shared.request(url: "/logs/correction", method: "post", body: credentials) { data, response, error in
            
            // Check for Network Errors First (No Internet, etc.)
            if let error = error {
                print("Logs Correction network failed: \(error)")
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
                let noDataError = NSError(domain: "Log Correction", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let response = try decoder.decode(LogCorrectionResponse.self, from: data)
                completion(.success(response))
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
