//
//  SignupPhoneView.swift
//  DatingApp
//
//  Created by Radley Hoang on 10/11/2021.
//

import SwiftUI

struct SignupPhoneView: View {
    @StateObject var viewModel = SignupPhoneViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DefaultNavigationView()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Số điện thoại của bạn là:")
                    .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 40)
                
                HStack(spacing: 8) {
                    VStack(alignment: .center, spacing: 3) {
                        HStack(spacing: 2) {
                            Text("VN +84")
                                .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            Image(Asset.Global.icDownArrow.name)
                                .resizable()
                                .frame(width: 8, height: 4)
                        }
                        
                        Rectangle()
                            .frame(width: 70, height: 1)
                            .foregroundColor(Color(Asset.Colors.Global.gray9A9A9A.color))
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 2) {
                            TextField("", text: $viewModel.phoneText)
                                .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                                .keyboardType(.numberPad)
                                .allowsHitTesting(true)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(Asset.Colors.Global.gray9A9A9A.color))
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 28)
                
                Text("Vui lòng cung cấp số điện thoại chính xác. Chúng tôi sẽ gửi mã xác nhận đến số điện thoại của bạn.")
                    .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.gray9A9A9A.color)
                    .padding(.bottom, 44)
                
                ContinueButton(viewModel: viewModel)
            }
            .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 0, trailing: K.Constants.ScreenPadding))
            
            Spacer()
        }
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @StateObject var viewModel = SignupPhoneViewModel()
        
        var body: some View {
            let signupCompletedView = SignupCompletedView(phone: viewModel.phoneText)
            PushingButtonWhenTrue($viewModel.isValidPhone, destinationView: signupCompletedView) {
                viewModel.checkExistPhone()
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

struct SignupPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        SignupPhoneView()
    }
}
