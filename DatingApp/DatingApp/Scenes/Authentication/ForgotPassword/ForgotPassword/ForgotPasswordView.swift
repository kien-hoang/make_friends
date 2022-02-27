//
//  ForgotPasswordView.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel: ForgotPasswordViewModel
    @State var isFocused = false
    
    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DefaultNavigationView()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Mã xác nhận của bạn là:")
                    .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 50)
                
                HStack {
                    Spacer()
                    ZStack {
                        HStack(spacing: spaceBetweenBoxes) {
                            otpText(text: viewModel.otp1)
                            otpText(text: viewModel.otp2)
                            otpText(text: viewModel.otp3)
                            otpText(text: viewModel.otp4)
                            otpText(text: viewModel.otp5)
                            otpText(text: viewModel.otp6)
                        }
                        
                        TextField("", text: $viewModel.otpField)
                            .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                            .textContentType(.oneTimeCode)
                            .foregroundColor(.clear)
                            .accentColor(.clear)
                            .background(Color.clear)
                            .keyboardType(.numberPad)
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text(viewModel.resendTimeString)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.gray777777.color)
                        .onTapGesture {
                            viewModel.resendOTP()
                        }
                    Spacer()
                }
                .padding(.vertical, 30)
                
                ContinueButton(viewModel: viewModel)
            }
            .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 0, trailing: K.Constants.ScreenPadding))
            
            Spacer()
        }
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    private func otpText(text: String) -> some View {
        return Text(text)
            .style(font: .lexendMedium, size: 24, color: Asset.Colors.Global.black100.color)
            .frame(width: textBoxWidth, height: textBoxHeight)
            .background(
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 1)
                }
            )
            .padding(paddingOfBox)
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: ForgotPasswordViewModel
        
        var body: some View {
            let fillColor = viewModel.isEnableNextButton ? Color(Asset.Colors.Global.redD41717.color) : Color(Asset.Colors.Global.gray777777.color)
            
            PushingButtonWhenTrue($viewModel.isTrueOTP, destinationView: viewModel.destinationView()) {
                if viewModel.isEnableNextButton {
                    viewModel.checkOTP()
                }
                
            } label: {
                Text("Tiếp tục")
                    .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                    .padding(8)
                    .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(fillColor)
                            .shadow(color: fillColor.opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(viewModel: ForgotPasswordViewModel(.ForgotPassword, phone: ""))
    }
}
