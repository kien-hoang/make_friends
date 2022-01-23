//
//  ForgotPasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var isTrueOTP = false
    
    @Published var otpField = "" {
        didSet {
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

// MARK: - Helper
extension ForgotPasswordViewModel {
    func resendOTP() {
        
    }
}
