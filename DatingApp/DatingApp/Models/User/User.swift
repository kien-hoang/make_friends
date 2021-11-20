//
//  User.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import UIKit

class User {
    var id: String = ""
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var dateOfBirth: Date?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        name = dict[K.API.ParameterKeys.Name] as? String ?? ""
        phone = dict[K.API.ParameterKeys.Phone] as? String ?? ""
        email = dict[K.API.ParameterKeys.Email] as? String ?? ""
        if let dateOfBirth = dict[K.API.ParameterKeys.DateOfBirth] as? String {
            let date = Date.dateFullFormat(from: dateOfBirth)
            self.dateOfBirth = date
        }
        if let createdAt = dict[K.API.ParameterKeys.CreatedAt] as? String {
            let date = Date.dateFullFormat(from: createdAt)
            self.createdAt = date
        }
        if let updatedAt = dict[K.API.ParameterKeys.UpdatedAt] as? String {
            let date = Date.dateFullFormat(from: updatedAt)
            self.updatedAt = date
        }
    }
}
