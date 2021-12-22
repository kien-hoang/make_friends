//
//  MainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 27/11/2021.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var isPresentForInvalidUser = false
    @Published var isPresentForGotMatch = false
    var firstImageUrlString = ""
    var secondImageUrlString = ""
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getProfileUser()
        NotificationCenter.default.publisher(for: .UserIsInvalid)
            .sink(receiveValue: { [weak self] _ in
                self?.isPresentForInvalidUser = true
            })
            .store(in: &cancellables)
    }
}

// MARK: - API
extension MainViewModel {
    func getProfileUser() {
        Helper.showProgress()
        UserAPIManager.shared.getProfileUser { [weak self] user, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
                NotificationCenter.default.post(name: .GetProfileUserFailed, object: nil)
            } else if let user = user {
                AppData.shared.user = user // Save to singleton
                if user.isValid {
                    // check location permission
                    NotificationCenter.default.post(name: .GetProfileUserSuccess, object: nil)
                } else {
                    NotificationCenter.default.post(name: .UserIsInvalid, object: nil)
                }
            }
        }
    }
}
