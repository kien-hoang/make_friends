//
//  View+Extensions.swift
//  BiduSwiftUI
//
//  Created by Radley Hoang on 12/09/2021.
//

import SwiftUI

// MARK: - Frame
extension View {
    func fullParentFrame(alignment: Alignment = .topLeading) -> some View {
        self.frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: alignment)
    }
}

// MARK: - Text
extension View {
    func style(font: K.Font, size: CGFloat, color: UIColor) -> some View {
        self
            .font(font, size: size)
            .textColor(color)
    }
    
    func font(_ font: K.Font, size: CGFloat) -> some View {
        self.font(.custom(font.rawValue, size: size))
    }
    
    func textColor(_ color: UIColor) -> some View {
        self.foregroundColor(Color(color))
    }
}
