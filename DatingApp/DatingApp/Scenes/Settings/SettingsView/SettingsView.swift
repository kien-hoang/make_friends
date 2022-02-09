//
//  SettingsView.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
            
            ScrollView {
                VStack(spacing: 0) {
                    AccountSettingsView(viewModel: viewModel)
                        .padding(.top, 8)
                    
                    ShowMeOnCardStackView(viewModel: viewModel)
                        .padding(.top, 16)
                    
                    LogoutView()
                        .padding(.top, 24)
                    
                    DeleteAccountView(viewModel: viewModel)
                        .padding(.top, 24)
                }
            }
            Spacer()
        }
        .hiddenNavigationBar()
        .background(Color(Asset.Colors.Global.grayF2F2F7.color))
    }
    
    // MARK: - DeleteAccountView
    struct DeleteAccountView: View {
        @ObservedObject var viewModel: SettingsViewModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    Text("Xoá tài khoản")
                        .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.redD41717.color)
                    Spacer()
                }
            }
            .frame(height: 45)
            .background(Color(Asset.Colors.Global.white100.color))
            .onTapGesture {
                viewModel.deleteAccount()
            }
        }
    }
    
    // MARK: - LogoutView
    struct LogoutView: View {
        @EnvironmentObject private var viewRouter: ViewRouter
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    Text("Đăng xuất")
                        .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
            }
            .frame(height: 45)
            .background(Color(Asset.Colors.Global.white100.color))
            .onTapGesture {
                Helper.deleteLocalValue(withKey: K.UserDefaults.Token)
                viewRouter.selectedTab = AppTabView.MatchHomeView.rawValue
                viewRouter.currentView = .LoginView
                LocationManager.shared.stopUpdatingLocation()
                AppData.shared.isUpdatedLocation = false
                AppData.shared.deviceToken = ""
                SocketClientManager.shared.userLogout()
            }
        }
    }
    
    // MARK: - ShowMeOnCardStackView
    struct ShowMeOnCardStackView: View {
        @ObservedObject var viewModel: SettingsViewModel
        
        var body: some View {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Hiển thị tài khoản của tôi")
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        Spacer()
                        Toggle("", isOn: $viewModel.isShowMeOnMakeFriendApp)
                            .toggleStyle(SwitchToggleStyle(tint: Color(Asset.Colors.Global.redD41717.color)))
                    }
                    .padding(.horizontal, K.Constants.ScreenPadding)
                }
                .frame(height: 45)
                .background(Color(Asset.Colors.Global.white100.color))
                
                Text("Trong khi tắt, bạn sẽ không được hiển thị trong tìm kiếm của người khác. Bạn vẫn có thể xem và trò chuyện với bạn bè của mình.")
                    .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.gray777777.color)
                    .padding(.horizontal, K.Constants.ScreenPadding)
            }
        }
    }
    
    // MARK: - AccountSettingsView
    struct AccountSettingsView: View {
        @ObservedObject var viewModel: SettingsViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Thiết lập tài khoản")
                    .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.gray777777.color)
                    .padding(.horizontal, K.Constants.ScreenPadding)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Số điện thoại")
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        if !viewModel.currentUser.isVerified {
                            Text("Chưa xác thực")
                                .style(font: .lexendLight, size: 10, color: Asset.Colors.Global.redD41717.color)
                                .padding(3)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(Asset.Colors.Global.redD41717.color), lineWidth: 1)
                                )
                        }
                        
                        Spacer()
//                        Text("0987914956")
                        Text(viewModel.currentUser.phone)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        Image(Asset.Global.icDefaultNext.name)
                            .resizable()
                            .frame(width: 8, height: 12)
                    }
                    .padding(.horizontal, K.Constants.ScreenPadding)
                }
                .frame(height: 45)
                .background(Color(Asset.Colors.Global.white100.color))
                .contentShape(Rectangle())
                .onTapGesture {
                    if !viewModel.currentUser.isVerified {
                        viewModel.isShowVerifyPhoneAlert = true
                    }
                }
                .alert(isPresented: $viewModel.isShowVerifyPhoneAlert) {
                    Alert(
                        title: Text("Gửi mã xác thực"),
                        message: Text("Chúng tôi sẽ gửi mã xác thực về số điện thoại của bạn"),
                        primaryButton: .default (Text("OK")) {
                            viewModel.isShowOTPScreen = true
                            viewModel.verifyPhone()
                        },
                        secondaryButton: .cancel(Text("Không"))
                    )
                }
                // TODO: Show OTP screen
                .fullScreenCover(isPresented: $viewModel.isShowOTPScreen) {
                    if !viewModel.currentUser.phone.isEmpty {
                        ForgotPasswordView(viewModel: ForgotPasswordViewModel(.VerifyPhone, phone: viewModel.currentUser.phone))
                    }
                }
                // TODO: Dismiss OTP screen
                .onReceive(.DidVerifyPhoneSuccess) { _ in
                    viewModel.isShowOTPScreen = false
                    Helper.showSuccess("Xác thực tài khoản thành công")
                }
                
                if !viewModel.currentUser.isVerified {
                    Text("Vui lòng xác thực số điện thoại để hồ sơ của bạn có thể được hiển thị với người khác.")
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.redD41717.color.withAlphaComponent(0.75))
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.top, 4)
                        .padding(.bottom, 8)
                }
                
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF2F2F7.color))
                    .frame(height: 1)
                    .padding(.horizontal, K.Constants.ScreenPadding)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Email")
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        Spacer()
//                        Text(verbatim: "htkien.dev@gmail.com")
                        Text(viewModel.currentUser.email)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            
                        Image(Asset.Global.icDefaultNext.name)
                            .resizable()
                            .frame(width: 8, height: 12)
                    }
                    .padding(.horizontal, K.Constants.ScreenPadding)
                }
                .frame(height: 45)
                .background(Color(Asset.Colors.Global.white100.color))
                
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF2F2F7.color))
                    .frame(height: 1)
                    .padding(.horizontal, K.Constants.ScreenPadding)
                
                NavigationLink(destination: ChangePasswordView()) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Đổi mật khẩu")
                                .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            Spacer()
                                
                            Image(Asset.Global.icDefaultNext.name)
                                .resizable()
                                .frame(width: 8, height: 12)
                        }
                        .padding(.horizontal, K.Constants.ScreenPadding)
                    }
                    .frame(height: 45)
                    .background(Color(Asset.Colors.Global.white100.color))
                }
            }
        }
    }
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @ObservedObject var viewModel: SettingsViewModel
        
        var body: some View {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(Asset.Global.icDefaultBack.name)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 9)
                            .padding(.trailing, 12)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                }
                Text("Thiết lập")
                    .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.black100.color)
            }
            .frame(height: 44)
            .background(
                Color(Asset.Colors.Global.white100.color)// any non-transparent background
                    .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                    .mask(Rectangle().padding(.bottom, -20)) // shadow only bottom side
            )
            .onReceive(.DidUpdateProfileSuccess) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
