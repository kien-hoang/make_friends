//
//  UpdateFirstImageView.swift
//  DatingApp
//
//  Created by Radley Hoang on 26/11/2021.
//

import SwiftUI

struct UpdateFirstImageView: View {
    @StateObject var viewModel = UpdateFirstImageViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Thêm ảnh đầu tiên của bạn:")
                .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                .padding(.bottom, 12)
            Text("Đây chính là ảnh sẽ hiển thị đầu tiên trên hồ sơ của bạn")
                .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray9A9A9A.color)
                .padding(.bottom, 33)
            
            UpdateImageView(viewModel: viewModel)
            
            Spacer()
            ContinueButton(viewModel: viewModel)
        }
        .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 10, trailing: K.Constants.ScreenPadding))
        
    }
    
    // MARK: - UpdateImageView
    struct UpdateImageView: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        
        var body: some View {
            AddingImageView(viewModel: viewModel)
        }
    }
    
    struct AddingImageView: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(Asset.Colors.Global.white100.color))
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Asset.Colors.Global.gray9A9A9A.color), lineWidth: 1)
                        )
                Image(Asset.Authentication.InitUser.initUserAdd.name)
            }
            .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 10, trailing: K.Constants.ScreenPadding))
            .aspectRatio(299/387, contentMode: .fit)
            .onTapGesture {
                viewModel.addingImage()
            }
        }
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        
        var body: some View {
            PushingButtonWhenTrue($viewModel.isUpdateFirstImageSuccess, destinationView: EmptyView()) {
            } label: {
                Text("Tiếp tục")
                    .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                    .padding(8)
                    .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(Asset.Colors.Global.redD41717.color))
                            .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
        }
    }
}

struct UpdateFirstImageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateFirstImageView()
//            .previewDevice("iPhone 6s")
    }
}
