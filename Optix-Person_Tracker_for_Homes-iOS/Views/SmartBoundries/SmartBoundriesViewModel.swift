//
//  SmartBoundriesViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/5/26.
//

import Foundation
import Combine

class SmartBoundriesViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
}
