//
//  ChooseInterestedTagsViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 06/11/2021.
//

import SwiftUI

class ChooseInterestedTagsViewModel: ObservableObject {
    @Published var interestedTags: [InterestedTag] = []
    @Published var selectedInterestedTags: [InterestedTag] = []
    
    init() {
        getAllInterestedTags()
    }
    
    // MARK: - Helper
    func onSelectTag(_ tag: InterestedTag) {
        if let firstIndex = selectedInterestedTags.firstIndex(where: { $0.id == tag.id }) {
            selectedInterestedTags.remove(at: firstIndex)
        } else {
            selectedInterestedTags.append(tag)
        }
    }
    
    func isSelectedTag(_ tag: InterestedTag) -> Bool {
        return selectedInterestedTags.contains(where: { $0.id == tag.id })
    }
}

// MARK: - API
extension ChooseInterestedTagsViewModel {
    func updateInterestedTags() {
        if selectedInterestedTags.count < 5 {
            Helper.showProgressError("Vui lòng chọn ít nhất 5 sở thích của bạn")
            return
        }
        var params: [String: Any] = [:]
        params["interested_tag_ids"] = selectedInterestedTags.map { $0.id }
        
        Helper.showProgress()
        UserAPIManager.shared.updateInterestedTags(withParams: params) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
                return
            } else if isSuccess {
                Helper.showSuccess("Chọn sở thích thành công")
                NotificationCenter.default.post(name: .UpdateMandatoryInformationSuccess, object: nil)
            }
        }
    }
    
    private func getAllInterestedTags() {
        InterestedTagAPIManager.shared.getAllInterestedTags { interestedTags, error in
            if let interestedTags = interestedTags {
                self.interestedTags = interestedTags
            } else if let error = error {
                Helper.showToast(error.localizedDescription)
            }
        }
    }
}
