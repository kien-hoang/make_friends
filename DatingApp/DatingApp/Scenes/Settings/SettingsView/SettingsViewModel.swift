//
//  SettingsViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var currentUser: User = AppData.shared.user ?? User()
    @Published var isShowMeOnMakeFriendApp = true
    @Published var isShowVerifyPhoneAlert = false
    @Published var isShowOTPScreen = false
    
    init() {
        
    }
}

// MARK: - Helper
extension SettingsViewModel {
    func deleteAccount() {
        print("DELETE ACCOUNT")
    }
    
    func verifyPhone() {
        
    }
}
