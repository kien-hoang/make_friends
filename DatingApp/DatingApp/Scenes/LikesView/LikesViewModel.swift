//
//  LikesViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/02/2022.
//

import SwiftUI

enum LikesViewType {
    case Empty
    case LoadingData
    case HasUserLikeMe
}

class LikesViewModel: ObservableObject {
    @Published var viewType: LikesViewType = .Empty
    @Published var likingUsers: [User] = []
    @Published var isPresentDetailProfileView = false
    @Published var selectedUser = User()
    
    init() {
//        for _ in 0..<10 {
//            let user = User()
//            user.images = ["https://genk.mediacdn.vn/2020/1/7/photo-1-15783682257621036671779.jpg"]
//            likingUsers.append(user)
//        }
        
        getListLikingUsers()
    }
}

// MARK: - API
extension LikesViewModel {
    private func getListLikingUsers() {
        viewType = .LoadingData
        likingUsers.removeAll()
        
        Helper.showProgress()
        RecsAPIManager.shared.getListLikingUsers { [weak self] users, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                self.likingUsers = users
                self.showEmptyIfNeeded()
            }
        }
    }
    
    private func showEmptyIfNeeded() {
        viewType = likingUsers.isEmpty ? .Empty : .HasUserLikeMe
    }
    
    func showDetailProfile(ofUser user: User) {
        selectedUser = user
        isPresentDetailProfileView = true
    }
    
    func reloadData() {
        getListLikingUsers()
    }
    
    func removeUser(userId: String) {
        guard let firstIndex = likingUsers.firstIndex(where: { $0.id == userId }) else { return }
        likingUsers.remove(at: firstIndex)
        showEmptyIfNeeded()
    }
}
