//
//  MainView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI

enum AppTabView: Int, CaseIterable {
    case MatchHomeView = 0
    case LikesView
    case MessageView
    case ProfileView
}

struct MainView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @State private var selection = 0
    
    init() {
        // Background Color: UITabBar.appearance().barTintColor = .blue
        // Unselected item color: UITabBar.appearance().unselectedItemTintColor = .black.withAlphaComponent(0.5)
        let attributedString: [NSAttributedString.Key: Any] = [.font: UIFont(name: K.Fonts.lexendMedium.rawValue, size: 10)!]
        UITabBarItem.appearance().setTitleTextAttributes(attributedString, for: .normal)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $selection) {
                ForEach(AppTabView.allCases, id:\.self) { tabView in
                    switch tabView {
                    case .MatchHomeView:
                        MatchHomeView()
                            .tabItem {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Kết bạn")
                            }
                            .tag(tabView.rawValue)
                        
                    case .LikesView:
                        LikesView()
                            .tabItem {
                                Image(systemName: "heart.circle.fill")
                                Text("Yêu thích")
                            }
                            .tag(tabView.rawValue)
                        
                    case .MessageView:
                        MessageMainView()
                            .tabItem {
                                Image(systemName: "plus.message.fill")
                                Text("Trò chuyện")
                            }
                            .tag(tabView.rawValue)
                        
                    case .ProfileView:
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.crop.circle.fill")
                                Text("Người dùng")
                            }
                            .tag(tabView.rawValue)
                    }
                }
            }
            .accentColor(Color(Asset.Colors.Global.redD41717.color))
            .onChange(of: selection) { selectedTab in
                // store local to environment
                viewRouter.selectedTab = selectedTab
            }
            .onReceive(viewRouter.$selectedTab) { selectedTab in
                // update state on env changed
                selection = selectedTab
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
