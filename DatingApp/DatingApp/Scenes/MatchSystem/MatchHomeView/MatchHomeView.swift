//
//  MatchHomeView.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import SwiftUI

struct MatchHomeView: View {
    @StateObject var viewModel = MatchHomeViewModel()
    
    var body: some View {
        VStack {
            CardStack(
                direction: LeftRight.direction,
                data: viewModel.users,
                onSwipe: { card, direction in
                    viewModel.users.append(card)
                },
                content: { user, direction, _ in
                    ZStack {
                        CardViewWithThumbs(user: user, direction: direction)
                    }
                }
            )
                .frame(minWidth: 0, maxWidth: __SCREEN_WIDTH__ - K.Constants.ScreenPadding * 2, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .padding([.top, .bottom], 24)
        }
    }
    
    // MARK: - CardViewWithThumbs
    struct CardViewWithThumbs: View {
        let user: User
        let direction: LeftRight?
        
        var body: some View {
            ZStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    MatchHomeCellView(cellViewModel: MatchHomeCellViewModel(user: user))
                        .animation(.none)
                    Image(Asset.Global.swipeLike.name)
                        .resizable()
                        .foregroundColor(Color.green)
                        .opacity(direction == .right ? 1 : 0)
                        .frame(width: 100, height: 100)
                        .padding()
                }
                
                Image(Asset.Global.swipeDislike.name)
                    .resizable()
                    .foregroundColor(Color.red)
                    .opacity(direction == .left ? 1 : 0)
                    .frame(width: 100, height: 100)
                    .padding()
            }
            .animation(.default)
        }
    }
}

struct MatchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchHomeView()
    }
}
