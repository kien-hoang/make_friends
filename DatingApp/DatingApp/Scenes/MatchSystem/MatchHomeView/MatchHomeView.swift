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
            switch viewModel.viewType {
            case .DisableLocation:
                DisableLocationView(viewModel: viewModel)
            case .Swipeable:
                SwipeableView(viewModel: viewModel)
            case .LoadingData:
                ProgressView()
            }
        }
        // TODO: Start application if get profile user success
        .onReceive(.GetProfileUserSuccess) { _ in
            viewModel.updateDeviceToken()
            viewModel.checkLocationPermission()
            SocketClientManager.shared.connected()
        }
    }
    
    // MARK: - DisableLocationView
    struct DisableLocationView: View {
        @ObservedObject var viewModel: MatchHomeViewModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 12) {
                Text("Oops")
                    .style(font: .lexendBold, size: 18, color: Asset.Colors.Global.black100.color)
                Text("Để sử dụng Make Friends bạn cần bật chức năng vị trí của bạn.")
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
                Text("Hãy đến Cài đặt > Make Friends > Vị trí >  Bật vị trí khi sử dụng ứng dụng")
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
                    .padding(.bottom, 12)
                
                Button {
                    viewModel.gotoSettings()
                } label: {
                    Text("ĐẾN CÀI ĐẶT")
                        .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.redD41717.color)
                        .frame(width: 250, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(Asset.Colors.Global.redD41717.color), lineWidth: 2)
                        )
                }

            }
            .padding([.leading, .trailing], 50)
            .multilineTextAlignment(.center)
        }
    }
    
    
    
    // MARK: - SwipeableView
    struct SwipeableView: View {
        @ObservedObject var viewModel: MatchHomeViewModel
        
        var body: some View {
            ZStack {
                OutOfSwipeableView(viewModel: viewModel)
                
                CardStack(
                    direction: LeftRight.direction,
                    data: viewModel.users,
                    onSwipe: { card, direction in
                        viewModel.swipingUser(card, direction: direction)
                        viewModel.loadMoreIfNeeded()
                    },
                    content: { user, direction, _ in
                        ZStack {
                            CardViewWithThumbs(user: user, direction: direction)
                        }
                    }
                )
                    // TODO: Show/dismiss Detail Profile View
                    .fullScreenCover(isPresented: $viewModel.isPresentDetailProfileView) {
                        let viewModel = DetailProfileViewModel(user: viewModel.getTopUser())
                        DetailProfileView(viewModel: viewModel)
                            .hiddenNavigationBar()
                            .navigationView()
                    }
                    .onReceive(.DismissDetailProfileView) { _ in
                        viewModel.isPresentDetailProfileView = false
                    }
                    .onTapGesture {
                        viewModel.didCardTapped()
                    }
            }
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
    
    // MARK: - OutOfSwipeableView
    struct OutOfSwipeableView: View {
        @ObservedObject var viewModel: MatchHomeViewModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 12) {
                Text("Oops")
                    .style(font: .lexendBold, size: 18, color: Asset.Colors.Global.black100.color)
                Text("Đã hết hồ sơ người dùng.")
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
                Text("Hãy thay đổi bộ lọc của bạn để tiếp tục tìm những hồ sơ mới nhé!")
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
                    .padding(.bottom, 12)
                
                Button {
                    viewModel.reloadHome()
                } label: {
                    Text("THỬ LẠI")
                        .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.redD41717.color)
                        .frame(width: 250, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(Asset.Colors.Global.redD41717.color), lineWidth: 2)
                        )
                }
            }
            .padding([.leading, .trailing], 50)
            .multilineTextAlignment(.center)
        }
    }
}

struct MatchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchHomeView()
    }
}
