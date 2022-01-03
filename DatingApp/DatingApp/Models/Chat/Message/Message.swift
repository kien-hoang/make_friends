//
//  Message.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import UIKit

struct Message {
    var id: String = ""
    var matchId: String = ""
    var userId: String = ""
    var receiverId: String = ""
    var messageContent: String = ""
    var createdAt: Date?
    
    init() {}
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        matchId = dict["match_id"] as? String ?? ""
        userId = dict["user_id"] as? String ?? ""
        receiverId = dict["receiver_id"] as? String ?? ""
        messageContent = dict["message_content"] as? String ?? ""
        if let createdAt = dict[K.API.ParameterKeys.CreatedAt] as? String {
            let date = Date.dateFullFormat(from: createdAt)
            self.createdAt = date
        }
    }
}
