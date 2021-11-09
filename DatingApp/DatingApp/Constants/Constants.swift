//
//  Constants.swift
//  BiduSwiftUI
//
//  Created by Radley Hoang on 12/09/2021.
//

import UIKit

struct K {
    enum Fonts: String {
        case lexendBlack = "Lexend-Black"
        case lexendBold = "Lexend-Bold"
        case lexendExtraBold = "Lexend-ExtraBold"
        case lexendExtraLight = "Lexend-ExtraLight"
        case lexendLight = "Lexend-Light"
        case lexendMedium = "Lexend-Medium"
        case lexendRegular = "Lexend-Regular"
        case lexendSemiBold = "Lexend-SemiBold"
        case lexendThin = "Lexend-Thin"
    }
    
    struct Constants {
        static let NavigationHeight: CGFloat = 44
        static let ScreenPadding: CGFloat = 20
    }
    
    struct API {
        struct HeaderKey {
            static let AcceptLanguage = "Accept-Language"
        }
        
        struct URL {
            #if DEVELOPMENT
            static let BaseUrl = StagingUrl
            #else
            static let BaseUrl = LiveUrl
            #endif
            static let StagingUrl = "http://localhost:3000/api/"
            static let LiveUrl = "http://localhost:3000/api/"
            
            static let InterestedTag = "interested-tags"
        }
        
        struct ParameterKey {
            static let _Id = "_id"
            static let Id = "id"
            static let Name = "name"
            static let Email = "email"
            static let Password = "password"
            static let User = "user"
            static let AccessToken = "accessToken"
        }
    }
    
    struct UserDefaults {
        static let Token = "token"
    }
}
