//
//  RecsAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/12/2021.
//

import UIKit
import Alamofire
import CoreLocation

class RecsAPIManager {
    static let shared = RecsAPIManager()
    
    func getListLikingUsers(completion: @escaping ((_  users: [User]?, _ error: Error?) -> Void)) {
        let path = K.API.URL.Recs
        
        let urlString = K.API.URL.BaseUrl + path + "/list-liking-user"
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [String: Any] {
                        if let usersDict = dict["liking_user"] as? [[String: Any]] {
                            var users: [User] = []
                            for userDict in usersDict {
                                users.append(User(dict: userDict))
                            }
                            DispatchQueue.main.async {
                                completion(users, nil)
                            }
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
    
    func getRecommendUser(location: CLLocation, currentPage: Int, limit: Int = K.Constants.PagingLimit, completion: @escaping ((_  users: [User]?, _ error: Error?) -> Void)) {
        let path = K.API.URL.Recs
        
        let urlString = K.API.URL.BaseUrl + path + "/core?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&page=\(currentPage)&limit=\(limit)"
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [String: Any] {
                        if let usersDict = dict["rec-user"] as? [[String: Any]] {
                            var users: [User] = []
                            for userDict in usersDict {
                                users.append(User(dict: userDict))
                            }
                            DispatchQueue.main.async {
                                completion(users, nil)
                            }
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
    
    func swipingUser(params: [String: Any], completion: @escaping ((_  isSuccess: Bool, _ error: Error?) -> Void)) {
        let path = K.API.URL.Recs
        let urlString = K.API.URL.BaseUrl + path + "/like"
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
