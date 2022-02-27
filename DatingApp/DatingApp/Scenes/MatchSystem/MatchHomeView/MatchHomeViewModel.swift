//
//  MatchHomeViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/12/2021.
//

import SwiftUI
import CoreLocation

enum MatchHomeViewType {
    case DisableLocation
    case Swipeable
    case LoadingData
}

class MatchHomeViewModel: ObservableObject {
    @Published var viewType: MatchHomeViewType = .DisableLocation
    @Published var users: [User] = [] // Using to render view
    @Published var isPresentDetailProfileView = false
    private var innerUsers: [User] = [] // FIXME: MatchHomeViewModel.1
    private var currentPage: Int = 0
    private var limit = 10
    private var isEnableLocation = false
    private var isOutOfUser = false
    private var isLoading = false
    private var location: CLLocation?
    
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
    @objc func getRecommendUsersAndUpdateLocation(notification: NSNotification) {
        guard let location = notification.object as? CLLocation else { return }
        self.location = location
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
        viewType = .LoadingData
        isLoading = true
        
        Helper.showProgress()
        RecsAPIManager.shared.getRecommendUser(location: location, currentPage: currentPage, limit: limit) { [weak self] users, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                self.users = users
                self.innerUsers = users
                self.currentPage += 1
                self.viewType = .Swipeable
            }
        }
    }
    
    func getNextPageRecommendUsers() {
        guard let location = AppData.shared.user.location else { return }
        isLoading = true
        RecsAPIManager.shared.getRecommendUser(location: location, currentPage: currentPage, limit: limit) { [weak self] users, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let users = users {
                if users.isEmpty {
                    self.isOutOfUser = true
                } else {
                    self.users.append(contentsOf: users)
                    self.innerUsers.append(contentsOf: users)
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
            viewType = .LoadingData
            LocationManager.shared.startUpdatingLocation()
        } else {
            AppData.shared.isUpdatedLocation = false
            isEnableLocation = false
            viewType = .DisableLocation
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
    func getTopUser() -> User {
        return innerUsers.first ?? User()
    }
    
    func didCardTapped() {
        isPresentDetailProfileView = true
    }
    
    func reloadHome() {
        guard let location = location else { return }
        users.removeAll()
        innerUsers.removeAll()
        viewType = .LoadingData
        getRecommendUsers(location: location)
    }
    
    func gotoSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func loadMoreIfNeeded() {
        let halfLimit = Int((Float(limit) / 2).rounded(.up))
        guard innerUsers.count <= halfLimit, !isOutOfUser, !isLoading else { return }
        DispatchQueue.global().async {
            self.getNextPageRecommendUsers()
        }
    }
    
    func swipingUser(_ user: User, direction: LeftRight) {
        innerUsers.removeFirst()
        
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

// FIXME: MatchHomeViewModel.1
/*
 Cannot removeFirst() of @Published var users: [User] when swiping a User.
 If we use removeFirst of @Published users. We lost many last element in array @Published users
 => Temporary resolves: Using another array - innerUsers
 */
