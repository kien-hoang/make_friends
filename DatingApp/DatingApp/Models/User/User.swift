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
    var gender: UserGender?
    var images: [String] = []
    var interestedTags: [InterestedTag] = []
    var aboutMe: String?
    var dateMode: String?
    var snoozeMode: String?
    var isIncognitoMode: String?
    var isValid: Bool = false
    var isVerified: Bool = false
    var inActive: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    
    init() {}
    
    init(dict: [String: Any]) {
        id = dict[K.API.ParameterKeys._Id] as? String ?? ""
        name = dict[K.API.ParameterKeys.Name] as? String ?? ""
        phone = dict[K.API.ParameterKeys.Phone] as? String ?? ""
        email = dict[K.API.ParameterKeys.Email] as? String ?? ""
        if let dateOfBirth = dict[K.API.ParameterKeys.DateOfBirth] as? String {
            let date = Date.dateFullFormat(from: dateOfBirth)
            self.dateOfBirth = date
        }
        if let gender = dict["gender"] as? String {
            self.gender = UserGender(rawValue: gender) ?? .others
        }
        if let imageUrls = dict["images"] as? [String] {
            images = imageUrls
        }
        if let interestedTagsData = dict["interested_tags"] as? [[String: Any]] {
            var interestedTags: [InterestedTag] = []
            for interestedTag in interestedTagsData {
                interestedTags.append(InterestedTag(dict: interestedTag))
            }
            self.interestedTags = interestedTags
        }
        aboutMe = dict["about_me"] as? String ?? ""
//        var dateMode: String?
//        var snoozeMode: String?
//        var isIncognitoMode: String?
//        isValid = dict["is_valid_user"] as? Bool ?? false
        isVerified = dict["is_verified"] as? Bool ?? false
        inActive = dict["is_active"] as? Bool ?? false
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

enum UserGender: String {
    case male = "MALE"
    case female = "FEMALE"
    case others = "OTHERS"
}
