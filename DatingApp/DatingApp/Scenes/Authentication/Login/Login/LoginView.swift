//
//  LoginView.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/11/2021.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State var isAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 22) {
                Image(Asset.Global.icLightLogo.name)
                    .resizable()
                    .frame(width: 89, height: 89)
                VStack(alignment: .leading, spacing: 0) {
                    Text("MAKE")
                        .style(font: .lexendBlack, size: 22, color: Asset.Colors.Global.black100.color)
                    Text("FRIENDS")
                        .style(font: .lexendBlack, size: 22, color: Asset.Colors.Global.redD41717.color)
                }
            }
            .alert(isPresented: $isAlert, AlertConfig(title: "Title", action: {
                if let serverIP = $0 {
                    if serverIP.isEmpty {
                        Helper.deleteLocalValue(withKey: "SERVER_IP")
                        viewModel.showDebugLog("DEBUG: Delete SERVER_IP")
                    } else {
                        Helper.saveLocal(value: serverIP, key: "SERVER_IP")
                        viewModel.showDebugLog("DEBUG: Save SERVER_IP = \(serverIP)")
                    }
                } else {
                    viewModel.showDebugLog("DEBUG: Cancel")
                }
            }))
            .onLongPressGesture {
                isAlert = true
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                LoginButton()
                    .padding(.bottom, 16)
                CreateAccountButton()
                    .padding(.bottom, 12)
                
                ForgotPasswordButton()
            }
        }
//        .setBackgroundColor(K.Constants.DefaultColor)
        .setBackgroundColor(.white)
        .navigationView()
    }
    
    // MARK: - ForgotPasswordView
    struct ForgotPasswordButton: View {
        
        var body: some View {
            PushingButton(destinationView: ForgotPasswordPhoneView()) {
                // Do something
            } label: {
                Text("Quên mật khẩu?")
                    .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.redD41717.color)
            }
        }
    }
    
    // MARK: - LoginButton
    struct LoginButton: View {
        let signupSuccessPublisher = NotificationCenter.default
            .publisher(for: NSNotification.Name(K.KeyPaths.DidSignupSuccess))
        @State var isShow: Bool = false
        
        var body: some View {
            PushingButtonWhenTrue($isShow, destinationView: LoginPhoneView()) {
                isShow = true
            } label: {
                Text("Đăng nhập")
                    .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                    .padding(8)
                    .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(Asset.Colors.Global.white100.color))
                            .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
            .onReceive(signupSuccessPublisher) { _ in
                isShow = true
            }
        }
    }
    
    // MARK: - CreateAccountButton
    struct CreateAccountButton: View {
        var body: some View {
            PushingButton(destinationView: SignupPhoneView()) {
                // Do something
            } label: {
                Text("Tạo tài khoản")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: - VM
class LoginViewModel: ObservableObject {
    func showDebugLog(_ text: String) {
        Helper.showProgress(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Helper.dismissProgress()
        }
    }
}

