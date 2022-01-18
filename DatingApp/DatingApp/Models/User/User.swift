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
    
    static func mockUser() -> User {
        let user = User()
        user.images = ["http://babystar.vn/wp-content/uploads/2020/05/644cc7bf483cb262eb2d.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642313241/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642313237109.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642315174/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642315170824.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642315190/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642315186212.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642318160/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642318156367.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642318189/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642318186344.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642318198/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642318194473.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642318204/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642318201438.jpg",
                       "http://res.cloudinary.com/radley/image/upload/v1642318302/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642318298432.jpg"]
        user.name = "Radley Hoang"
        user.phone = "0987914956"
        user.email = "htkien.dev@gmail.com"
        user.dateOfBirth = Date()
        user.gender = .male
        user.dateMode = .female
        
        var interestedTags: [InterestedTag] = []
        interestedTags.append(InterestedTag(id: "61895447dd312b73b3c88351", name: "Mua sắm"))
        interestedTags.append(InterestedTag(id: "61a372d37bd3005bac094819", name: "Nghe nhạc"))
        interestedTags.append(InterestedTag(id: "61a373257bd3005bac094823", name: "Quay phim"))
        interestedTags.append(InterestedTag(id: "61a3730f7bd3005bac094821", name: "Chơi game"))
        interestedTags.append(InterestedTag(id: "61a373167bd3005bac094822", name: "Nói chuyện"))
        user.interestedTags = interestedTags
        
        user.location = CLLocation(latitude: CLLocationDegrees(12.568337), longitude: CLLocationDegrees(55.676098))
        user.aboutMe = "I o s develop e r"
        user.jobTitle = "Nghe nghiep 1"
        user.school = "Truong hoc 2"
        user.company = "Cong ty 3"
        user.isVerified = false
        user.isValid = true
        
        return user
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
