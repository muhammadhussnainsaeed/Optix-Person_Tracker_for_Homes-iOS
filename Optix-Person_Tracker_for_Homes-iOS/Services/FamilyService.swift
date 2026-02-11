//
//  FamilyService.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 10/2/26.
//

import Foundation

class FamilyService {
    
    private let Network = NetworkManager()

    func fetchAllFamilyMembers(username: String, jwtToken: String, userId: String, completion: @escaping (Result<FamilyMemberResponse, Error>) -> Void){
       
        let urlString = "/family/fetch_all?username=\(username)&jwt_token=\(jwtToken)&user_id=\(userId)"
        
        // Making the Get Request
        Network.request(url: urlString, method: "get") { data, response, error in
            
            // Handle Network/Transport Errors
            if let error = error {
                print("Network error on /family/fetch_all: \(error)")
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
                let noDataError = NSError(domain: "Family Member List", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decodeing DashboardResponse
                let familyMemberListData = try decoder.decode(FamilyMemberResponse.self, from: data)
                
                // Success
                completion(.success(familyMemberListData))
                
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
