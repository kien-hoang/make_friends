//
//  ChangePasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/01/2022.
//

import SwiftUI
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword: String = ""
    @Published var isShowOldPassword: Bool = false
    @Published var password: String = ""
    @Published var isShowPassword: Bool = false
    @Published var confirmPassword: String = ""
    @Published var isShowConfirmPassword: Bool = false
    
    var popViewPublisher = PassthroughSubject<Bool, Never>()
}

// MARK: - API
extension ChangePasswordViewModel {
    func changePassword() {
        if let error = validateUser() {
            Helper.showToast(error)
            return
        }
        
        Helper.showProgress()
        AuthenticationAPIManager.shared.changePassword(oldPassword: oldPassword.trim(), newPassword: password.trim()) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                Helper.showSuccess("Đổi mật khẩu thành công")
                self.popViewPublisher.send(true)
            }
        }
    }
}

// MARK: - Helper
extension ChangePasswordViewModel {
    private func validateUser() -> String? {
        if oldPassword.trim().isEmpty {
            return "Vui lòng nhập mật khẩu cũ"
        }
        if password.trim().isEmpty {
            return "Vui lòng nhập mật khẩu mới"
        }
        if confirmPassword.trim().isEmpty {
            return "Vui lòng nhập xác nhận mật khẩu mới"
        }
        if confirmPassword != password {
            return "Mật khẩu mới không trùng nhau"
        }
        
        return nil
    }
}
