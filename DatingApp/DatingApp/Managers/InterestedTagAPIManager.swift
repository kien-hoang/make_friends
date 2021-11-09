//
//  InterestedTagAPIManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 08/11/2021.
//

import UIKit
import Alamofire

class InterestedTagAPIManager {
    static let shared = InterestedTagAPIManager()
    
    func getAllInterestedTags(completion: @escaping (_ interestedTags: [InterestedTag]?, _ error: Error?) -> Void) {
        let path = K.API.URL.InterestedTag
        let urlString = K.API.URL.BaseUrl + path
        let url = URL(string: urlString)!
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            
            case .success(let result as [String:Any]):
                
                let success = result["success"] as? Bool ?? false
                
                if success {
                    if let arrayDict = result["data"] as? [[String: Any]] {
                        var interestedTags: [InterestedTag] = []
                        for dict in arrayDict {
                            interestedTags.append(InterestedTag(dict: dict))
                        }
                        
                        DispatchQueue.main.async {
                            completion(interestedTags, nil)
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
