//
//  ForgotPasswordPhoneViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 27/01/2022.
//

import SwiftUI

class ForgotPasswordPhoneViewModel: ObservableObject {
    @Published var phoneText = ""
    @Published var isValidPhone: Bool = false
}

// MARK: - Helper
extension ForgotPasswordPhoneViewModel {
    func validatePhone() -> Bool {
        if phoneText.trim().isEmpty {
            Helper.showToast("Vui lòng nhập số điện thoại")
            return false
        }
        if !phoneText.isValidPhone() {
            Helper.showToast("Vui lòng nhập số điện thoại hợp lệ")
            return false
        }
        
        return true
    }
}
