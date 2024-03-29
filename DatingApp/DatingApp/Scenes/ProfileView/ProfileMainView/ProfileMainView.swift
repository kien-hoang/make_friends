//
//  ProfileMainView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI
import Kingfisher

struct ProfileMainView: View {
    
    @StateObject private var viewModel = ProfileMainViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            AvatarView(viewModel: viewModel)
                .padding(.bottom, 54)
                        
            ToolsView(viewModel: viewModel)
            
            Spacer()
            Spacer()
            Spacer()
        }
        .hiddenNavigationBar()
        .setBackgroundColor(K.Constants.DefaultColor)
        .navigationView()
        // TODO: Reload user data
        .onReceive(.GetProfileUserSuccess) { _ in
            viewModel.user = AppData.shared.user
        }
    }
    
    // MARK: - AvatarView
    struct AvatarView: View {
        @ObservedObject var viewModel: ProfileMainViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                KFImage(URL(string: viewModel.avatarUrl))
                    .placeholder {
                        Image(Asset.Global.icPlaceholderLogo.name)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                    .frame(width: 127, height: 127)
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 127, height: 127)
                    .cornerRadius(127/2)
                    .if(!viewModel.avatarUrl.isEmpty, transform: { view in
                        view
                            .shadow(color: Color(Asset.Colors.Global.gray9A9A9A.name), radius: 4, x: 0, y: 0)
                    })
                    // TODO: Show/dismiss Detail Profile View
                    .fullScreenCover(isPresented: $viewModel.isPresentDetailProfileView) {
                        let viewModel = DetailProfileViewModel(user: viewModel.getCurrentUser())
                        DetailProfileView(viewModel: viewModel)
                            .hiddenNavigationBar()
                            .navigationView()
                    }
                    .onReceive(.DismissDetailProfileView) { _ in
                        viewModel.isPresentDetailProfileView = false
                    }
                    .onTapGesture {
                        viewModel.didTapAvatar()
                    }
                    .padding(.bottom, 8)
                
                HStack(spacing: 0) {
                    Text("\(viewModel.name), \(viewModel.age)")
                        .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.black100.color)
                    
                    if viewModel.isVerified {
                        Image(Asset.Profile.icVerified.name)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                viewModel.didTapVerified()
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - ToolsView
    struct ToolsView: View {
        @ObservedObject var viewModel: ProfileMainViewModel
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        VStack(spacing: 15) {
                            Circle()
                                .fill(Color(Asset.Colors.Global.white100.color))
                                .frame(width: 50, height: 50)
                                .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                                .overlay(
                                    Image(Asset.Profile.icSetting.name)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                )
                            
                            Text("Thiết lập")
                                .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: EditProfileView()) {
                        VStack(spacing: 15) {
                            Circle()
                                .fill(Color(Asset.Colors.Global.white100.color))
                                .frame(width: 50, height: 50)
                                .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                                .overlay(
                                    Image(Asset.Profile.icEditProfile.name)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                )
                            
                            Text("Sửa hồ sơ")
                                .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                
                VStack(spacing: 12) {
                    Image(Asset.Profile.profileAdd.name)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .background(
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                                .shadow(color: Color(Asset.Colors.Global.redD41717.color), radius: 4, x: 0, y: 0)
                        )
                    
                    Text("Thêm ảnh")
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                }
                .onTapGesture {
                    viewModel.didTapAddMedia()
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $viewModel.isShowCamera) {
                ImagePicker(sourceType: .stillImage, selectedImage: $viewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                    .ignoresSafeArea()
            }
            .actionSheet(isPresented: $viewModel.isShowUploadOptionActionSheet) {
                uploadOptionActionSheet
            }
        }
        
        // MARK: - UploadOption
        var uploadOptionActionSheet: ActionSheet {
            ActionSheet(
                title: Text("Tải ảnh lên"),
                buttons: [
                    .default(Text("Máy ảnh")) {
                        viewModel.isShowCamera = true
                    },
                    .default(Text("Bộ sưu tập")) {
                        viewModel.isShowPhotoLibrary = true
                    },
                    .cancel(Text("Huỷ bỏ"))
                ]
            )
        }
    }
    
    
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
    }
}
