//
//  EditProfilePhotoCellView.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/01/2022.
//

import SwiftUI
import Kingfisher

struct EditProfilePhotoCellView: View {
    @StateObject var cellViewModel: EditProfilePhotoCellViewModel
    
    var body: some View {
        Group {
            switch cellViewModel.type {
            case .EmptyCell:
                EmptyPhotoView()
                    .actionSheet(isPresented: $cellViewModel.isShowUploadOptionActionSheet) {
                        uploadOptionActionSheet
                    }
                
            case .AlreadyImage(let imageUrl):
                PhotoView(imageUrl: imageUrl)
                    .actionSheet(isPresented: $cellViewModel.isShowEditOptionActionSheet) {
                        editOptionActionSheet
                    }
            }
        }
        .onTapGesture {
            cellViewModel.didTapCell()
        }
        .fullScreenCover(isPresented: $cellViewModel.isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $cellViewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $cellViewModel.isShowCamera) {
            ImagePicker(sourceType: .stillImage, selectedImage: $cellViewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                .ignoresSafeArea()
        }
    }
    
    // MARK: - UploadOption
    var uploadOptionActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Tải ảnh lên"),
            buttons: [
                .default(Text("Máy ảnh")) {
                    cellViewModel.isShowCamera = true
                },
                .default(Text("Bộ sưu tập")) {
                    cellViewModel.isShowPhotoLibrary = true
                },
                .cancel(Text("Huỷ bỏ"))
            ]
        )
    }
    
    // MARK: - EditOption
    var editOptionActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Xoá"),
            buttons: [
                .default(Text("Xoá ảnh")) {
                    cellViewModel.deleteImage()
                },
                .cancel(Text("Huỷ bỏ"))
            ]
        )
    }
    
    // MARK: - PhotoView
    struct PhotoView: View {
        var itemWidth = (__SCREEN_WIDTH__ - K.Constants.EditProfile.TotalOffset) / K.Constants.EditProfile.ImageColumns
        var imageUrl: URL
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                KFImage(imageUrl)
                    .placeholder {
                        Image(Asset.Global.icPlaceholderLogo.name)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(
                                Rectangle()
                                    .fill(Color(Asset.Colors.Global.grayF1F1F1.color))
                                    .frame(width: itemWidth, height: itemWidth * 1.5)
                                    .cornerRadius(12)
                            )
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: itemWidth, height: itemWidth * 1.5)
                    .cornerRadius(12)
                    .clipped()
                
                Image(Asset.Profile.icEditProfile.name)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .fill(.white)
                            .frame(width: 28, height: 28)
                            .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.2), radius: 4, x: 0, y: 0)
                    )
                    .offset(x: 5, y: 5)
            }
        }
    }
    
    // MARK: - EmptyPhotoView
    struct EmptyPhotoView: View {
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF1F1F1.color))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [10]))
                            .fill(Color(Asset.Colors.Global.gray9A9A9A.color).opacity(0.5))
                    )
                
                Image(Asset.Profile.profileAdd.name)
                    .resizable()
                    .frame(width: 27, height: 27)
                    .background(
                        Circle()
                            .fill(.white)
                            .frame(width: 28, height: 28)
                            .shadow(color: Color(Asset.Colors.Global.redD41717.color), radius: 4, x: 0, y: 0)
                    )
                    .offset(x: 5, y: 5)
            }
        }
    }
}

struct EditProfilePhotoCellView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfilePhotoCellView(cellViewModel: EditProfilePhotoCellViewModel(URL(string: "http://res.cloudinary.com/radley/image/upload/v1642310165/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-164231016105.jpg")))
            .frame(width: __SCREEN_WIDTH__ / 3, height: __SCREEN_WIDTH__ / 3 * 1.5)
    }
}
