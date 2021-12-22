//
//  MatchSuccessViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/12/2021.
//

import SwiftUI

class MatchSuccessViewModel: ObservableObject {
    @Published var selectedTab: Int? = nil
    @Published var firstUserImageString = ""
    @Published var secondUserImageString = ""
    
    func keepSwiping() {
        NotificationCenter.default.post(name: .DismissGotMatchScreen, object: nil)
    }
    
    func goToChat() {
        selectedTab = AppTabView.MessageView.rawValue
        NotificationCenter.default.post(name: .DismissGotMatchScreen, object: nil)
    }
}
