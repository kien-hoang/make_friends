//
//  EditProfilePhotoCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 15/01/2022.
//

import SwiftUI
import Combine

enum EditProfilePhotoCellType {
    case EmptyCell
    case AlreadyImage(_ imageUrl: URL)
}

class EditProfilePhotoCellViewModel: ObservableObject {
    @Published var type: EditProfilePhotoCellType = .EmptyCell
    
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var newImage: UIImage?
    @Published var isShowUploadOptionActionSheet = false
    @Published var isShowEditOptionActionSheet = false
    
    private var selectedImageUrl: String? = nil
    
    var cancellable = Set<AnyCancellable>()
    
    init(_ imageUrl: URL?) {
        if let imageUrl = imageUrl {
            type = .AlreadyImage(imageUrl)
        } else {
            type = .EmptyCell
        }
        
        $newImage
            .sink { [weak self] image in
                guard let _ = self,
                      let image = image else { return }
                NotificationCenter.default.post(name: .DidChooseImageForUpdatingSuccess, object: image)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Helper
    func didTapCell() {
        switch type {
        case .EmptyCell:
            isShowUploadOptionActionSheet = true
            
        case .AlreadyImage(let url):
            selectedImageUrl = url.absoluteString
            isShowEditOptionActionSheet = true
        }
    }
    
    func deleteImage() {
        guard let selectedImageUrl = selectedImageUrl else {
            return
        }

        NotificationCenter.default.post(name: .DidChooseImageForDeletingSuccess, object: selectedImageUrl)
    }
}
