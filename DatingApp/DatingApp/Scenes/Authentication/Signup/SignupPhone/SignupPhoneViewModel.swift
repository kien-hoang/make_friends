//
//  SignupPhoneViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/02/2022.
//

import SwiftUI

class SignupPhoneViewModel: ObservableObject {
    @Published var phoneText = ""
    @Published var isValidPhone: Bool = false
    
    private func validatePhone() -> Bool {
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

// MARK: - API
extension SignupPhoneViewModel {
    func checkExistPhone() {
        guard validatePhone() else { return }
        
        Helper.showProgress()
        AuthenticationAPIManager.shared.checkExistPhone(phoneText) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else {
                self.isValidPhone = isSuccess
            }
        }
    }
}
