//
//  MessageMainCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI
import Combine

class MessageMainCellViewModel: ObservableObject {
    @Published var match: Match
    @Published var isRead = true
    @Published var lastMessageString = "Hãy bắt đầu cuộc trò chuyện"
    
    var cancellables = Set<AnyCancellable>()
    
    init(match: Match) {
        self.match = match
        if let lastMessage = match.lastMessage {
            updateLastMessageString(lastMessage)
        }
        
        $match
            .sink { [weak self] newMatch in
                guard let self = self else { return }
                if !newMatch.isRead && newMatch.lastMessage?.receiverId == AppData.shared.user.id {
                    self.isRead = false
                } else {
                    self.isRead = true
                }
            }
            .store(in: &cancellables)
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
        case .video(_):
            if message.userId == AppData.shared.user.id {
                lastMessageString = "Bạn vừa gửi video cho đối phương"
            } else {
                lastMessageString = "Bạn vừa nhận được video từ đối phương"
            }
        }
    }
}

// MARK: - Helper
extension MessageMainCellViewModel {
    
    func updateLastMessage(_ match: Match) {
        guard self.match.id == match.id else { return }
        self.match.isRead = match.isRead
        self.match.lastMessage = match.lastMessage
        self.match.members = match.members
        if let lastMessage = match.lastMessage {
            updateLastMessageString(lastMessage)
        }
    }
    
    func didReadMessageSuccess(_ match: Match) {
        guard self.match.id == match.id,
              match.lastMessage?.receiverId == AppData.shared.user.id else { return }
        self.match.isRead = match.isRead
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
