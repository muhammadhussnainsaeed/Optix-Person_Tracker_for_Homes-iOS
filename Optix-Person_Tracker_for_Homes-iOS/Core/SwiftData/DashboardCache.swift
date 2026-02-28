//
//  DashboardCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 25/1/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class DashboardCache{
    @Attribute(.unique) var id: String = "dashboard_cache"
    var cameraCount: Int
    var familyCount: Int
    var todayEventCount: Int
        
    // Relationships (Cascading deletes ensures cleanup)
    @Relationship(deleteRule: .cascade) var recentFamilyLog: RecentLogSD?
    @Relationship(deleteRule: .cascade) var recentUnwantedLog: RecentLogSD?
    
    init(cameraCount: Int, familyCount: Int, todayEventCount: Int, recentFamilyLog: RecentLogSD? = nil, recentUnwantedLog: RecentLogSD? = nil) {
        self.cameraCount = cameraCount
        self.familyCount = familyCount
        self.todayEventCount = todayEventCount
        self.recentFamilyLog = recentFamilyLog
        self.recentUnwantedLog = recentUnwantedLog
    }
}

@Model
final class RecentLogSD {
    @Attribute(.unique) var logId: UUID
    var detectedAt: String
    var exitedAt: String?
    var snapshotUrl: String
    var name: String
    var room: String
    var floor: String
    var personPhoto: String
    var eventType: String?
    @Relationship(deleteRule: .cascade) var ObjectInteration: [ObjectInterationSD]?
    //var ObjectInteration: [ObjectInterationSD]?
    
    init(from apiLog: Logs) {
        self.logId = apiLog.id
        self.detectedAt = apiLog.detectedAt
        self.snapshotUrl = apiLog.snapshotURL ?? ""
        self.name = apiLog.name
        self.room = apiLog.roomName
        self.floor = apiLog.floorTitle
        self.personPhoto = apiLog.personPhoto
        self.eventType = apiLog.eventType ?? ""
        self.ObjectInteration = apiLog.interactions as? [ObjectInterationSD]    }
}

@Model
final class ObjectInterationSD {
    var objectName: String
    var moved_at: String
    
    init(from obj: Object) {
        self.objectName = obj.name
        self.moved_at = obj.movedAt
    }
    
}


extension DashboardCache {
    func toResponse() -> DashboardResponse {
        // Convert SwiftData object back to the API Struct structure
        return DashboardResponse(
            message: "Cached Data",
            cameraCount: self.cameraCount,
            familyCount: self.familyCount,
            todayEventCount: self.todayEventCount,
            recentFamilyLog: self.recentFamilyLog?.toStruct(),
            recentUnwantedLog: self.recentUnwantedLog?.toStruct()
        )
    }
}

extension RecentLogSD {
    func toStruct() -> Logs {
        return Logs (
            id: self.logId,
            detectedAt: self.detectedAt,
            exitedAt: nil,
            snapshotURL: self.snapshotUrl,
            name: self.name,
            personPhoto: self.personPhoto,
            roomName: self.room,
            floorTitle: self.floor,
            eventType: self.eventType,
            interactions: self.ObjectInteration as? [Object] // SwiftData doesn't store this yet based on your model
        )
    }
}
