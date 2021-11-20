//
//  String+Extensions.swift
//  DatingApp
//
//  Created by Radley Hoang on 04/11/2021.
//

import Foundation
//import Localize_Swift

extension String {
    var toError: Error {
        return NSError(domain: "Internal Server Error", code: 888 , userInfo: [NSLocalizedDescriptionKey: self]) as Error
    }
    
//    func localized() -> String {
//        return self.localized()
//    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
