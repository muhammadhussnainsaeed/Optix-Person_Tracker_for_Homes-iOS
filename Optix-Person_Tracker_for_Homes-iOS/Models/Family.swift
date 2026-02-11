//
//  Family.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 10/2/26.
//

import Foundation

struct Family: Codable,Identifiable{
    let id : UUID
    let name: String
    let relationship: String
    let photos: [FamilyPhotos]
    
    enum CodingKeys: String, CodingKey {
        case id,name,relationship,photos
    }
}

struct FamilyPhotos: Codable{
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "photo_url"
    }
}

struct FamilyMemberResponse: Codable{
    let message: String
    let familyMemberList: [Family]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case familyMemberList = "family_members"
    }
}
