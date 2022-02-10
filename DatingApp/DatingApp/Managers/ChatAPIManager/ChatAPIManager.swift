//
//  ChatAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 02/01/2022.
//

import UIKit

class ChatAPIManager {
    static let shared = ChatAPIManager()
    
    func unmatchUser(withMatchId matchId: String, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        let path = K.API.URL.Chat
        let urlString = K.API.URL.BaseUrl + path + "/unmatch"
        let url = URL(string: urlString)!
        
        var params: [String: Any] = [:]
        params["match_id"] = matchId
        
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
    
    func getListChat(completion: @escaping ((_ listChat: [Match]?, _ error: Error?) -> Void)) {
        let path = K.API.URL.Chat
        
        let urlString = K.API.URL.BaseUrl + path
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [[String: Any]] {
                        var listChat: [Match] = []
                        for chatDict in dict {
                            listChat.append(Match(dict: chatDict))
                        }
                        DispatchQueue.main.async {
                            completion(listChat, nil)
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
    
    func getHistoryChat(withMatchId matchId: String, lastMessageId: String? = nil, completion: @escaping ((_ messages: [Message]?, _ error: Error?) -> Void)) {
        let path = K.API.URL.Chat
        var urlString = K.API.URL.BaseUrl + path + "/history?match_id=\(matchId)"
        if let lastMessageId = lastMessageId {
            urlString += "&last_message_id=\(lastMessageId)"
        }
        let url = URL(string: urlString)!
        
        Network.shared.request(url, method: .get, params: nil, headers: Helper.defaultHeaders) { responseJson in
            switch responseJson.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let dict = result["data"] as? [[String: Any]] {
                        var messages: [Message] = []
                        for messageDict in dict {
                            messages.append(Message(dict: messageDict))
                        }
                        DispatchQueue.main.async {
                            completion(messages, nil)
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
