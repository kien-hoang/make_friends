//
//  Helper.swift
//  BiduSwiftUI
//
//  Created by Radley Hoang on 19/09/2021.
//

import UIKit
import Alamofire
import Localize_Swift
import Toaster
import ProgressHUD

class Helper {
    static func getCurrentLanguagueCode() -> String {
        let language = Localize.currentLanguage()
        if language == "vi-VN" {
            return "vi"
        } else {
            return language
        }
    }
    
    static var defaultHeaders: HTTPHeaders! {
        if let token = Helper.getLocalValue(withKey: K.UserDefaults.Token) {
            return ["Authorization": "Bidu \(token)",
                    "Accept": "application/json",
                    K.API.HeaderKey.AcceptLanguage: Helper.getCurrentLanguagueCode()]
        }
        return ["Accept": "application/json",
                K.API.HeaderKey.AcceptLanguage: Helper.getCurrentLanguagueCode()]
    }
    
    static func saveLocal(value: Any, key: String) {
        let standard = UserDefaults.standard
        standard.setValue(value, forKey: key)
        standard.synchronize()
    }
    
    static func getLocalValue(withKey key: String) -> Any? {
        let standard = UserDefaults.standard
        let value = standard.value(forKey: key)
        return value
    }
}

// MARK: - Toaster
extension Helper {
    static func configureToastView() {
        ToastView.appearance().textInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        ToastView.appearance().bottomOffsetPortrait = 40
        ToastView.appearance().font = UIFont(name: K.Fonts.lexendMedium.rawValue, size: 13)
        ToastView.appearance().backgroundColor = Asset.Colors.Global.black100.color
        ToastView.appearance().textColor = Asset.Colors.Global.white100.color
        ToastView.appearance().shadowColor = UIColor.black
        ToastView.appearance().shadowOffset = CGSize(width: 2, height: 4)
        ToastView.appearance().shadowOpacity = 0.15
        ToastView.appearance().shadowRadius = 2
        ToastView.appearance().useSafeAreaForBottomOffset = true
    }
    
    static func showSuccess(_ message: String?) {
        Helper.showToast(message)
    }
    
    static func showToast(_ message: String?) {
        guard let message = message else {return}
        ToastCenter.default.cancelAll()
        Toast(text: message).show()
    }
    
    static func showInfo(_ message: String?) {
        Helper.showToast(message)
    }
}

// MARK: - ProgressHUB
extension Helper {
    static func configureProgressHUD() {
        ProgressHUD.colorAnimation = Asset.Colors.Global.redD41717.color
        ProgressHUD.colorStatus = Asset.Colors.Global.black100.color
        ProgressHUD.fontStatus = UIFont(name: K.Fonts.lexendMedium.rawValue, size: 20) ?? .systemFont(ofSize: 20)
        ProgressHUD.colorBackground = Asset.Colors.Global.gray9A9A9A.color.withAlphaComponent(0.5)
        ProgressHUD.animationType = .circleRotateChase
    }
    
    static func showProgress(_ message: String? = nil) {
        ProgressHUD.show(message, interaction: false)
    }
    
    static func dismissProgress() {
        ProgressHUD.dismiss()
    }
    
    static func showProgressError(_ error: String? = nil) {
        ProgressHUD.showFailed(error)
    }
    
    static func showProgressSuccess(_ success: String? = nil) {
        ProgressHUD.showSucceed(success)
    }
}
