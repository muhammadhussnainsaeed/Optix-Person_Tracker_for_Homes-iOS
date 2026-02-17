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
    
    func createFamilyMember(username: String, jwtToken: String, userId: String, relationship: String, name : String, files: [MediaFile], completion: @escaping (Result<addUpdateDeleteFamilyMemberResponse, Error>) -> Void){

        let params: [String: String] = ["name": name, "relationship": relationship, "username": username,"jwt_token": jwtToken, "user_id": userId]

        Network.multipartRequest(url: "/family/add", method: "post", params: params, files: files){data,response,error in

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
                let noDataError = NSError(domain: "Add Family Member", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateDeleteFamilyMemberResponse.self, from: data)
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
    
    func updateFamilyMember(memberId: String, username: String, jwtToken: String, userId: String, relationship: String, name : String, files: [MediaFile], completion: @escaping (Result<addUpdateDeleteFamilyMemberResponse, Error>) -> Void){

        let params: [String: String] = ["person_id": memberId, "name": name, "relationship": relationship, "username": username,"jwt_token": jwtToken, "user_id": userId]

        Network.multipartRequest(url: "/family/update", method: "put", params: params, files: files){data,response,error in

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
                let noDataError = NSError(domain: "Update Family Member", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateDeleteFamilyMemberResponse.self, from: data)
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
    
    func deleteFamilyMember(username: String, jwtToken: String, userId: String, memberId: String, completion: @escaping (Result<addUpdateDeleteFamilyMemberResponse, Error>) -> Void){
     
        let credentials: [String: Any] = ["user_id": userId, "username": username, "person_id": memberId, "jwt_token": jwtToken]
        
        Network.request(url: "/family/delete", method: "delete", body: credentials) {
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
                let noDataError = NSError(domain: "Delete Family Member", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use this if your backend uses
                let responseData = try decoder.decode(addUpdateDeleteFamilyMemberResponse.self, from: data)
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
