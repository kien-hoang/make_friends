//
//  SocketClientManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 06/01/2022.
//

import UIKit
import SocketIO

class SocketClientManager {
    static let shared = SocketClientManager()
    
    let manager = SocketManager(socketURL: NSURL(string: K.API.URL.SocketUrl)! as URL, config: [
//        .log(true),
        .compress,
        .path("/socket.io"),
        .forceNew(true),
        .reconnects(true),
        .reconnectWait(1)
    ])
    var socket: SocketIOClient!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        socket = manager.defaultSocket
    }
    
    func connected() {
        print("DEBUG: socket try to connecting.....")
        
        socket.on(clientEvent: .connect) { data, ack in
            print("DEBUG: socket connected")
            NotificationCenter.default.post(name: .DidSocketConnectSuccess, object: nil)
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("DEBUG: socket error")
        }
        
        socket.on("received_message") { data, ack in
            guard let dataDict = data.first as? [String: Any],
                  let isSuccess = dataDict["success"] as? Bool,
                  isSuccess == true,
                  let messageData = dataDict["data"] as? [String: Any] else { return }
            let message = Message(dict: messageData)
            NotificationCenter.default.post(name: .DidReceivedMessage, object: message)
        }
        
        socket.on("read_message_success") { data, ack in
            guard let dataDict = data.first as? [String: Any],
                  let isSuccess = dataDict["success"] as? Bool,
                  isSuccess == true,
                  let matchData = dataDict["data"] as? [String: Any] else { return }
            let match = Match(dict: matchData)
            NotificationCenter.default.post(name: .DidReadMessageSuccess, object: match)
        }
        
        socket.on("update_last_message") { data, ack in
            guard let dataDict = data.first as? [String: Any],
                  let isSuccess = dataDict["success"] as? Bool,
                  isSuccess == true,
                  let matchData = dataDict["data"] as? [String: Any] else { return }
            let match = Match(dict: matchData)
            NotificationCenter.default.post(name: .UpdateLastMessage, object: match)
        }
        
        socket.on("typing_success") { data, ack in
            guard let dataDict = data.first as? [String: Any],
                  let isSuccess = dataDict["success"] as? Bool,
                  isSuccess == true,
                  let matchData = dataDict["data"] as? [String: Any] else { return }
            print("DEBUG: typing_success \(matchData)")
            NotificationCenter.default.post(name: .NotifyTypingMessage, object: matchData)
        }
        
        socket.on("stop_typing_success") { data, ack in
            guard let dataDict = data.first as? [String: Any],
                  let isSuccess = dataDict["success"] as? Bool,
                  isSuccess == true,
                  let matchData = dataDict["data"] as? [String: Any] else { return }
            print("DEBUG: stop_typing_success \(matchData)")
            NotificationCenter.default.post(name: .NotifyStopTypingMessage, object: matchData)
        }
        
        socket.connect()
    }
    
    func disconnected() {
        socket.disconnect()
    }
    
    func userLogout() {
        disconnected()
        NotificationCenter.default.removeObserver(self)
    }
    
    func joinRoom(withMatchIds matchIds: [String]) {
        func emitMatchIds() {
            var dict: [String: Any] = [:]
            dict["match_id"] = matchIds
            socket.emit("join_room", with: [dict]) {
                print("DEBUG: join room success")
            }
        }
        
        if socket.status == .connected {
            emitMatchIds()
        } else {
            socket.on(clientEvent: .connect) { data, ack in
                emitMatchIds()
            }
        }
    }
    
    /*
     user_id: String
     user_id_of_liked_user: String
     match_id: String
     type: ENUM ["TEXT", "IMAGE"]
     */
    func sendMessage(_ message: Message, completion: @escaping () -> Void) {
        var dict: [String: Any] = [:]
        dict["user_id"] = message.userId
        dict["user_id_of_liked_user"] = message.receiverId
        dict["match_id"] = message.matchId
        switch message.type {
        case .text(let text):
            dict["type"] = message.type.getRawValue()
            dict["message"] = text
            
        case .stillImage(let imageUrl):
            dict["type"] = message.type.getRawValue()
            dict["image_url"] = imageUrl.absoluteString
            
        case .video(let videoUrl):
            dict["type"] = message.type.getRawValue()
            dict["video_url"] = videoUrl.absoluteString
        }
        
        socket.emit("send_message", with: [dict]) {
            completion()
        }
    }
    
    func readMessage(withMatchId matchId: String) {
        var dict: [String: Any] = [:]
        dict["match_id"] = matchId
        
        socket.emit("read_message", with: [dict])
    }
    
    func typingMessage(withMatchId matchId: String) {
        var dict: [String: Any] = [:]
        dict["match_id"] = matchId
        dict["user_id"] = AppData.shared.user.id

        socket.emit("typing_message", with: [dict])
    }
    
    func stopTypingMessage(withMatchId matchId: String) {
        var dict: [String: Any] = [:]
        dict["match_id"] = matchId
        dict["user_id"] = AppData.shared.user.id

        socket.emit("stop_typing_message", with: [dict])
    }
}
