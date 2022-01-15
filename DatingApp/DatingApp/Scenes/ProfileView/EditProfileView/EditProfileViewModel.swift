//
//  EditProfileViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/01/2022.
//

import SwiftUI
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var user: User = AppData.shared.user
    @Published var isShowInterestedInGenderActionSheet = false
    @Published var isShowGenderActionSheet = false
    @Published var interestedTagsString: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $user
            .sink { newValue in
                self.getInterestedTagsString()
            }
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
