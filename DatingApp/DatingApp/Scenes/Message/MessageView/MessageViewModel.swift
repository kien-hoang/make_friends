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
    
    var cancellable: AnyCancellable? = nil
    
    private var match: Match
    
    init(match: Match) {
        self.match = match
        setupPublishers()
        messages = mockMessages()
    }
    
    func sendMessage(_ message: Message) {
        // Networking
        messages.append(message)
        // if networking failure, then show an error with some retry options
    }
    
    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map({ _ in true })
    
    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map({ _ in true })
    
    private func setupPublishers() {
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.keyboardIsShowing, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func mockMessage(_ content: String) -> Message {
        var message = Message()
        message.messageContent = content
        return message
    }
    
    func mockMessages() -> [Message] {
        var message1 = Message()
        message1.messageContent = "Siêu phẩm quần jean nam lưng thun theo phong cách Hàn Quốc đang làm mưa làm gió nay về rồi ạ."
        
        var message2 = Message()
        message2.messageContent = "Lên form cực chuẩn luôn nè 🥰🥰🥰. Đủ size cho anh em luôn nha."
        
        return [message1, message2, message1, message2, message1, message2]
    }
}
