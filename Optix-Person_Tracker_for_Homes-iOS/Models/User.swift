//
//  User.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 17/1/26.
//

import Foundation

struct User: Codable {
    let message: String
    let id: UUID
    let username: String
    let name: String
    let token: String
}

struct SignupUserResponse: Codable{
    let message: String
    let id: UUID
    let username: String
}
