//
//  EditInterestedTagsViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 15/01/2022.
//

import SwiftUI

class EditInterestedTagsViewModel: ObservableObject {
    @Published var interestedTags: [InterestedTag] = []
    @Published var selectedInterestedTags: [InterestedTag] = []
    
    init(selectedInterestedTags: [InterestedTag]) {
        getAllInterestedTags { [weak self] in
            guard let self = self else { return }
            self.selectedInterestedTags = selectedInterestedTags
        }
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
extension EditInterestedTagsViewModel {
    func updateInterestedTags() {
        if selectedInterestedTags.count < 5 {
            Helper.showProgressError("Vui lòng chọn ít nhất 5 sở thích của bạn")
            return
        }
        NotificationCenter.default.post(name: .DidUpdateInterestedTagsSuccess, object: selectedInterestedTags)
    }
    
    private func getAllInterestedTags(completion: @escaping () -> Void) {
        InterestedTagAPIManager.shared.getAllInterestedTags { interestedTags, error in
            if let interestedTags = interestedTags {
                self.interestedTags = interestedTags
                completion()
            } else if let error = error {
                Helper.showToast(error.localizedDescription)
            }
        }
    }
}
