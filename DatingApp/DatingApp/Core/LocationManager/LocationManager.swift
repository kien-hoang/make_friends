//
//  LocationManager.swift
//  DatingApp
//
//  Created by Radley Hoang on 12/12/2021.
//

import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    var latestLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 5.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            default:
                hasPermission = false
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        // Pick the location with best (= smallest value) horizontal accuracy
        latestLocation = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }.first
        
        if !AppData.shared.isUpdatedLocation {
            AppData.shared.isUpdatedLocation = true
            NotificationCenter.default.post(name: .GetRecommendUserAndUpdateLocation, object: latestLocation)
        }
    }
    
    public func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
        NotificationCenter.default.post(name: .ChangedLocationPermission, object: nil)
    }
}
