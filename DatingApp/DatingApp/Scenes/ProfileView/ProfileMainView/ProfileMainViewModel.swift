//
//  ProfileMainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/11/2021.
//

import SwiftUI
import Combine

class ProfileMainViewModel: ObservableObject {
    @Published var avatarUrl = ""
    @Published var name = ""
    @Published var age = 0
    @Published var isVerified: Bool = false
    @Published var user: User = AppData.shared.user
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        $user
            .sink { [weak self] user in
                guard let self = self else { return }
                self.avatarUrl = user.images.first ?? ""
                self.name = user.name
                
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: user.dateOfBirth!, to: now)
                self.age = ageComponents.year!
                
                self.isVerified = user.isVerified
            }
            .store(in: &cancellable)
    }
}

// MARK: - Action
extension ProfileMainViewModel {
    func didTapAvatar() {
        print("didTapAvatar")
    }
    
    func didTapVerified() {
        print("didTapVerified")
    }
    
    func didTapSetting() {
        print("didTapSetting")
    }
    
    func didTapAddMedia() {
        print("didTapAddMedia")
    }
    
    func didTapEditProfile() {
        print("didTapEditProfile")
    }
}
