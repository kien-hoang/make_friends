//
//  ProfileMainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/11/2021.
//

import SwiftUI
import Combine

class ProfileMainViewModel: ObservableObject {
    @Published var avatarUrl = ""
    @Published var name = ""
    @Published var age = 0
    @Published var isVerified: Bool = false
    @Published var user: User = AppData.shared.user
    
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var newImage: UIImage?
    @Published var isShowUploadOptionActionSheet = false
    @Published var isPresentDetailProfileView = false
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        $user
            .sink { [weak self] user in
                guard let self = self else { return }
                self.avatarUrl = user.images.first ?? ""
                self.name = user.name
                
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: user.dateOfBirth!, to: now)
                self.age = ageComponents.year!
                
                self.isVerified = user.isVerified
            }
            .store(in: &cancellable)
        
        $newImage
            .sink { [weak self] image in
                guard let self = self,
                      let image = image else { return }
                self.updateNewImage(image)
            }
            .store(in: &cancellable)
    }
}

// MARK: - Action
extension ProfileMainViewModel {
    func didTapAvatar() {
        guard AppData.shared.user != nil else { return }
        isPresentDetailProfileView = true
    }
    
    func didTapVerified() {
        print("didTapVerified")
    }
    
    func didTapAddMedia() {
        guard user.images.count < 9 else {
            Helper.showProgressError("Đã đạt tối đa ảnh có thể thêm. Vui lòng vào chỉnh sửa ảnh")
            return
        }
        
        isShowUploadOptionActionSheet = true
    }
    
    func didTapEditProfile() {
        print("didTapEditProfile")
    }
}

// MARK: - API
extension ProfileMainViewModel {
    func updateNewImage(_ image: UIImage) {
        Helper.showProgress(interaction: true)
        UserAPIManager.shared.uploadImageFile(withImage: image) { [weak self] imageUrl in
            guard let self = self else { return }
            if let imageUrl = imageUrl {
                
                var imageUrls = self.user.images
                imageUrls.append(imageUrl)
                
                UserAPIManager.shared.updateAllImage(imageUrls) { [weak self] newImageUrls, error in
                    Helper.dismissProgress()
                    guard let self = self else { return }
                    if let error = error {
                        Helper.showProgressError(error.localizedDescription)
                    } else if let newImageUrls = newImageUrls {
                        Helper.showSuccess("Thêm/Thay đổi ảnh thành công")
                        self.newImage = nil
                        self.user.images = newImageUrls
                    }
                }
            }
        }
    }
}

// MARK: - Helper
extension ProfileMainViewModel {
    func getCurrentUser() -> User {
        return AppData.shared.user ?? User()
    }
}
