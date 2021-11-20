//
//  MatchHomeView.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import SwiftUI

struct MatchHomeView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        Button {
            Helper.deleteLocalValue(withKey: K.UserDefaults.Token)
            viewRouter.currentView = .LoginView
            
        } label: {
            Text("Logout")
        }

    }
}

struct MatchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchHomeView()
    }
}
