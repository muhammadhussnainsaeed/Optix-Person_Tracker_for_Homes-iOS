//
//  APIError.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 19/1/26.
//

import Foundation

import Foundation

struct APIError: Error, LocalizedError {
    let statusCode: Int
    let detail: String
    
    var errorDescription: String? {
        return detail
    }
}
