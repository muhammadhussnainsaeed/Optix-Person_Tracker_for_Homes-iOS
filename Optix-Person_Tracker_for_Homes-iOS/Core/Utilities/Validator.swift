//
//  Validator.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 18/1/26.
//

import Foundation

class Validator{
    static let shared = Validator()
    
    func isPasswordValid(_ password: String) -> Bool {
        let regex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    func isPasswordConfirmationValid(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}
