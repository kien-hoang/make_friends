//
//  MatchHomeViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/12/2021.
//

import SwiftUI
import CoreLocation

class MatchHomeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isEnableLocation = false
    private var currentPage: Int = 0
    private var limit = 4
    private var isOutOfUser = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLocationPermission), name: .ChangedLocationPermission, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getRecommendUsersAndUpdateLocation), name: .GetRecommendUserAndUpdateLocation, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - API
extension MatchHomeViewModel {
    func gotoSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @objc func getRecommendUsersAndUpdateLocation(notification: NSNotification) {
        guard let location = notification.object as? CLLocation else { return }
        DispatchQueue.main.async {
            self.getRecommendUsers(location: location)
        }
        DispatchQueue.global().async {
            self.updateLocation(location)
        }
    }
    
    func getRecommendUsers(location: CLLocation) {
        currentPage = 0
        isOutOfUser = false
        
        Helper.showProgress()
        RecsAPIManager.shared.getRecommendUser(location: location, currentPage: currentPage, limit: limit) { [weak self] users, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                self.users = users
                self.currentPage += 1
            }
        }
    }
    
    func getNextPageRecommendUsers() {
        guard let location = AppData.shared.user.location else { return }
        RecsAPIManager.shared.getRecommendUser(location: location, currentPage: currentPage, limit: limit) { [weak self] users, error in
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                if users.isEmpty {
                    self.isOutOfUser = true
                } else {
                    self.users.append(contentsOf: users)
                    self.currentPage += 1
                }
            }
        }
    }
    
    func updateLocation(_ location: CLLocation) {
        UserAPIManager.shared.updateLocation(location) { [weak self] isSuccess, error in
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                Helper.showSuccess("Cập nhật vị trí thành công")
                AppData.shared.user.location = location
            }
        }
    }
    
    @objc func checkLocationPermission() {
        if LocationManager.shared.hasLocationPermission() {
            isEnableLocation = true
            LocationManager.shared.startUpdatingLocation()
        } else {
            AppData.shared.isUpdatedLocation = false
            isEnableLocation = false
        }
    }
    
    func updateDeviceToken() {
        UserAPIManager.shared.updateDeviceToken { [weak self] isSuccess, error in
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                Helper.showSuccess("Cập nhật token thiết bị thành công")
            }
        }
    }
}

// MARK: - Helper
extension MatchHomeViewModel {
    func loadMoreIfNeeded(_ user: User) {
        let halfLimit = Int((Float(limit) / 2).rounded(.up))
        guard users.count >= halfLimit, !isOutOfUser else { return }
        if user.id == users[users.count - halfLimit].id {
            DispatchQueue.global().async {
                self.getNextPageRecommendUsers()
            }
        }
    }
    
    func swipingUser(_ user: User, direction: LeftRight) {
        var params: [String: Any] = [:]
        params["user_id_of_liked_user"] = user.id
        params["status"] = direction == .left ? "PASS" : "LIKE"
        RecsAPIManager.shared.swipingUser(params: params) { [weak self] isSuccess, error in
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                // Success swiping user
            }
        }
    }
}
