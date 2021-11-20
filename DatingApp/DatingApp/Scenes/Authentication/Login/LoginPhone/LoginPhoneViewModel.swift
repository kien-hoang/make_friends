//
//  LoginPhoneViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import UIKit

class LoginPhoneViewModel: ObservableObject {
    @Published var phone: String = "0987914956"
    @Published var password: String = "htkien.dev"
    @Published var isShowPassword: Bool = false
    @Published var isLoginSuccess = false
}

// MARK: - API
extension LoginPhoneViewModel {
    func login(completion: @escaping () -> Void) {
        Helper.showProgress()
        AuthenticationAPIManager.shared.loginWith(phone: phone, password: password) { [weak self] success, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if success {
                Helper.showSuccess("Đăng nhập thành công")
                completion()
            }
        }
    }
}
