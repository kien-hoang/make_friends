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
    @Published var lastMessageString = "Hãy bắt đầu cuộc trò chuyện"
    
    init(match: Match) {
        self.match = match
        if let lastMessage = match.lastMessage,
           !lastMessage.messageContent.isEmpty {
            lastMessageString = lastMessage.messageContent
        }
    }
}

// MARK: - Helper
extension MessageMainCellViewModel {
    func updateLastMessage(_ message: Message) {
        guard message.matchId == match.id else { return }
        lastMessageString = message.messageContent
    }
    
    func getImageUrl() -> URL? {
        guard let likedUser = (match.members.first { $0.id != AppData.shared.user.id }),
              !likedUser.images.isEmpty else { return nil }
        
        for image in likedUser.images {
            if let imageUrl = URL(string: image) {
                return imageUrl
            }
        }
        
        return nil
    }
    
    func getLikedName() -> String {
        guard let likedUser = (match.members.first { $0.id != AppData.shared.user.id }) else { return "" }
        return likedUser.name
    }
    
    func getTimeString() -> String {
        guard let createdAt = match.lastMessage?.createdAt else { return "" }
        
        return createdAt.HHmmddMMyyyy
    }
}
