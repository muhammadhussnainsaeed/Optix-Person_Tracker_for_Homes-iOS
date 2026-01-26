//
//  DashboardResponse.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/1/26.
//

import Foundation
struct DashboardResponse: Codable{
    let message: String
    let cameraCount: Int
    let familyCount: Int
    let todayEventCount: Int
    let recentFamilyLog: RecentLog?
    let recentUnwantedLog: RecentLog?

    enum CodingKeys: String, CodingKey {
        case message
        case cameraCount = "camera_count"
        case familyCount = "family_count"
        case todayEventCount = "today_event_count"
        case recentFamilyLog = "recent_family_log"
        case recentUnwantedLog = "recent_unwanted_log"
    }
}

struct ObjectInteration: Codable{
    let objectName: String
    let movedAt: String
    
    enum CodingKeys: String, CodingKey {
        case objectName = "object_name"
        case movedAt = "moved_at"
    }
}

struct RecentLog: Codable {
    let id: String
    let detectedAt: String
    let exitedAt: String?
    let snapshotUrl: String
    let name: String
    let photo: String
    let room: String
    let floor: String
    let objectInteraction: [ObjectInteration]?
        
    enum CodingKeys: String, CodingKey {
        case id
        case detectedAt = "detected_at"
        case exitedAt = "exited_at"
        case snapshotUrl = "snapshot_url"
        case name = "name"
        case photo = "person_photo"
        case room = "room"
        case floor = "floor"
        case objectInteraction = "object_interaction"
    }
}
