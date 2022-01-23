//
//  Message.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import UIKit

enum MessageType: Hashable {
    case text(_ text: String)
    case stillImage(_ imageUrl: URL)
    case video(_ videoUrl: URL)
    
    func getRawValue() -> String {
        switch self {
        case .text(_):
            return "TEXT"
            
        case .stillImage(_):
            return "IMAGE"
            
        case .video(_):
            return "VIDEO"
        }
    }
}

struct Message: Hashable, Equatable {
    var id: String = ""
    var matchId: String = ""
    var userId: String = ""
    var receiverId: String = ""
    var createdAt: Date?
    var type: MessageType = .text("")
    
    init() {}
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        matchId = dict["match_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        receiverId = dict["receiver_id"] as? String ?? ""
        if let typeString = dict["type"] as? String,
           typeString == "TEXT",
           let message = dict["message_content"] as? String {
            type = .text(message)
        } else if let typeString = dict["type"] as? String,
                  typeString == "IMAGE",
                  let imageUrlString = dict["image_url"] as? String,
                  let imageUrl = URL(string: imageUrlString) {
            type = .stillImage(imageUrl)
        } else if let typeString = dict["type"] as? String,
                  typeString == "VIDEO",
                  let videoUrlString = dict["video_url"] as? String,
                  let videoUrl = URL(string: videoUrlString) {
            type = .video(videoUrl)
        }
        if let createdAt = dict[K.API.ParameterKeys.CreatedAt] as? String {
            let date = Date.dateFullFormat(from: createdAt)
            self.createdAt = date
        }
    }
}
