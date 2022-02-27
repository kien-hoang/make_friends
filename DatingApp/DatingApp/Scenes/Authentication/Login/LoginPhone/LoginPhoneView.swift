//
//  LoginPhoneView.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import SwiftUI

struct LoginPhoneView: View {
    @StateObject var viewModel = LoginPhoneViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DefaultNavigationView()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Đăng nhập:")
                    .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 40)
                
                MainBody(viewModel: viewModel)
                    .padding(.bottom, 44)
                
                ContinueButton(viewModel: viewModel)
            }
            .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 0, trailing: K.Constants.ScreenPadding))
            
            Spacer()
        }
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - MainBody
    struct MainBody: View {
        @ObservedObject var viewModel: LoginPhoneViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: Name
                VStack(alignment: .leading, spacing: 0) {
                    Text("Số điện thoại:")
                        .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                        .padding(.bottom, 6)
                    
                    HStack(spacing: 8) {
                        VStack(alignment: .center, spacing: 3) {
                            HStack(spacing: 2) {
                                Text("VN +84")
                                    .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                                Image(Asset.Global.icDownArrow.name)
                                    .resizable()
                                    .frame(width: 8, height: 4)
                            }
                            
                            CustomDivider()
                                .frame(width: 70)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 2) {
                                TextField("Nhập số điện thoại", text: $viewModel.phone)
                                    .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                                    .keyboardType(.numberPad)
                                    .allowsHitTesting(true)
                            }
                            
                            CustomDivider()
                        }
                        
                        Spacer()
                    }
                    .frame(height: 30)
                }
                .padding(.bottom, 20)
                
                // MARK: Password
                ZStack(alignment: .centerTextAlignment) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Mật khẩu:")
                            .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                            .padding(.bottom, 6)
                        
                        HStack(spacing: 4) {
                            Group {
                                if viewModel.isShowPassword {
                                    TextField("Nhập mật khẩu", text: $viewModel.password)
                                    
                                } else {
                                    SecureField("Nhập mật khẩu", text: $viewModel.password)
                                }
                            }
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            .frame(height: 20)
                            .alignmentGuide(.centerTextVerticalAlignment) { d in
                                d[VerticalAlignment.center]
                            }
                            
                        }
                        .padding(.bottom, 4)
                        
                        CustomDivider()
                    }
                    
                    Image(viewModel.isShowPassword ? Asset.Authentication.Signup.icHideEye.name : Asset.Authentication.Signup.icUnhideEye.name)
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                        .alignmentGuide(.centerTextVerticalAlignment) { d in
                            d[VerticalAlignment.center]
                        }
                        .onTapGesture {
                            viewModel.isShowPassword.toggle()
                        }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @EnvironmentObject private var viewRouter: ViewRouter
        @ObservedObject var viewModel: LoginPhoneViewModel
        
        var body: some View {
            PushingButtonWhenTrue($viewModel.isLoginSuccess, destinationView: EmptyView()) {
                viewModel.login {
                    viewRouter.currentView = .MainAppView
                }
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
    
    // MARK: - CustomDivider
    struct CustomDivider: View {
        var body: some View {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(Asset.Colors.Global.gray9A9A9A.color))
        }
    }
}

struct LoginPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPhoneView()
    }
}

// MARK: - AlignmentGuides
fileprivate extension VerticalAlignment {
    struct CenterTextVerticalAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    
    static let centerTextVerticalAlignment = VerticalAlignment(CenterTextVerticalAlignment.self)
}

fileprivate extension Alignment {
    static let centerTextAlignment = Alignment(horizontal: .trailing, vertical: .centerTextVerticalAlignment)
}
