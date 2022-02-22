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
    @Published var isShowUploadImageOptionActionSheet = false
    
    @Published var isShowVideoLibrary = false
    @Published var isShowVideo = false
    @Published var newVideoUrl: URL?
    @Published var isShowUploadVideoOptionActionSheet = false
    
    @Published var isFriendTyping = false
    @Published var isPresentDetailProfileView = false
    
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
        
        $newVideoUrl
            .sink { [weak self] videoUrl in
                guard let self = self,
                      let videoUrl = videoUrl else { return }
                self.updateNewVideo(videoUrl)
            }
            .store(in: &cancellables)
        
        switch match.lastMessage?.type {
        case .text(let text):
            print("DEBUG: lastMessage \(text)")
        default:
            break
        }
        
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
    func updateNewVideo(_ videoUrl: URL) {
        Helper.showProgress(interaction: true)
        UserAPIManager.shared.uploadVideoFile(withVideoUrl: videoUrl) { [weak self] videoUrl in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let videoUrl = videoUrl {
                self.sendMessage(.video(URL(string: videoUrl)!))
            }
        }
    }
    
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
    func showDetailFriendProfile() {
        isPresentDetailProfileView = true
    }
    
    func getFriendUser() -> User {
        return match.members.first(where: { $0.id != AppData.shared.user.id }) ?? User()
    }
    
    func receivedNotifyStopTypingMessage(_ dataDict: [String: Any]) {
        guard let matchId = dataDict["match_id"] as? String,
              let sendedUserId = dataDict["user_id"] as? String,
              matchId == match.id,
              match.members.contains(where: { $0.id == sendedUserId }) else { return }
        isFriendTyping = false
    }
    
    func receivedNotifyTypingMessage(_ dataDict: [String: Any]) {
        guard let matchId = dataDict["match_id"] as? String,
              let sendedUserId = dataDict["user_id"] as? String,
              matchId == match.id,
              match.members.contains(where: { $0.id == sendedUserId }) else { return }
        isFriendTyping = true
    }

    func notifyTypingMessageIfNeeded(_ isKeyboardShowing: Bool) {
        switch isKeyboardShowing {
        case true:
            SocketClientManager.shared.typingMessage(withMatchId: match.id)
            
        case false:
            SocketClientManager.shared.stopTypingMessage(withMatchId: match.id)
        }
    }
    
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
        let groupedMessage = Dictionary(grouping: messages) { message -> Int in
            return Int((message.createdAt ?? Date()).ddMMyyyy.toDate(withDateFormatter: Date.ddMMyyyyFormatter).timeIntervalSince1970)
        }
        
        groupedMessages = []
        let sortedKeys = groupedMessage.keys.sorted()
        sortedKeys.forEach { dateInt in
            let messages = groupedMessage[dateInt] ?? []
            let dateString = Date(timeIntervalSince1970: TimeInterval(dateInt)).ddMMyyyy
            groupedMessages.append((dateString, messages))
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
