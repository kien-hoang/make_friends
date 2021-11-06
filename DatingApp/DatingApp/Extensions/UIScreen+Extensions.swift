//
//  UIScreen+Extensions.swift
//  DatingApp
//
//  Created by Radley Hoang on 06/11/2021.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
//    static let screenHeightInDesign: CGFloat = 812 // iPhone X
//
//    static func getSize(fromDesignSize size: CGSize) -> CGSize {
//        let newWidth = screenWidth
//        let newHeight = screenWidth / size.width * size.height
//        return CGSize(width: newWidth, height: newHeight)
//    }
//
//    /// Get new ratio CGFloat number from design
//    /// designNumber                    =           newVerticalNumber
//    /// screenHeightInDesign        =           screenHeight
//    static func getRatioVerticalNumber(_ designNumber: CGFloat) -> CGFloat {
//        let screenHeightInDesign = screenHeightInDesign
//        return designNumber / screenHeightInDesign * screenHeight
//    }
}
