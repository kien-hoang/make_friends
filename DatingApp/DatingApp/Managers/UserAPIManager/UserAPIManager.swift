//
//  UserAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 27/11/2021.
//

import UIKit
import Alamofire
import CoreLocation

class UserAPIManager {
    static let shared = UserAPIManager()
    
    func updateInterestedTags(withParams params: [String: Any], completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {       
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path + "/update-interested-tags"
        let url = URL(string: urlString)!
        
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
    
    func updateFirstImage(_ imageUrl: String, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        let params: [String: Any] = ["image": imageUrl]
        
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path + "/update-first-image"
        let url = URL(string: urlString)!
        
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

    func uploadImageFile(withImage image: UIImage, completion: @escaping (_ imageUrl: String?) -> Void) {
        
        let path = K.API.URL.Upload
        let urlString = K.API.URL.BaseUrl + path + "/image"
        let url = URL(string: urlString)!
        
        let timestamp = Date().timeIntervalSince1970
        
        AF.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "file", fileName: "\(timestamp).jpeg", mimeType: "image/jpeg")
                multipartFormData.append("IdentityCard".data(using: String.Encoding.utf8)!, withName: "type")
            }
        }, to: url, method: .post, headers: Helper.defaultHeaders).responseJSON { (response) in
            switch response.result {
            
            case .success(let result as [String:Any]):
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dataDict = result["data"] as? [String:Any] {
                        let url = dataDict["url"] as? String
                        DispatchQueue.main.async {
                            completion(url)
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
                
            default:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func updateGender(_ gender: UserGender, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        let params: [String: Any] = ["gender": gender.rawValue]
        
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path + "/update-gender"
        let url = URL(string: urlString)!
        
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
    
//    func checkValidUser(completion: @escaping (_ isValid: Bool?, _ error: Error?) -> Void) {
//        let path = K.API.URL.User
//        let urlString = K.API.URL.BaseUrl + path + "/is-valid"
//        let url = URL(string: urlString)!
//        
//        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
//            switch responseJson.result {
//            
//            case .success(let result as [String:Any]):
//                
//                let success = result["success"] as? Bool ?? false
//                
//                if success {
//                    if let dict = result["data"] as? [String: Any],
//                       let isValid = dict["is_valid"] as? Bool {
//                        DispatchQueue.main.async {
//                            completion(isValid, nil)
//                        }
//                    }
//                    
//                } else {
//                    let message = result["message"] as? String ?? "Something went wrong"
//                    DispatchQueue.main.async {
//                        completion(nil, message.toError)
//                    }
//                }
//                
//            default:
//                let message = "Something went wrong"
//                DispatchQueue.main.async {
//                    completion(nil, message.toError)
//                }
//            }
//        }
//    }
    
    func getProfileUser(completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
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
    
    func updateLocation(_ location: CLLocation, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        var params: [String: Any] = [:]
        params["latitude"] = location.coordinate.latitude
        params["longitude"] = location.coordinate.longitude
        
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path + "/update-location"
        let url = URL(string: urlString)!
        
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
    
    func updateDeviceToken(completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        guard !AppData.shared.deviceToken.isEmpty else { return }
        var params: [String: Any] = [:]
        params["device_token"] = AppData.shared.deviceToken
        
        let path = K.API.URL.User
        let urlString = K.API.URL.BaseUrl + path + "/update-device-token"
        let url = URL(string: urlString)!
        
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
}
