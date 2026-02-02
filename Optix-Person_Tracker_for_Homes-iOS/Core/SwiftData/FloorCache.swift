//
//  FloorCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 2/2/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class FloorCache{
    @Attribute(.unique) var id: UUID
    var title: String
    var floorDescription: String
    
    init(id: UUID, title: String, floorDescription: String) {
        self.id = id
        self.title = title
        self.floorDescription = floorDescription
    }
}

extension FloorCache{
    func toResponse() -> Floor{
        return Floor(id: self.id, title: self.title, description: self.floorDescription)
    }
}
