//
//  Settings.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 23/2/26.
//

import Foundation

struct Settings: Codable{
    
    
}

struct UpdateNameResponse: Codable{
    let message: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case message, name
    }
}

struct UpdatePasswordResponse: Codable{
    let message: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case username
    }
}

struct UpdateSecurityQuestionResponse: Codable{
    let message: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case userId = "id"
    }
}
