//
//  Floor.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/2/26.
//

import Foundation

struct Floor: Codable, Identifiable{
    let id: UUID
    let title: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
    }
}

struct FloorResponse: Codable {
    let message: String
    let count: Int
    let floorList: [Floor]?
    
    enum CodingKeys: String, CodingKey {
        case message, count
        case floorList = "Floors"
    }
}
