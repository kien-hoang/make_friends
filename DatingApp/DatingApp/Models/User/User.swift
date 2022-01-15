//
//  User.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import UIKit
import CoreLocation

class User: Identifiable {
    var id: String = ""
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var dateOfBirth: Date?
    var gender: UserGender?
    var images: [String] = []
    var interestedTags: [InterestedTag] = []
    var aboutMe: String = ""
    var dateMode: InterestedInGender?
    var company: String = ""
    var school: String = ""
    var jobTitle: String = ""
    var snoozeMode: String?
    var isIncognitoMode: String?
    var isValid: Bool = false
    var isVerified: Bool = false
    var inActive: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    var location: CLLocation?
    
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
        if let dateMode = dict["date_mode"] as? String {
            self.dateMode = InterestedInGender(rawValue: dateMode) ?? .both
        }
        company = dict["company"] as? String ?? ""
        school = dict["school"] as? String ?? ""
        jobTitle = dict["job_title"] as? String ?? ""
        //        var snoozeMode: String?
        //        var isIncognitoMode: String?
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
        if let locationDict = dict["location"] as? [String: Any],
           let coordinates = locationDict["coordinates"] as? [Double] {
            location = CLLocation(latitude: coordinates[1], longitude: coordinates[0])
        }
        isValid = dict["is_valid"] as? Bool ?? false
    }
}

enum UserGender: String {
    case male = "MALE"
    case female = "FEMALE"
    case others = "OTHERS"
}

enum InterestedInGender: String {
    case male = "MALE"
    case female = "FEMALE"
    case both = "BOTH"
}
