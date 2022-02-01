//
//  DetailProfileViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 16/01/2022.
//

import SwiftUI

class DetailProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var currentImageIndex: Int = 0
    @Published var isShowReportPopup: Bool = false
    
    init(user: User) {
        self.user = user
    }
}

// MARK: - Helper
extension DetailProfileViewModel {
    func isSimilarInterestedInTag(_ tag: String) -> Bool {
        guard let currentUser = AppData.shared.user else { return false }
        return currentUser.interestedTags.contains(where: { $0.name == tag })
    }
    
    func getInterestedInTag() -> [String] {
        return user.interestedTags.map({ $0.name })
    }
    
    func getMyBasicStrings() -> [String] {
        var basicStrings: [String] = []
        if !user.jobTitle.isEmpty {
            basicStrings.append(user.jobTitle)
        }
        if !user.company.isEmpty {
            basicStrings.append(user.company)
        }
        if !user.school.isEmpty {
            basicStrings.append(user.school)
        }
        return basicStrings
    }
    
    func getGenderString() -> String {
        switch user.gender {
        case .male:
            return "Nam"
        case .female:
            return "Nữ"
        case .others:
            return "Khác"
        case .none:
            return ""
        }
    }
    
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
        guard let currentLocation = AppData.shared.user.location,
              let destinationLocation = user.location else { return "" }
        
        let distanceInMeters = currentLocation.distance(from: destinationLocation)
        if distanceInMeters < 1000 {
            return String(format: "%.2f m", distanceInMeters)
        } else {
            return String(format: "%.2f km", distanceInMeters / 1000)
        }
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
