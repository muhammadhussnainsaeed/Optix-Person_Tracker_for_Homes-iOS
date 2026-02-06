//
//  CCTV.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import Foundation

struct CameraGraphResponse: Codable {
    let connections: [String: [Bool]]
}

struct CCTVResponse: Codable {
    let message: String
    let cctvlist: [CCTV]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case cctvlist = "cameras"
    }
}

struct CCTV: Codable,Identifiable {
    let id: UUID
    let name: String
    let location: String
    let cctvDescription: String
    let videoURL: String
    let isPrivate: Bool
    let floorId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, name, location
        case cctvDescription = "description"
        case videoURL = "video_url"
        case isPrivate = "is_private"
        case floorId = "floor_id"
    }
}

struct CCTVResponseForUpdateDelete: Codable {
    let message: String
    let id: UUID
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case message, id , name
    }
}
