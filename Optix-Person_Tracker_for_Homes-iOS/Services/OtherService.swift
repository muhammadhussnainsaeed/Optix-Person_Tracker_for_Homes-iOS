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
    
}
