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
    @Attribute(.unique) var logId: String
    var detectedAt: String
    var exitedAt: String?
    var snapshotUrl: String
    var name: String
    var room: String
    var floor: String
    var personPhoto: String
    @Relationship(deleteRule: .cascade) var ObjectInteration: [ObjectInterationSD]?
    //var ObjectInteration: [ObjectInterationSD]?
    
    init(from apiLog: RecentLog) {
        self.logId = apiLog.id
        self.detectedAt = apiLog.detectedAt
        self.snapshotUrl = apiLog.snapshotUrl
        self.name = apiLog.name
        self.room = apiLog.room
        self.floor = apiLog.floor
        self.personPhoto = apiLog.photo
        self.ObjectInteration = apiLog.objectInteraction as? [ObjectInterationSD]    }
}

@Model
final class ObjectInterationSD {
    var objectName: String
    var moved_at: String
    
    init(from obj: ObjectInteration) {
        self.objectName = obj.objectName
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
    func toStruct() -> RecentLog {
        return RecentLog(
            id: self.logId,
            detectedAt: self.detectedAt,
            exitedAt: nil,
            snapshotUrl: self.snapshotUrl,
            name: self.name,
            photo: self.personPhoto,
            room: self.room,
            floor: self.floor,
            objectInteraction: self.ObjectInteration as? [ObjectInteration] // SwiftData doesn't store this yet based on your model
        )
    }
}
