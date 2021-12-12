//
//  MatchHomeCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 12/12/2021.
//

import SwiftUI
import CoreLocation
import Kingfisher

class MatchHomeCellViewModel: ObservableObject {
    @Published var user: User
    @Published var location: CLLocation = CLLocation(latitude: 16.527688, longitude: 107.481690)
    @Published var currentImageIndex: Int = 0
    
    init(user: User) {
        self.user = user
        
        // test preloading => not effect clearly so comment this
//        for imageString in user.images {
//            if let imageUrl = URL(string: imageString) {
//                KingfisherManager.shared.retrieveImage(with: imageUrl) { _ in
//
//                }
//            }
//        }
    }
}

// MARK: - Helper
extension MatchHomeCellViewModel {
    func getInformation() -> String {
        if let dateOfBirth = user.dateOfBirth {
            let currentData = Date()
            let diffComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: currentData)
            if let age = diffComponents.year {
                return user.name + ", \(age)"
            }
        }
        
        return user.name
    }
    
    func getLocationDistance() -> String {
        if let location = user.location {
            let distanceInMeters = location.distance(from: location)
            
            return "\(distanceInMeters.description) km"
        }
        
        return ""
    }
    
    func showNextImage() {
        if currentImageIndex + 1 < user.images.count {
            currentImageIndex += 1
        }
    }
    
    func showPreviousImage() {
        if currentImageIndex - 1 >= 0 {
            currentImageIndex -= 1
        }
    }
    
    func numberPageControl() -> Int {
        return user.images.count
    }
    
    func isShowPageControl() -> Bool {
        return user.images.count > 1
    }
}
