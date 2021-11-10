//
//  DefaultNavigationView.swift
//  DatingApp
//
//  Created by Radley Hoang on 10/11/2021.
//

import SwiftUI

struct DefaultNavigationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image("ic_default_back")
                    .frame(width: 30, height: 30)
                    .padding(.leading, 9)
            }
            Spacer()
        }
        .frame(height: K.Constants.NavigationHeight)
    }
}
