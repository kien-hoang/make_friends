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
    
    var isValidPassword: Bool { //at least 8 characters, at least 1 uppercase and 1 lowercase
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
//    func localized() -> String {
//        return self.localized()
//    }
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidPhone() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
//        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        return phoneTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func toDate(withDateFormatter dateFormatter: DateFormatter) -> Date {
        return dateFormatter.date(from: self) ?? Date()
    }
}
