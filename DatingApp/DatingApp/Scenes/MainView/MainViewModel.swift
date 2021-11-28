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
    private func checkValidUser() {
        Helper.showProgress()
        UserAPIManager.shared.checkValidUser { [weak self] isValid, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let isValid = isValid, !isValid {
                NotificationCenter.default.post(name: .UserIsInvalid, object: nil)
            }
        }
    }
    
    func getProfileUser() {
        Helper.showProgress()
        UserAPIManager.shared.getProfileUser { [weak self] user, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let user = user {
                AppData.shared.user = user // Save to singleton
                if !user.isValid {
                    self.checkValidUser()
                }
            }
        }
    }
}
