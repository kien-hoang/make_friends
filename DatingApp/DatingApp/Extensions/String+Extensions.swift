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
}
