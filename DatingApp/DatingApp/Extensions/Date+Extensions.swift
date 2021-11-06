//
//  Date+Extensions.swift
//  BiduSwiftUI
//
//  Created by Radley Hoang on 19/09/2021.
//

import Foundation

extension Date {
    static let fullStringFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0
    }(DateFormatter())
}

extension Date {
    static func dateFullFormat(from string: String) -> Date? {
        let formatter = Date.fullStringFormatter
        let date = formatter.date(from: string)
        return date
    }
}
