//
//  Alert.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 5/5/26.
//

import Foundation

struct AlertPacket: Codable {
    let type: String
    let userId: String
    let personId: String?
    let cameraId: String
    let cameraName: String
    let personName: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case type, personId = "person_id", cameraId = "camera_id",
             cameraName = "camera_name", personName = "person_name",
             timestamp, userId = "user_id"
    }
    
    // Helper to format the ISO timestamp to "12:00 AM"
    var formattedTime: String {
        // 1. Grab only the "yyyy-MM-ddTHH:mm:ss" part (first 19 characters)
        // This safely ignores Python's microseconds and timezones
        let cleanTimestamp = String(timestamp.prefix(19))
        
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 2. Parse the clean string into a Date object
        if let date = parser.date(from: cleanTimestamp) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a" // Output: "12:30 PM"
            return timeFormatter.string(from: date)
        }
        
        return "Now" // Fallback (should no longer trigger)
    }
}
