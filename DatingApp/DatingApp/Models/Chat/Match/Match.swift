//
//  Match.swift
//  DatingApp
//
//  Created by Radley Hoang on 02/01/2022.
//

import UIKit

struct Match {
    var id: String = ""
    var user: User = User()
    var likedUser: User = User()
    var lastMessage: Message?
    
    init() {}
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        if let userDict = dict["user"] as? [String: Any] {
            user = User(dict: userDict)
        }
        if let likedUserDict = dict["liked_user"] as? [String: Any] {
            likedUser = User(dict: likedUserDict)
        }
        if let lastMessageDict = dict["last_message"] as? [String: Any] {
            lastMessage = Message(dict: lastMessageDict)
        }
    }
}
