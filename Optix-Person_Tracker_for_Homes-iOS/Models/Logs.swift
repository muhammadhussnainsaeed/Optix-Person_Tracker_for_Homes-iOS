//
//  Logs.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/2/26.
//

import Foundation

struct Logs : Codable, Identifiable{
    let id: UUID
    let detectedAt: String
    let exitedAt: String?
    let snapshotURL: String?
    let name: String
    let personPhoto: String
    let roomName: String
    let floorTitle: String
    let eventType: String?
    let interactions: [Object]?
    
    enum CodingKeys: String, CodingKey {
        case id = "log_id"
        case detectedAt = "detected_at"
        case exitedAt = "exited_at"
        case snapshotURL = "snapshot_url"
        case name = "person_name"
        case personPhoto = "person_photo"
        case roomName = "room_name"
        case floorTitle = "floor_title"
        case eventType = "event_type"
        case interactions = "interactions"
    }
}

struct Object : Codable, Hashable {
    let name: String
    let movedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name = "object_name"
        case movedAt = "moved_at"
    }
}

struct LogsResponse : Codable {
    let message: String
    let logs: [Logs]
    
    enum CodingKeys: String, CodingKey {
        case message
        case logs
    }
}
