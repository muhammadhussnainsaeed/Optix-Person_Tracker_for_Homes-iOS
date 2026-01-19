//
//  NetworkManager.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 17/1/26.
//

import Foundation

class NetworkManager{
    let baseURL = "http://192.168.100.8:8888"
    
    //This function will deal requests having nil body data
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
    
    //This function will deal requests having body data
    func request(url: String, method: String, body: [String: Any]? = nil, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: baseURL + url) else {
            completion(nil, NSError(domain: "Invalid URL", code: 404))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Adding body data here for POST method call
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(nil, error)
                return
            }
        }
        
        //calling the API here
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        
        task.resume()
    }
}
