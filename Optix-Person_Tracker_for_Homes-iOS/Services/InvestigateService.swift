//
//  InvestigateService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/3/26.
//

import Foundation

class InvestigateService{
    
    func investigate(username: String, userId: String, jwtToken: String, cameraId: String, type: String, startDate: String, endDate: String, completion: @escaping (Result<LogsResponse, Error>) -> Void) {
        
        let credentials = ["user_id": userId,"username": username, "jwt_token": jwtToken, "camera_id": cameraId, "type": type, "starting_time": startDate, "ending_date": endDate]
        
        NetworkManager.shared.request(url: "/logs/investigate", method: "post", body: credentials) { data, response, error in
            
            // Check for Network Errors First (No Internet, etc.)
            if let error = error {
                print("Investigate network failed: \(error)")
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
                let noDataError = NSError(domain: "Investigate", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let response = try decoder.decode(LogsResponse.self, from: data)
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
