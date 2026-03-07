//
//  LogsCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 1/3/26.
//

import Foundation
import SwiftData

@Model
class LogsCache {
    @Attribute(.unique) var id: UUID
    var detectedAt: String
    var exitedAt: String?
    var snapshotURL: String?
    var name: String
    var personPhoto: String
    var roomName: String
    var floorTitle: String
    var eventType: String?
    @Relationship(deleteRule: .cascade) var interactions: [ObjectsCache]?
    
    init(from apiLog: Logs) {
        self.id = apiLog.id
        self.detectedAt = apiLog.detectedAt
        self.exitedAt = apiLog.exitedAt
        self.snapshotURL = apiLog.snapshotURL
        self.name = apiLog.name
        self.personPhoto = apiLog.personPhoto
        self.roomName = apiLog.roomName
        self.floorTitle = apiLog.floorTitle
        self.eventType = apiLog.eventType
        
        // FIX: Properly map the struct array to the SwiftData class array
        self.interactions = apiLog.interactions?.map {
            ObjectsCache(name: $0.name, movedAt: $0.movedAt)
        }
    }
}

@Model
class ObjectsCache{
    var name: String
    var movedAt: String
    
    init(name: String, movedAt: String) {
        self.name = name
        self.movedAt = movedAt
    }
}

// MARK: - SwiftData to Struct Mappers
extension LogsCache {
    func toResponse() -> Logs {
        // Map the nested SwiftData objects back to standard structs
        let mappedInteractions = self.interactions?.map {
            Object(name: $0.name, movedAt: $0.movedAt)
        }
        
        return Logs(
            id: self.id,
            detectedAt: self.detectedAt,
            exitedAt: self.exitedAt,
            snapshotURL: self.snapshotURL,
            name: self.name,
            personPhoto: self.personPhoto,
            roomName: self.roomName,
            floorTitle: self.floorTitle,
            eventType: self.eventType,
            interactions: mappedInteractions
        )
    }
}
