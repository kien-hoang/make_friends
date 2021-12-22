//
//  AppData.swift
//  DatingApp
//
//  Created by Radley Hoang on 28/11/2021.
//

import UIKit

class AppData {
    static let shared = AppData()
    
    var user: User!
    var isUpdatedLocation = false
    var deviceToken: String = ""
}
