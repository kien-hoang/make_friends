//
//  MessageMainCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI

class MessageMainCellViewModel: ObservableObject {
    @Published var match: Match
    @Published var isRead = true // fake. Will improve later
    
    init(match: Match) {
        self.match = match
    }
}

// MARK: - Helper
extension MessageMainCellViewModel {
    func getImageUrl() -> URL? {
        guard !match.likedUser.images.isEmpty else { return nil }
        for image in match.likedUser.images {
            if let imageUrl = URL(string: image) {
                return imageUrl
            }
        }
        
        return nil
    }
    
    func getLikedName() -> String {
        return match.likedUser.name
    }
    
    func getTimeString() -> String {
        guard let createdAt = match.lastMessage?.createdAt else { return "" }
        
        return createdAt.HHmmddMMyyyy
    }
    
    func getLastMessage() -> String {
        guard let lastMessage = match.lastMessage,
              !lastMessage.messageContent.isEmpty else {
            return "Hãy bắt đầu cuộc trò chuyện"
        }
        
        return lastMessage.messageContent
    }
}
