//
//  MessageMainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 01/01/2022.
//

import SwiftUI

class MessageMainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var showCancelButton: Bool = false
    @Published var matches: [Match] = []
}

// MARK: - Helper
extension MessageMainViewModel {
    func getListChat() {
        Helper.showProgress()
        ChatAPIManager.shared.getListChat { [weak self] listChat, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let matches = listChat {
                self.matches = matches
            }
        }
    }
    
    func searchChat() {
        
    }
}
