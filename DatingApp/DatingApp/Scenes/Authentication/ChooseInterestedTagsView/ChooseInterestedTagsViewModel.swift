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
    func nextAction() {
        
    }
    
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
