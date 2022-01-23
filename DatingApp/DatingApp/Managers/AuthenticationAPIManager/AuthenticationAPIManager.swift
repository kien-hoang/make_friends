//
//  AuthenticationAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 19/11/2021.
//

import UIKit

class AuthenticationAPIManager {
    static let shared = AuthenticationAPIManager()
    
    func newPassword(phone: String, password: String, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        let path = K.API.URL.Auth
        let urlString = K.API.URL.BaseUrl + path + "/new-password"
        let url = URL(string: urlString)!
        
        var params: [String: Any] = [:]
        params["phone"] = phone
        params["password"] = password
        
        Network.shared.request(url, method: .post, params: params, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                    
                } else {
                    let message = result["message"] as? String ?? "Something went wrong"
                    DispatchQueue.main.async {
                        completion(false, message.toError)
                    }
                }
                
            default:
                let message = "Something went wrong"
                DispatchQueue.main.async {
                    completion(false, message.toError)
                }
            }
        }
    }
    
    func checkOTP(phone: String, otpCode: String, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        let path = K.API.URL.Auth
        let urlString = K.API.URL.BaseUrl + path + "/check-otp?phone=\(phone)&otp_code=\(otpCode)"
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                    
                } else {
                    let message = result["message"] as? String ?? "Something went wrong"
                    DispatchQueue.main.async {
                        completion(false, message.toError)
                    }
                }
                
            default:
                let message = "Something went wrong"
                DispatchQueue.main.async {
                    completion(false, message.toError)
                }
            }
        }
    }
    
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
    
    func loginWith(phone: String, password: String, completion: @escaping (_ success: Bool,_ error: Error?) -> ()) {
        let params: [String: Any] = [K.API.ParameterKeys.Phone: phone,
                                    K.API.ParameterKeys.Password: password]
        
        let path = K.API.URL.Login
        let urlString = K.API.URL.BaseUrl + path
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .post, params: params, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [String: Any],
                       let token = dict["token"] as? String {
                        Helper.saveLocal(value: token, key: K.UserDefaults.Token)
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                    
                } else {
                    let message = result["message"] as? String ?? "Something went wrong"
                    DispatchQueue.main.async {
                        completion(false, message.toError)
                    }
                }
                
            default:
                let message = "Something went wrong"
                DispatchQueue.main.async {
                    completion(false, message.toError)
                }
            }
        }
    }
}
