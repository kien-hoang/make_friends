//
//  PushingButtonView.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/11/2021.
//

import SwiftUI

/// A control that initiates an action and pushes new view into navigation stack.
///
/// You create a button by providing a destination view, an action and a label.
/// The destination view will be  pushed when user clicks or taps the button.
/// The action is either a method or closure property that does something when
/// a user clicks or taps the button. The label is a view that describes the button's
/// action --- for example:
///
///     Button(destionationView: ChildView() {
///         // Action when user triggers the button
///     } label: {
///         Text("SignIn")
///     }
struct PushingButtonView<DestinationView, Label> : View where DestinationView : View, Label : View {
    
    @State var isPushView = false
    
    let destinationView: DestinationView
    let action: () -> Void
    let label: Label
    
    /// Creates a button that displays a custom label. Push destination view when tap on it.
    ///
    /// - Parameters:
    ///   - destinationView: The destination view will be pushed when the user triggers the button.
    ///   - action: The action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    init(destinationView: DestinationView, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.destinationView = destinationView
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Group {
            destinationView
                .navigatePush(whenTrue: $isPushView)
            Button {
                action()
                isPushView = true
            } label: {
                label
            }
        }
    }
}
