//
//  SmartBoundries.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import Foundation

struct MonitoringRule: Codable, Identifiable {
    let id : String
    let ruleName: String
    let fromTime: String?
    let toTime: String?
    let isActive: Bool
    let personName: String
    let photo: String
    let cameras: [CamerasObject]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ruleName = "rule_name"
        case fromTime = "from_time"
        case toTime = "to_time"
        case isActive = "is_active"
        case personName = "person_name"
        case photo = "person_photo_url"
        case cameras
    }
}

struct CamerasObject : Codable, Identifiable{
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "camera_id"
        case name = "camera_name" 
    }
}

struct MonitoringRuleResponse: Codable {
    let message: String
    let rules: [MonitoringRule]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case rules
    }
}
