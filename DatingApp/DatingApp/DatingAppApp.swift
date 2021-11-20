//
//  DatingAppApp.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/10/2021.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct DatingAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var viewRouter = ViewRouter()
    
    init() {
        // This init function is didFinishLaunchWithOptions in UIKit
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1.5) as Date)
        Helper.configureToastView()
        Helper.configureProgressHUD()
        IQKeyboardManager.shared.enable = true
        
        Helper.deleteLocalValue(withKey: K.UserDefaults.Token)
        if Helper.getLocalValue(withKey: K.UserDefaults.Token) != nil {
            viewRouter.currentView = .MainAppView
        } else {
            viewRouter.currentView = .LoginView
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewRouter)
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            switch viewRouter.currentView {
            case .LoginView:
                LoginView()
            case .MainAppView:
                MatchHomeView()
            }
        }
    }
}

//Your app views
enum AppView {
    case LoginView
    case MainAppView
}

class ViewRouter: ObservableObject {
    // here you can decide which view to show at launch
    @Published var currentView: AppView = .LoginView
}
