//
//  AppTab.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 20/1/26.
//

import Foundation
import SwiftUI

enum AppTab: String, CaseIterable {
    case home
    case cctv
    case family
    case alerts
    case settings
    
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .cctv: return "CCTV"
        case .family: return "Family"
        case .alerts: return "Alerts"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .cctv: return "video.fill"
        case .family: return "person.2.fill"
        case .alerts: return "exclamationmark.triangle.text.page.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
