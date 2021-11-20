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
            static let LiveUrl = "http://192.168.1.2:3000/api/"
            
            static let InterestedTag = "interested-tags"
            static let Register = "auth/register"
            static let Login = "auth/login"
        }
        
        struct ParameterKeys {
            static let _Id = "_id"
            static let Id = "id"
            static let Name = "name"
            static let Email = "email"
            static let Password = "password"
//            static let User = "user"
//            static let AccessToken = "accessToken"
            static let Phone = "phone"
            static let DateOfBirth = "date_of_birth"
            static let CreatedAt = "createdAt"
            static let UpdatedAt = "updatedAt"
        }
    }
    
    struct UserDefaults {
        static let Token = "token"
    }
    
    struct KeyPaths {
        static let DidSignupSuccess = "DidSignupSuccess"
    }
}
