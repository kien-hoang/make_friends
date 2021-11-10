//
//  UINavigation+Extensions.swift
//  DatingApp
//
//  Created by Radley Hoang on 10/11/2021.
//

import UIKit

// A custom back button and the swipe back gesture
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
