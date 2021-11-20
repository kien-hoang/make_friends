//
//  AuthenticationAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 19/11/2021.
//

import UIKit

class AuthenticationAPIManager {
    static let shared = AuthenticationAPIManager()
    
    func signup(params: [String: Any], completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let path = K.API.URL.Register
        let urlString = K.API.URL.BaseUrl + path
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .post, params: params, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [String: Any] {
                        DispatchQueue.main.async {
                            completion(User(dict: dict), nil)
                        }
                    }
                    
                } else {
                    let message = result["message"] as? String ?? "Something went wrong"
                    DispatchQueue.main.async {
                        completion(nil, message.toError)
                    }
                }
                
            default:
                let message = "Something went wrong"
                DispatchQueue.main.async {
                    completion(nil, message.toError)
                }
            }
        }
    }
}
