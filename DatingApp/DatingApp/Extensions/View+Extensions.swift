//
//  View+Extensions.swift
//  BiduSwiftUI
//
//  Created by Radley Hoang on 12/09/2021.
//

import SwiftUI

// MARK: - Navigation
extension View {
    func navigatePush(whenTrue toggle: Binding<Bool>) -> some View {
        NavigationLink(
            destination: self.hiddenNavigationBar(),
            isActive: toggle
        ) { EmptyView() }
        .hidden()
    }
    
    func hiddenNavigationBar() -> some View {
        self.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    func navigationView() -> some View {
        NavigationView {
            self
        }
    }
}

// MARK: - Helper
extension View {
    func setBackgroundColor(_ color: Color) -> some View {
        ZStack {
            color
                .edgesIgnoringSafeArea(.all)
            self
        }
    }
}

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
    func style(font: K.Fonts, size: CGFloat, color: UIColor) -> some View {
        self
            .font(font, size: size)
            .textColor(color)
    }
    
    func font(_ font: K.Fonts, size: CGFloat) -> some View {
        self.font(.custom(font.rawValue, size: size))
    }
    
    func textColor(_ color: UIColor) -> some View {
        self.foregroundColor(Color(color))
    }
}

// MARK: - IF Modifier
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Notification
extension View {
    func onReceive(_ name: Notification.Name,
                   center: NotificationCenter = .default,
                   object: AnyObject? = nil,
                   perform action: @escaping (Notification) -> Void) -> some View {
        self.onReceive(
            center.publisher(for: name, object: object), perform: action
        )
    }
}

extension View {
    public func alert(isPresented: Binding<Bool>, _ alert: AlertConfig) -> some View {
        AlertHelper(isPresented: isPresented, alert: alert, content: self)
    }
}
