//
//  MessageViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import UIKit
import Combine

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var keyboardIsShowing: Bool = false
    @Published var match: Match
    @Published var groupedMessages: [(String, [Message])] = []
    
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var newImage: UIImage?
    @Published var isShowUploadOptionActionSheet = false
    
    private var isFirstLoadVC = true
    private var isEmptyData = false // TODO: Avoid get more data if not record is got anymore
    var isLoadingMoreData = false // TODO: Avoid scroll to bottom when loading data
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    init(match: Match) {
        self.match = match
        getHistoryChat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        $newImage
            .sink { [weak self] image in
                guard let self = self,
                      let image = image else { return }
                self.updateNewImage(image)
            }
            .store(in: &cancellables)
        
        if let lastMessage = match.lastMessage,
            !match.isRead, lastMessage.receiverId == AppData.shared.user.id {
            SocketClientManager.shared.readMessage(withMatchId: match.id)
        }
    }
    
    @objc func keyboardShow() {
        keyboardIsShowing = true
    }
    
    @objc func keyboardHide() {
        keyboardIsShowing = false
    }
    
    func sendMessage(_ type: MessageType) {
        // Networking
        var message = Message()
        message.userId = AppData.shared.user.id
        if let receiver = match.members.first(where: { $0.id != AppData.shared.user.id }) {
            message.receiverId = receiver.id
        }
        message.matchId = match.id
        message.type = type
        message.id = UUID().uuidString
        
        SocketClientManager.shared.sendMessage(message) { [weak self] in
            guard let self = self else { return }
            self.messages.append(message)
            self.groupMessagesBaseDate()
//            NotificationCenter.default.post(name: .UpdateLastMessage, object: message)
        }
        // if networking failure, then show an error with some retry options
    }
    
    func receiveMessage(_ message: Message) {
        guard message.matchId == match.id else { return }
        messages.append(message)
        groupMessagesBaseDate()
    }
}

// MARK: - API
extension MessageViewModel {
    func updateNewImage(_ image: UIImage) {
        Helper.showProgress(interaction: true)
        UserAPIManager.shared.uploadImageFile(withImage: image) { [weak self] imageUrl in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let imageUrl = imageUrl {
                self.sendMessage(.stillImage(URL(string: imageUrl)!))
            }
        }
    }
    
    private func getHistoryChat(lastMessageId: String? = nil) {
        Helper.showProgress()
        ChatAPIManager.shared.getHistoryChat(withMatchId: match.id, lastMessageId: lastMessageId) { [weak self] messages, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let messages = messages {
                if messages.isEmpty {
                    self.isEmptyData = true
                    return
                }
                if let _ = lastMessageId {
                    let reversedMessages: [Message] = messages.reversed()
                    self.isLoadingMoreData = true
                    self.messages.insert(contentsOf: reversedMessages, at: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.isLoadingMoreData = false
                    }
                    
                } else {
                    // TODO: First load message
                    self.messages = messages.reversed()
                }
                self.groupMessagesBaseDate()
            }
        }
    }
}

// MARK: - Helper
extension MessageViewModel {
    func loadMoreIfNeeded() {
        guard !isFirstLoadVC, !isEmptyData else {
            isFirstLoadVC = false
            return
        }
        
        getHistoryChat(lastMessageId: messages.first?.id)
    }
    
    func getIndexMessage(_ message: Message) -> Int {
        return messages.firstIndex(where: { $0 == message }) ?? 999
    }
    
    func getDateTime(_ dateTime: String) -> String {
        if dateTime == Date().ddMMyyyy {
            return "Hôm nay"
        } else if dateTime == Date().dayBefore.ddMMyyyy {
            return "Hôm qua"
        }
        return dateTime
    }
    
    func groupMessagesBaseDate() {
        let groupedMessage = Dictionary(grouping: messages) { message -> String in
            return (message.createdAt ?? Date()).ddMMyyyy
        }
        
        groupedMessages = []
        let sortedKeys = groupedMessage.keys.sorted()
        sortedKeys.forEach { date in
            let messages = groupedMessage[date] ?? []
            groupedMessages.append((date, messages))
        }
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
}
