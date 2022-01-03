//
//  UIApplication+Extensions.swift
//  DatingApp
//
//  Created by Radley Hoang on 01/01/2022.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
