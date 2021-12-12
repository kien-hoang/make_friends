//
//  MatchHomeViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/12/2021.
//

import SwiftUI
import CoreLocation

class MatchHomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var location: CLLocation = CLLocation(latitude: 16.527688, longitude: 107.481690)
    @Published var currentPage: Int = 0
    
    init() {
        getRecommendUsers()
    }
}

// MARK: - API
extension MatchHomeViewModel {
    func getRecommendUsers() {
        Helper.showProgress()
        RecsAPIManager.shared.getRecommendUser(location: location, currentPage: currentPage, limit: 2) { [weak self] users, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                self.users = users
            }
        }
    }
}
