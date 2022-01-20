//
//  Match.swift
//  DatingApp
//
//  Created by Radley Hoang on 02/01/2022.
//

import UIKit

struct Match {
    var id: String = ""
    var members: [User] = []
    var lastMessage: Message?
    var isRead: Bool = false
    
    init() {}
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        if let membersDict = dict["members"] as? [[String: Any]] {
            var members: [User] = []
            for memberDict in membersDict {
                members.append(User(dict: memberDict))
            }
            self.members = members
        }
        if let lastMessageDict = dict["last_message"] as? [String: Any] {
            lastMessage = Message(dict: lastMessageDict)
        }
        isRead = dict["is_read"] as? Bool ?? false
    }
}
