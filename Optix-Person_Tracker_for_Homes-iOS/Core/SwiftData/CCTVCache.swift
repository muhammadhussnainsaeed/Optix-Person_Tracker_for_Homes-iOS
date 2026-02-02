//
//  CCTVCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 26/1/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class CCTVCache{
    @Attribute(.unique) var id: UUID
    var name: String
    var location: String
    var cctvdescription: String
    var videoURL: String
    var isPrivate: Bool
    var floorId: UUID
    
    init(id: UUID, name: String, location: String, cctvdescription: String, videoURL: String, isPrivate: Bool, floorId: UUID) {
        self.id = id
        self.name = name
        self.location = location
        self.cctvdescription = cctvdescription
        self.videoURL = videoURL
        self.isPrivate = isPrivate
        self.floorId = floorId
    }
}

extension CCTVCache{
    func toResponse() -> CCTV{
        return CCTV(id: self.id, name: self.name, location: self.location, cctvDescription: self.cctvdescription, videoURL: self.videoURL, isPrivate: self.isPrivate, floorId: self.floorId)
    }
}
