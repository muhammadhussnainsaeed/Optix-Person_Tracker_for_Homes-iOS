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

enum RelationshipType: String, CaseIterable, Identifiable, Codable {
    
    case other = "Other"
    case father = "Father"
    case mother = "Mother"
    case brother = "Brother"
    case sister = "Sister"
    case spouse = "Spouse"
    case son = "Son"
    case daughter = "Daughter"
    case grandfather = "Grandfather"
    case grandmother = "Grandmother"
    case uncle = "Uncle"
    case aunt = "Aunt"
    case cousin = "Cousin"
    case nephew = "Nephew"
    case niece = "Niece"
    case friend = "Friend"
    case neighbor = "Neighbor"
    
    var id: Self { self }
}

struct addUpdateDeleteFamilyMemberResponse: Codable {
    let message: String
    let familyMemberId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case familyMemberId = "family_member_id"
    }
}
