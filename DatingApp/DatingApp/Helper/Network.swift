//
//  Network.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/11/2021.
//

import Alamofire

class Network {
    
    static let shared = Network()
    
    func request(_ url: URL, method: Alamofire.HTTPMethod, params: [String: Any]? = nil, headers: HTTPHeaders? = nil, completion: @escaping(_ responseJson: AFDataResponse<Any>) -> ()) {
//        if !NetworkReachability.isConnectedToNetwork() {
//            let noConnectionError = AFError.customErrorWithMessage(message: K.App.ErrorMessage.ErrorNoInternetConnection.localized())
//            let result = AFResult<Any>.failure(noConnectionError)
//            let response = AFDataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
//            completion(response)
//            return
//        }
        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//            if let statusCode = response.response?.statusCode, statusCode == 401 {
//                print("Request login url \(url)")
//                SVProgressHUD.dismiss()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.KeyPath.LoginToContinue), object: nil)
//                return
//            }
            completion(response)
        }
    }
    
    func request(request: URLRequest, completion: @escaping(_ responseJson: AFDataResponse<Any>) -> ()) {
       
//        if !NetworkReachability.isConnectedToNetwork() {
//            let noConnectionError = AFError.customErrorWithMessage(message: K.App.ErrorMessage.ErrorNoInternetConnection.localized())
//            let result = AFResult<Any>.failure(noConnectionError)
//            let response = AFDataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
//            completion(response)
//            return
//        }
        AF.request(request).responseJSON { (response) in
//            if let statusCode = response.response?.statusCode, statusCode == 401 {
//                SVProgressHUD.dismiss()
//                print("Request login url \(request)")
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.KeyPath.LoginToContinue), object: nil)
//                return
//            }
            completion(response)
        }
    }
}
