//
//  SignupCompletedView.swift
//  DatingApp
//
//  Created by Radley Hoang on 14/11/2021.
//

import SwiftUI

struct SignupCompletedView: View {
    @ObservedObject var viewModel = SignupViewModel()
    
    init(phone: String = "") {
        viewModel.phone = phone
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // TODO: Hide calendar when tapping around
            if viewModel.isShowCalendar {
                Rectangle()
                    .fill(Color.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.isShowCalendar = false
                    }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                DefaultNavigationView()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hoàn tất đăng ký")
                        .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                        .padding(.bottom, 40)
                    
                    MainBody(viewModel: viewModel)
                        .padding(.bottom, 44)
                    
                    ContinueButton(viewModel: viewModel)
                }
                .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 0, trailing: K.Constants.ScreenPadding))
                
                Spacer()
            }
            
            if viewModel.isShowCalendar {
                SignupCalendar(viewModel.dateOfBirth)
                    .callback { dateOfBirth in
                        viewModel.dateOfBirth = dateOfBirth
                        viewModel.isShowCalendar = false
                    }
                    .animation(.easeInOut)
            }
        }
    }
    
    // MARK: - MainBody
    struct MainBody: View {
        @ObservedObject var viewModel: SignupViewModel
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
                                        SecureField("Nhập lại mật khẩu", text: $viewModel.password)
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
                    
                    // MARK: Name
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Tên của bạn:")
                            .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                            .padding(.bottom, 6)
                        
                        TextField("Nhập họ và tên", text: $viewModel.name)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            .padding(.bottom, 4)
                        
                        CustomDivider()
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: DateOfBirth
                    ZStack(alignment: .centerTextAlignment) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Ngày sinh:")
                                .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                                .padding(.bottom, 6)
                            
                            TextField("Chọn ngày sinh", text: $viewModel.dateOfBirthString)
                                .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                                .padding(.bottom, 4)
                                .disabled(true)
                                .alignmentGuide(.centerTextVerticalAlignment) { d in
                                    d[VerticalAlignment.center]
                                }
                            
                            CustomDivider()
                        }
                        
                        Image(Asset.Authentication.Signup.icCalendar.name)
                            .frame(width: 30, height: 30)
                            .alignmentGuide(.centerTextVerticalAlignment) { d in
                                d[VerticalAlignment.center]
                            }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            viewModel.isShowCalendar = true
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: Email
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Email:")
                            .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
                            .padding(.bottom, 6)
                        
                        TextField("Nhập email", text: $viewModel.email)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            .keyboardType(.emailAddress)
                            .padding(.bottom, 4)
                        
                        CustomDivider()
                    }
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
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: SignupViewModel
        
        var body: some View {
            PushingButtonWhenTrue($viewModel.isValidUser, destinationView: EmptyView()) {
                viewModel.createNewAccount()
            } label: {
                Text("Đăng ký")
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

struct SignupCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SignupCompletedView()
//            .previewDevice("iPhone 6s")
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
