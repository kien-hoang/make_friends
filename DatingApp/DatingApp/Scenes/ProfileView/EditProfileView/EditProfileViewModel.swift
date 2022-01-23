//
//  EditProfileViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/01/2022.
//

import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var user: User = User()
    @Published var imageUrls: [String] = []
    @Published var interestedTagsString: String = ""

    @Published var isShowInterestedInGenderActionSheet = false
    @Published var isShowGenderActionSheet = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        user = AppData.shared.user ?? User()
        $user
            .sink { newValue in
                self.getInterestedTagsString()
                self.imageUrls = self.user.images
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .DidChooseImageForUpdatingSuccess)
            .sink(receiveValue: { [weak self] notification in
                guard let self = self,
                      let newImage = notification.object as? UIImage else { return }
                self.updateNewImage(newImage)
            })
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .DidChooseImageForDeletingSuccess)
            .sink(receiveValue: { [weak self] notification in
                guard let self = self,
                      let imageUrl = notification.object as? String else { return }
                self.deleteImage(imageUrl)
            })
            .store(in: &cancellables)
    }
}

// MARK: - API
extension EditProfileViewModel {
    func updateProfile() {
        let params = getParams()
        
        Helper.showProgress()
        UserAPIManager.shared.updateProfile(withParams: params) { [weak self] user, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let user = user {
                AppData.shared.user = user // Save to singleton
                NotificationCenter.default.post(name: .DidUpdateProfileSuccess, object: nil)
            }
        }
    }
    
    func updateNewImage(_ image: UIImage) {
        Helper.showSuccess("Đang tải")
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
                        self.user.images = newImageUrls
                        self.imageUrls = self.user.images
                    }
                }
            }
        }
    }
    
    func deleteImage(_ imageUrl: String) {
        Helper.showSuccess("Đang xoá")
        
        var imageUrls = self.user.images
        imageUrls.removeAll(where: { $0 == imageUrl })
        
        UserAPIManager.shared.updateAllImage(imageUrls) { [weak self] newImageUrls, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let newImageUrls = newImageUrls {
                Helper.showSuccess("Xoá ảnh thành công")
                self.user.images = newImageUrls
                self.imageUrls = self.user.images
            }
        }
    }
}

// MARK: - Helper
extension EditProfileViewModel {
    func getEditInterestedTagsView() -> EditInterestedTagsView {
        let viewModel = EditInterestedTagsViewModel(selectedInterestedTags: user.interestedTags)
        return EditInterestedTagsView(viewModel: viewModel)
    }
    
    func getParams() -> [String: Any] {
        var params: [String: Any] = [:]
        if !user.aboutMe.isEmpty {
            params["about_me"] = user.aboutMe
        }
        if let gender = user.gender {
            params["gender"] = gender.rawValue
        }
        if let dateMode = user.dateMode {
            params["date_mode"] = dateMode.rawValue
        }
        if !user.jobTitle.isEmpty {
            params["job_title"] = user.jobTitle
        }
        if !user.company.isEmpty {
            params["company"] = user.company
        }
        if !user.school.isEmpty {
            params["school"] = user.school
        }
        params["interested_tag_ids"] = user.interestedTags.map({ $0.id })
        
        return params
    }
    
    func getInterestedTagsString() {
        interestedTagsString = user.interestedTags.map({ $0.name }).joined(separator: ", ")
    }
    
    func getInterestedInGenderString() -> String {
        switch user.dateMode {
        case .male:
            return "Nam"
        case .female:
            return "Nữ"
        case .both:
            return "Cả hai"
        case .none:
            return ""
        }
    }
    
    func getGenderString() -> String {
        switch user.gender {
        case .male:
            return "Nam"
        case .female:
            return "Nữ"
        case .others:
            return "Khác"
        case .none:
            return ""
        }
    }
}
