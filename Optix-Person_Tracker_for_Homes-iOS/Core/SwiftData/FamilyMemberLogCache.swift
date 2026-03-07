//
//  FamilyMemberLogCache.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 1/3/26.
//

import Foundation
import SwiftData

@Model
class FamilyMemberLogCache {
    
    @Relationship(deleteRule: .cascade) var log: [LogsCache]?
    
    init(log: [LogsCache]? = nil) {
        self.log = log
    }
}


