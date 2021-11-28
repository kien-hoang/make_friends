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
                .padding(.top, 20)
        }
        .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 10, trailing: K.Constants.ScreenPadding))
        .sheet(isPresented: $viewModel.isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage)
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
    
    // MARK: - UpdateImageView
    struct UpdateImageView: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        let screenWidth = UIScreen.main.bounds.width - 2 * K.Constants.ScreenPadding
        var body: some View {
            Group {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        
                } else {
                    AddingImageView(viewModel: viewModel)
                }
            }
            .frame(width: screenWidth, height: screenWidth * 387 / 299)
            .cornerRadius(20)
            .clipped()
            .shadow(color: Color(Asset.Colors.Global.black100.name).opacity(0.2), radius: 4, x: 0, y: 0)
            .onTapGesture {
                viewModel.isShowUploadOptionActionSheet = true
            }
        }
    }
    
    struct AddingImageView: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(Asset.Colors.Global.white100.color))
                    .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(Asset.Colors.Global.gray9A9A9A.color), lineWidth: 1)
                        )
                Image(Asset.Authentication.InitUser.initUserAdd.name)
            }
        }
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: UpdateFirstImageViewModel
        
        var body: some View {
            PushingButtonWhenTrue($viewModel.isUpdateFirstImageSuccess, destinationView: ChooseInterestedTagsView()) {
                viewModel.updateFirstImage()
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
    }
}
