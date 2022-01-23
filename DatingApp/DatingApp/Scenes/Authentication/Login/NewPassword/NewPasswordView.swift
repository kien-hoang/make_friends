//
//  NewPasswordView.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject var viewModel = NewPasswordViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DefaultNavigationView()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Nhập mật khẩu mới")
                    .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 40)
                
                MainBody(viewModel: viewModel)
                    .padding(.bottom, 44)
                
                ContinueButton(viewModel: viewModel)
            }
            .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 0, trailing: K.Constants.ScreenPadding))
            
            Spacer()
        }
    }
    
    // MARK: - MainBody
    struct MainBody: View {
        @ObservedObject var viewModel: NewPasswordViewModel
        @State private var contentSize: CGSize = .zero
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
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
                    
                    // MARK: ConfirmPassword
                    ZStack(alignment: .centerTextAlignment) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Xác nhận mật khẩu:")
                                .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                                .padding(.bottom, 6)
                            
                            HStack(spacing: 4) {
                                Group {
                                    if viewModel.isShowConfirmPassword {
                                        TextField("Nhập lại mật khẩu", text: $viewModel.confirmPassword)
                                        
                                    } else {
                                        SecureField("Nhập lại mật khẩu", text: $viewModel.confirmPassword)
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
                        
                        Image(viewModel.isShowConfirmPassword ? Asset.Authentication.Signup.icHideEye.name : Asset.Authentication.Signup.icUnhideEye.name)
                            .frame(width: 30, height: 30)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.isShowConfirmPassword.toggle()
                            }
                            .alignmentGuide(.centerTextVerticalAlignment) { d in
                                d[VerticalAlignment.center]
                            }
                        
                    }
                    .padding(.bottom, 20)
                }
                .overlay(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            contentSize = geo.size
                        }
                    }
                )
            }
            .frame(minWidth: contentSize.width, maxHeight: contentSize.height)
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
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: NewPasswordViewModel
        
        var body: some View {
            PushingButtonWhenTrue(Binding.constant(false), destinationView: EmptyView()) {
                
            } label: {
                Text("Xác nhận")
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

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView()
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
