//
//  NetworkManager.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 17/1/26.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    
    let baseURL = "http://192.168.100.221:8888"
    
    //This function will deal requests having nil body and body data
    func request(url: String, method: String, body: [String: Any]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        // 1. Construct the URL
        guard let urlObj = URL(string: baseURL + url) else {
            // Case A: Invalid URL (Fail early)
            completion(nil, nil, NSError(domain: "Invalid URL", code: 404))
            return
        }
        
        // 2. Setup the Request
        var request = URLRequest(url: urlObj)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. Attach the Body (Username/Password)
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        // 4. Call the API
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Always switch to Main Thread before returning to the UI/ViewModel
            DispatchQueue.main.async {
                // Pass ALL three items back: Data, Response, and Error
                completion(data, response, error)
            }
        }
        
        task.resume()
    }

    // This function will deal request having multipart
    func multipartRequest(url: String, method: String, params: [String: String]? = nil, files: [MediaFile]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlObj = URL(string: baseURL + url) else {
            completion(nil, nil, NSError(domain: "Invalid URL", code: 404))
            return
        }
        
        var request = URLRequest(url: urlObj)
        request.httpMethod = method
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construct the Body
        // This helper function combines text params and files
        request.httpBody = createMultipartBody(params: params, files: files, boundary: boundary)
        
        // 5. Call the API
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        
        task.resume()
    }

    // Body Builder Helper for multipartRequest function
    private func createMultipartBody(params: [String: String]?, files: [MediaFile]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        // Add Text Parameters
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        // Add File Parameters
        if let mediaFiles = files {
            for file in mediaFiles {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.filename)\"\(lineBreak)")
                body.append("Content-Type: \(file.mimeType + lineBreak + lineBreak)")
                body.append(file.data)
                body.append(lineBreak)
            }
        }
        
        // Close the Boundary
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
