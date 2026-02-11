//
//  FamilyMemberCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 10/2/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class FamilyMemberCache{
    @Attribute(.unique) var id: UUID
    var name: String
    var relationship: String
    var photos: [FamilyMemberPhoto]
    
    init(id: UUID, name: String, relationship: String, photos: [FamilyMemberPhoto]) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.photos = photos
    }
    
}

extension FamilyMemberCache{
    func toResponse() -> Family {
            // 1. CONVERT photos back (Map Class -> Struct)
            let convertedPhotos = self.photos.map { cachePhoto in
                FamilyPhotos(photo: cachePhoto.photo)
            }
            
            return Family(
                id: self.id,
                name: self.name,
                relationship: self.relationship,
                photos: convertedPhotos // Pass the converted array
            )
        }
}

@Model
class FamilyMemberPhoto{
    var photo : String
    init(photo: String) {
        self.photo = photo
    }
}
