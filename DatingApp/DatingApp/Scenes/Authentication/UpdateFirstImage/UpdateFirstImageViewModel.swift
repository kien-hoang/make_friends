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
    @Published var selectedImage: UIImage?

}

// MARK: - Helper
extension UpdateFirstImageViewModel {
    func addingImage() {
        isShowPhotoLibrary = true
    }
}
