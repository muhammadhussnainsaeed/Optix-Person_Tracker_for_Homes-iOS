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
    let recentFamilyLog: Logs?
    let recentUnwantedLog: Logs?

    enum CodingKeys: String, CodingKey {
        case message
        case cameraCount = "camera_count"
        case familyCount = "family_count"
        case todayEventCount = "today_event_count"
        case recentFamilyLog = "recent_family_log"
        case recentUnwantedLog = "recent_unwanted_log"
    }
}
