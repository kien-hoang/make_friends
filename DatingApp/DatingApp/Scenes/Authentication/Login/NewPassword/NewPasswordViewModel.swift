//
//  NewPasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

class NewPasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var isShowPassword: Bool = false
    @Published var confirmPassword: String = ""
    @Published var isShowConfirmPassword: Bool = false
}

// MARK: - API
extension NewPasswordViewModel {
    func setNewPassword() {
        if let error = validateUser() {
            Helper.showToast(error)
            return
        }
        
        Helper.showProgress()
        AuthenticationAPIManager.shared.newPassword(phone: "0987914956", password: password) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                Helper.showSuccess("Nhập mật khẩu thành công. Vui lòng đăng nhập!")
                NavigationUtil.popToRootView {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        NotificationCenter.default.post(name: NSNotification.Name(K.KeyPaths.DidSignupSuccess), object: nil)
                    }
                }
            }
        }
    }
}

// MARK: - Helper
extension NewPasswordViewModel {
    private func validateUser() -> String? {
        // Validated phone before
        if password.trim().isEmpty {
            return "Vui lòng nhập mật khẩu"
        }
        if confirmPassword.trim().isEmpty {
            return "Vui lòng nhập mật khẩu xác nhận"
        }
        if confirmPassword != password {
            return "Mật khẩu không trùng nhau"
        }
        
        return nil
    }
}
