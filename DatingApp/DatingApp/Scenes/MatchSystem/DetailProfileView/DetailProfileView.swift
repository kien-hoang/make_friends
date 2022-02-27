//
//  DetailProfileView.swift
//  DatingApp
//
//  Created by Radley Hoang on 16/01/2022.
//

import SwiftUI
import Kingfisher

struct DetailProfileView: View {
    @StateObject var viewModel: DetailProfileViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    PhotosView(viewModel: viewModel)

                    InformationView(viewModel: viewModel)
                        .padding(.top, K.Constants.ScreenPadding)
                    
                    if !viewModel.getMyBasicStrings().isEmpty {
                        MyBasicView(viewModel: viewModel)
                            .padding(.top, K.Constants.ScreenPadding)
                    }
                    
                    if !viewModel.getInterestedInTag().isEmpty {
                        InterestedInView(viewModel: viewModel)
                            .padding(.top, K.Constants.ScreenPadding)
                    }
                    
                    ReportView(viewModel: viewModel)
                        .padding(.top, K.Constants.ScreenPadding)
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 100)
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            HStack {
                Button {
                    NotificationCenter.default.post(name: .DismissDetailProfileView, object: nil)
                } label: {
                    Image(Asset.Global.icDefaultBack.name)
                        .frame(width: 30, height: 30)
                        .padding(.leading, 9)
                        .padding(.trailing, 12)
                }
                
                Spacer()
            }
            .frame(height: 44)
        }
        .hiddenNavigationBar()
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - ReportView
    struct ReportView: View {
        @ObservedObject var viewModel: DetailProfileViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF2F2F7.color))
                    .frame(height: 1)
                    .padding(.horizontal, K.Constants.ScreenPadding)
                
                Spacer()
                
                Text("BÁO CÁO VI PHẠM")
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray777777.color)
                
                Spacer()
                
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF2F2F7.color))
                    .frame(height: 1)
                    .padding(.horizontal, K.Constants.ScreenPadding)
            }
            .frame(height: 50)
            .onTapGesture {
                viewModel.isShowReportPopup = true
            }
            // TODO: Show report popup
            .fullScreenCover(isPresented: $viewModel.isShowReportPopup) {
                ReportUserMainView(viewModel: ReportUserMainViewModel(reportedUserId: viewModel.user.id), isShowPopup: $viewModel.isShowReportPopup)
            }
            // TODO: Dismiss report popup
            .onReceive(.DidReportUserSuccess) { _ in
                viewModel.isShowReportPopup = false
                Helper.showSuccess("Báo cáo người dùng thành công")
            }
        }
    }
    
    // MARK: - InterestedInView
    struct InterestedInView: View {
        @ObservedObject var viewModel: DetailProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Sở thích")
                    .style(font: .lexendMedium, size: 18, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 4)
                
                TagLayoutView(
                    viewModel.getInterestedInTag(),
                    tagFont: UIFont(name: K.Fonts.lexendRegular.rawValue, size: 14)!,
                    padding: 20,
                    parentWidth: __SCREEN_WIDTH__) { tag in
                        Text(tag)
                            .style(font: .lexendRegular, size: 14, color: viewModel.isSimilarInterestedInTag(tag) ? Asset.Colors.Global.redD41717.color : Asset.Colors.Global.gray777777.color)
                            .fixedSize()
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background(viewModel.isSimilarInterestedInTag(tag) ? Color(Asset.Colors.Global.redD41717.color).opacity(0.1) : Color(Asset.Colors.Global.gray777777.color).opacity(0.1))
                            .cornerRadius(32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32).stroke(viewModel.isSimilarInterestedInTag(tag) ? Color(Asset.Colors.Global.redD41717.color) : Color(Asset.Colors.Global.gray777777.color), lineWidth: 2)
                            )
                    }
            }
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
    }
    
    // MARK: - MyBasicView
    struct MyBasicView: View {
        @ObservedObject var viewModel: DetailProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Thông tin cơ bản")
                    .style(font: .lexendMedium, size: 18, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 4)
                
                TagLayoutView(
                    viewModel.getMyBasicStrings(),
                    tagFont: UIFont(name: K.Fonts.lexendRegular.rawValue, size: 14)!,
                    padding: 20,
                    parentWidth: __SCREEN_WIDTH__) { tag in
                        Text(tag)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray777777.color)
                            .fixedSize()
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 32).stroke(Color(Asset.Colors.Global.gray777777.color), lineWidth: 2)
                            )
                    }
            }
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
    }
    
    // MARK: - InformationView
    struct InformationView: View {
        @ObservedObject var viewModel: DetailProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.getInformation())
                    .style(font: .lexendMedium, size: 28, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 4)
                
                HStack {
                    VStack(spacing: 4) {
                        Image(Asset.Profile.profileGender.name)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(Asset.Colors.Global.gray777777.color))
                            .frame(width: 25, height: 25)
                        
                        Image(Asset.Global.icLocation.name)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(Asset.Colors.Global.gray777777.color))
                            .frame(width: 20, height: 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.getGenderString())
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray777777.color)
                        
                        Text(viewModel.getLocationDistance())
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray777777.color)
                    }
                }
                .padding(.bottom, 16)
                
                if !viewModel.user.aboutMe.isEmpty {
                    Text("Giới thiệu")
                        .style(font: .lexendMedium, size: 18, color: Asset.Colors.Global.black100.color)
                        .padding(.bottom, 4)
                    Text(viewModel.user.aboutMe)
                        .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray777777.color)
                }
            }
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
    }
    
    // MARK: - PhotosView
    struct PhotosView: View {
        @ObservedObject var viewModel: DetailProfileViewModel
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .top) {
                    let url = !viewModel.user.images.isEmpty ? viewModel.user.images[viewModel.currentImageIndex] : ""
                    KFImage(URL(string: url))
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay(
                                    Image(Asset.Global.icPlaceholderLogo.name)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                )
                        }
                        .scaledToFill()
                        .frame(width: __SCREEN_WIDTH__, height: __SCREEN_WIDTH__ * 1.5)
                        .clipped()
                    
                    HStack {
                        ForEach(0..<viewModel.numberPageControl(), id: \.self) { index in
                            Rectangle()
                                .fill(index == viewModel.currentImageIndex ? Color.white : Color.black.opacity(0.4))
                                .frame(height: 2)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 1)
                    .opacity(viewModel.isShowPageControl() ? 1 : 0)
                }
                
                HStack {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showPreviousImage()
                        }
                    
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.showNextImage()
                        }
                }
                
                Circle()
                    .strokeBorder(Color(Asset.Colors.Global.black100.color), lineWidth: 2)
                    .background(Circle().fill(Color(Asset.Colors.Global.white100.color)))
                    .frame(width: 55, height: 55)
                    .overlay(
                        Image(Asset.Profile.profileDownArrow.name)
                            .resizable()
                            .frame(width: 40, height: 40)
                    )
                    .offset(x: -20, y: 55 / 2)
                    .onTapGesture {
                        NotificationCenter.default.post(name: .DismissDetailProfileView, object: nil)
                    }
            }
        }
    }
}

struct DetailProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProfileView(viewModel: DetailProfileViewModel(user: User.mockUser()))
    }
}
