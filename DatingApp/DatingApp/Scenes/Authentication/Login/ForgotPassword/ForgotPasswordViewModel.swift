//
//  ForgotPasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var isTrueOTP = false
    @Published var isEnableNextButton = false
    
    @Published var otpField = "" {
        didSet {
            defer {
                isEnableNextButton = otpField.count == 6
            }
            
            guard otpField.count <= 6,
                  otpField.last?.isNumber ?? true else {
                      DispatchQueue.main.async {
                          self.otpField = oldValue
                      }
                      return
                  }
        }
    }
    var otp1: String {
        guard otpField.count >= 1 else {
            return ""
        }
        return String(Array(otpField)[0])
    }
    var otp2: String {
        guard otpField.count >= 2 else {
            return ""
        }
        return String(Array(otpField)[1])
    }
    var otp3: String {
        guard otpField.count >= 3 else {
            return ""
        }
        return String(Array(otpField)[2])
    }
    var otp4: String {
        guard otpField.count >= 4 else {
            return ""
        }
        return String(Array(otpField)[3])
    }
    
    var otp5: String {
        guard otpField.count >= 5 else {
            return ""
        }
        return String(Array(otpField)[4])
    }
    
    var otp6: String {
        guard otpField.count >= 6 else {
            return ""
        }
        return String(Array(otpField)[5])
    }
}

// MARK: - API
extension ForgotPasswordViewModel {
    func checkOTP() {
        Helper.showProgress()
        AuthenticationAPIManager.shared.checkOTP(phone: "0987914956", otpCode: otpField) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                self.isTrueOTP = true
            }
        }
    }
}

// MARK: - Helper
extension ForgotPasswordViewModel {
    func resendOTP() {
        
    }
}
