//
//  RootView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI

// Your app views
enum AppView {
    case LoginView
    case MainAppView
}

struct RootView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            switch viewRouter.currentView {
            case .LoginView:
                LoginView()
            case .MainAppView:
                MainView()
            }
        }
    }
}

class ViewRouter: ObservableObject {
    // here you can decide which view to show at launch
    @Published var currentView: AppView = .LoginView
    @Published var selectedTab: Int = AppTabView.MatchHomeView.rawValue
}
