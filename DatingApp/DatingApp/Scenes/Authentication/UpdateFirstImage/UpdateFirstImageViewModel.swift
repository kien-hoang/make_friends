//
//  UpdateFirstImageViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 26/11/2021.
//

import SwiftUI

class UpdateFirstImageViewModel: ObservableObject {
    @Published var isUpdateFirstImageSuccess = false
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var selectedImage: UIImage?
    @Published var isShowUploadOptionActionSheet = false

}

// MARK: - API
extension UpdateFirstImageViewModel {
    func updateFirstImage() {
        guard let selectedImage = selectedImage else {
            Helper.showProgressError("Vui lòng tải ảnh lên")
            return
        }
        
        Helper.showProgress()
        UserAPIManager.shared.uploadImageFile(withImage: selectedImage) { [weak self] imageUrl in
            guard let _ = self else { return }
            if let imageUrl = imageUrl {
                UserAPIManager.shared.updateFirstImage(imageUrl) { [weak self] isSuccess, error in
                    Helper.dismissProgress()
                    guard let self = self else { return }
                    if let error = error {
                        Helper.showProgressError(error.localizedDescription)
                    } else if isSuccess {
                        Helper.showSuccess("Thêm ảnh đầu tiên thành công")
                        self.isUpdateFirstImageSuccess = true
                    }
                }
            }
        }
    }
}

// MARK: - Helper
extension UpdateFirstImageViewModel {
    func addingImage() {
        isShowPhotoLibrary = true
    }
}
