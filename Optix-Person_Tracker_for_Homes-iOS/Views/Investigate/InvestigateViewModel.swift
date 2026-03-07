//
//  InvestigateViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 7/3/26.
//

import Foundation
import Combine

@MainActor
class InvestigateViewModel: ObservableObject {
    
    @Published var investigateServiceObject = InvestigateService()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var logResponse: LogsResponse?
    @Published var logList: [Logs] = []
    
    func investigate(cameraId: UUID?, type: String, startDate: Date, endDate: Date) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                
                investigateServiceObject.investigate(username: SessionManager.shared.currentUsername, userId: SessionManager.shared.currentUserID?.uuidString ?? "", jwtToken: SessionManager.shared.getAuthToken() ?? "", cameraId: cameraId?.uuidString ?? "", type: type, startDate: AppFormatter.shared.getDatabaseFormattedString(from: startDate), endDate: AppFormatter.shared.getDatabaseFormattedString(from: endDate)) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.logResponse = fetchedData
            
            self.logList = fetchedData.logs
            
            self.isLoading = false
            print("Logs updated from API")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
}
