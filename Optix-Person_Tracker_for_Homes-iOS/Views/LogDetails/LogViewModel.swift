//
//  LogViewModel.swift
//  Optix-Person_Tracker_for_Homes-iOS
//
//  Created by Hussnain on 6/5/26.
//

import Foundation
import Combine

@MainActor
class LogViewModel: ObservableObject {
    
    @Published var otherServiceObject = OtherService()
    @Published var personList: [AllPersons] = []
    @Published var allPersonListResponse: AllPersonsList?
    @Published var logCorrectionResponse: LogCorrectionResponse?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Getting Persons
    func fetchPersonList() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                otherServiceObject.fetchAllPersons(
                    username: SessionManager.shared.currentUsername,
                    jwtToken: SessionManager.shared.getAuthToken() ?? "",
                    userId: SessionManager.shared.currentUserID?.uuidString ?? ""
                ) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.allPersonListResponse = fetchedData
            
            // 1. UPDATE LIST: Use the fresh API data immediately
            if let person = fetchedData.personList {
                self.personList = person
            }
            
            self.isLoading = false
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
            // Fallback is already handled by the initial loadFromCache
        }
    }
    
    //
    func personLogCorrection(eventId: UUID, isNewPerson: Bool, personId: UUID?) async{
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedData = try await withCheckedThrowingContinuation { continuation in
                otherServiceObject.logsCorrection(username: SessionManager.shared.currentUsername, userId: SessionManager.shared.currentUserID?.uuidString ?? "", jwtToken: SessionManager.shared.getAuthToken() ?? "", eventId: eventId.uuidString, isNewPerson: isNewPerson, personId: personId?.uuidString) { result in
                    switch result {
                    case .success(let data): continuation.resume(returning: data)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
            
            self.logCorrectionResponse = fetchedData
            
            print("\(fetchedData)")
            
            self.isLoading = false
            //print("Camera has been updated")
            
        } catch {
            print("API Error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
        }
    }
}
