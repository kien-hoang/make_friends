//
//  MessageMainCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI

class MessageMainCellViewModel: ObservableObject {
    @Published var match: Match
    @Published var isRead = true
    @Published var lastMessageString = "Hãy bắt đầu cuộc trò chuyện"
    
    init(match: Match) {
        self.match = match
//        isRead = match.isRead
        if let lastMessage = match.lastMessage {
            updateLastMessageString(lastMessage)
            
//            if !match.isRead, lastMessage.receiverId == AppData.shared.user.id {
//                SocketClientManager.shared.readMessage(withMatchId: match.id)
//            }
        }
    }
    
    private func updateLastMessageString(_ message: Message) {
        switch message.type {
        case .text(let text):
            lastMessageString = text
            
        case .stillImage(_):
            if message.userId == AppData.shared.user.id {
                lastMessageString = "Bạn vừa gửi ảnh cho đối phương"
            } else {
                lastMessageString = "Bạn vừa nhận được ảnh từ đối phương"
            }
        }
    }
}

// MARK: - Helper
extension MessageMainCellViewModel {
//    func didReadMessageSuccess(_ match: Match) {
//        guard match.lastMessage?.receiverId == AppData.shared.user.id else { return }
//        self.match.isRead = true
//        isRead = true
//    }
    
    func updateLastMessage(_ message: Message) {
        guard message.matchId == match.id else { return }
        updateLastMessageString(message)
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
