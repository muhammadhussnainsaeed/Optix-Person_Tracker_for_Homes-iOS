//
//  AppFormatter.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 21/1/26.
//

import Foundation

class AppFormatter {
    static let shared = AppFormatter()
    
    // 1. Create the input formatter ONCE (Performance optimization)
        // Pattern matches: "2025-12-14 13:02:32.527518+05:00"
        private let inputFormatter: DateFormatter = {
            let formatter = DateFormatter()
            // The pattern must match your input string EXACTLY:
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX") // Critical for parsing server dates fixedly
            formatter.timeZone = TimeZone(secondsFromGMT: 0) // Optional: Adjust if needed
            return formatter
        }()
        
        // 2. Output Formatters
        private let dateOutputFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter
        }()
        
        private let timeOutputFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter
        }()
        
        // 3. Fixed Functions
        func getFormattedDate(from dateString: String) -> String {
            guard let date = inputFormatter.date(from: dateString) else {
                return "Unknown Date"
            }
            return dateOutputFormatter.string(from: date)
        }
        
        func getFormattedTime(from dateString: String) -> String {
            guard let date = inputFormatter.date(from: dateString) else {
                return "--:--"
            }
            return timeOutputFormatter.string(from: date)
        }
}
