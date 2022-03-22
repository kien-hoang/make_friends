//
//  UIAlertController+Extensions.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/03/2022.
//

import UIKit

extension UIAlertController {
    convenience init(alert: AlertConfig) {
        self.init(title: alert.title, message: nil, preferredStyle: .alert)
        addTextField { $0.placeholder = alert.placeholder }
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil)
        })
        let textField = self.textFields?.first
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text)
        })
    }
}
