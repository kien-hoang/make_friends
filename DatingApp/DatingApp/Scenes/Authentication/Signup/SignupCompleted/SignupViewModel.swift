//
//  SignupViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 14/11/2021.
//

import SwiftUI
import Combine

class SignupViewModel: ObservableObject {    
    @Published var phone: String = "0987914956"
    @Published var password: String = "htkien"
    @Published var isShowPassword: Bool = false
    @Published var confirmPassword: String = "htkien"
    @Published var isShowConfirmPassword: Bool = false
    @Published var name: String = "Radley Hoang"
    @Published var dateOfBirth: Date = Date()
    @Published var dateOfBirthString: String = ""
    @Published var isShowCalendar: Bool = false
    @Published var email: String = "htkien.dev@gmail.com"
    
    @Published var isValidUser: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $dateOfBirth
            .sink { date in
                self.dateOfBirthString = date.ddMMyyyy
            }
            .store(in: &cancellables)
    }
    
    private func validateUser() -> String? {
        // Validated phone before
        if password.isEmpty {
            return "Vui lòng nhập mật khẩu"
        }
        if confirmPassword.isEmpty {
            return "Vui lòng nhập mật khẩu xác nhận"
        }
        if confirmPassword != password {
            return "Mật khẩu không trùng nhau"
        }
        if name.isEmpty {
            return "Vui lòng nhập tên"
        }
        if email.isEmpty {
            return "Vui lòng nhập email"
        }
        if !email.isValidEmail() {
            return "Vui lòng nhập email hợp lệ"
        }
        
        return nil
    }
    
    private func getUserProperties() -> [String: Any] {
        var params: [String: Any] = [:]
        params[K.API.ParameterKeys.Name] = name
        params[K.API.ParameterKeys.Phone] = phone
        params[K.API.ParameterKeys.Email] = email
        params[K.API.ParameterKeys.Password] = password
        params[K.API.ParameterKeys.DateOfBirth] = dateOfBirth.MMddyyyy
        return params
    }
}

// MARK: - API
extension SignupViewModel {
    func createNewAccount() {
        if let error = validateUser() {
            Helper.showToast(error)
            return
        }
        
        let params = getUserProperties()
        
        Helper.showProgress()
        AuthenticationAPIManager.shared.signup(params: params) { [weak self] user, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let _ = user {
//                self.isValidUser = true
            }
        }
    }
}
