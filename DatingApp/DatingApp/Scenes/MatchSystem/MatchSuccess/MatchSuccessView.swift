//
//  MatchSuccessView.swift
//  DatingApp
//
//  Created by Radley Hoang on 21/12/2021.
//

import SwiftUI
import Kingfisher

struct MatchSuccessView: View {
    @StateObject var viewModel = MatchSuccessViewModel()
    private var firstImageUrlString = ""
    private var secondImageUrlString = ""
    
    init(firstImageUrlString: String,
         secondImageUrlString: String) {
        self.firstImageUrlString = firstImageUrlString
        self.secondImageUrlString = secondImageUrlString
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                KFImage(URL(string: viewModel.firstUserImageString))
                    .placeholder {
                        Image(Asset.Global.icPlaceholderLogo.name)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .background(
                                Rectangle()
                                    .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                    .frame(width: 160, height: 240)
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 240)
                    .rotationEffect(Angle(degrees: 15))
                    .offset(x: 50, y: -60)
                    
                
                KFImage(URL(string: viewModel.secondUserImageString))
                    .placeholder {
                        Image(Asset.Global.icPlaceholderLogo.name)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .background(
                                Rectangle()
                                    .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                    .frame(width: 160, height: 240)
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 240)
                    .rotationEffect(Angle(degrees: -15))
                    .offset(x: -50, y: 60)
            }
            .padding(.top, 40)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            Spacer()
            
            Text("Kết nối thành công")
                .style(font: .lexendMedium, size: 24, color: Asset.Colors.Global.redD41717.color)
                .padding(.bottom, 12)
            Text("Hãy bắt đầu trò chuyện với họ")
                .style(font: .lexendRegular, size: 13, color: Asset.Colors.Global.black100.color)
                .padding(.bottom, 50)
            
            SayHelloButton(viewModel: viewModel)
            KeepSwipingButton(viewModel: viewModel)
        }
        .onAppear {
            viewModel.firstUserImageString = firstImageUrlString
            viewModel.secondUserImageString = secondImageUrlString
        }
    }
    
    // MARK: - SayHelloButton
    struct SayHelloButton: View {
        @EnvironmentObject private var viewRouter: ViewRouter
        @ObservedObject var viewModel: MatchSuccessViewModel
        
        var body: some View {
            VStack {
                Button {
                    viewModel.goToChat()
                } label: {
                    Text("Trò chuyện")
                        .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                        .padding(8)
                        .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(Asset.Colors.Global.redD41717.color))
                                .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                        )
                }
            }
            .padding([.top, .bottom], 10)
            .frame(maxWidth: .infinity)
            .onReceive(viewModel.$selectedTab) { selectedTab in
                // update state on env changed
                if let selectedTab = selectedTab {
                    viewRouter.selectedTab = selectedTab
                }
            }
        }
    }
    
    // MARK: - KeepSwipingButton
    struct KeepSwipingButton: View {
        @ObservedObject var viewModel: MatchSuccessViewModel
        
        var body: some View {
            VStack() {
                Button {
                    viewModel.keepSwiping()
                } label: {
                    Text("Tiếp tục")
                        .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.redD41717.color)
                        .padding(8)
                        .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(Asset.Colors.Global.redD41717.color).opacity(0.15))
                                .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                        )
                }
            }
            .padding([.top, .bottom], 10)
            .frame(maxWidth: .infinity)
        }
    }
}

struct MatchSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        MatchSuccessView(firstImageUrlString: "", secondImageUrlString: "")
    }
}
