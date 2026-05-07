//
//  Other.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/5/26.
//

import Foundation
import Combine

struct AllPersons: Codable, Identifiable {
    let id : String
    let name: String
    let personType: String
    let photo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case personType = "person_type"
        case photo = "primary_photo"
    }
    
}

struct AllPersonsList: Codable{
    let message: String
    let personList: [AllPersons]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case personList = "data"
    }
    
}

