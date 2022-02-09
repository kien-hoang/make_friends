//
//  ForgotPasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

enum OTPType {
    case ForgotPassword
    case VerifyPhone
}

class ForgotPasswordViewModel: ObservableObject {
    @Published var isTrueOTP = false
    @Published var isEnableNextButton = false
    @Published var resendTimeString = ""
    
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
    var phone: String = ""
    private var otpType: OTPType = .ForgotPassword
    private var timer: Timer?
    private var countDownTime: Int = 120
    
    init(_ type: OTPType, phone: String) {
        self.otpType = type
        self.phone = phone
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.forgotPassword()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func destinationView() -> AnyView {
        switch otpType {
        case .ForgotPassword:
            let newPasswordViewModel = NewPasswordViewModel(phone: phone)
            return AnyView(NewPasswordView(viewModel: newPasswordViewModel))
        case .VerifyPhone:
            return AnyView(EmptyView())
        }
    }
}

// MARK: - API
extension ForgotPasswordViewModel {
    func checkOTP() {
        switch otpType {
        case .ForgotPassword:
            checkOTPForgotPassword()
            
        case .VerifyPhone:
            verifyPhone()
        }
    }
    
    private func verifyPhone() {
        Helper.showProgress()
        UserAPIManager.shared.verifyUser(otpCode: otpField) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                AppData.shared.user.isVerified = true
                self.isTrueOTP = true
                NotificationCenter.default.post(name: .DidVerifyPhoneSuccess, object: nil)
            }
        }
    }
    
    private func checkOTPForgotPassword() {
        Helper.showProgress()
        AuthenticationAPIManager.shared.checkOTP(phone: phone, otpCode: otpField) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                self.isTrueOTP = true
            }
        }
    }
    
    private func forgotPassword() {
        Helper.showProgress()
        AuthenticationAPIManager.shared.forgotPassword(phone: phone) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                NavigationUtil.popToRootView {
                    Helper.showProgressError(error.localizedDescription)
                }
            } else if isSuccess {
                // Enter OTP
                self.startOtpTimer()
            }
        }
    }
}

// MARK: - Helper
extension ForgotPasswordViewModel {
    func resendOTP() {
        guard timer == nil else { return }
        startOtpTimer()
    }
    
    private func startOtpTimer() {
        countDownTime = 10
        resendTimeString = timeFormatted(countDownTime)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        resendTimeString = timeFormatted(countDownTime) // will show timer
        if countDownTime != 0 {
            countDownTime -= 1  // decrease counter timer
        } else {
            resendTimeString = "Thử lại"
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - OTP Variables
extension ForgotPasswordViewModel {
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
