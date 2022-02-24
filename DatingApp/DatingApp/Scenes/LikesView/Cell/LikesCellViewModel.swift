//
//  LikesCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 24/02/2022.
//

import SwiftUI

class LikesCellViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func likeOrDislike(direction: LeftRight) {
        var params: [String: Any] = [:]
        params["user_id_of_liked_user"] = user.id
        params["status"] = direction == .left ? "PASS" : "LIKE"
        RecsAPIManager.shared.swipingUser(params: params) { [weak self] isSuccess, error in
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                NotificationCenter.default.post(name: .DidLikeOrDislikeSuccess, object: self.user.id)
                AppData.shared.needRefreshCardStack = true
            }
        }
    }
}
