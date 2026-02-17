//
//  MediaFile.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 16/2/26.
//

import Foundation
import UIKit

struct MediaFile {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    // Default to JPEG
    init(data: Data, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "\(UUID().uuidString).jpg"
        self.data = data
    }
}
