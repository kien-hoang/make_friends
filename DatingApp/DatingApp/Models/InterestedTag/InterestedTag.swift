//
//  InterestedTag.swift
//  DatingApp
//
//  Created by Radley Hoang on 07/11/2021.
//

import Foundation

struct InterestedTag: Hashable {
    var id: String
    var name: String
    
    init(dict: [String: Any]) {
        self.id = dict[K.API.ParameterKey._Id] as? String ?? ""
        self.name = dict[K.API.ParameterKey.Name] as? String ?? ""
    }
}
