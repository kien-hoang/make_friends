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
        self.id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        self.name = dict[K.API.ParameterKeys.Name] as? String ?? ""
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
