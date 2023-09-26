//
//  LocationService.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 23/09/2023.
//

import CoreLocation
import Combine
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userLocation: CLLocation?
    @Published var locationPermissionStatus: LocationPermissionStatus = .notDetermined
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.publisher(for: \.location)
            .map { $0 as CLLocation? }
            .assign(to: \.userLocation, on: self)
            .store(in: &cancellables)
    }
    
    func checkLocationPermissionStatus() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationPermissionStatus = .notDetermined
        case .denied, .restricted:
            locationPermissionStatus = .denied
        case .authorizedWhenInUse, .authorizedAlways:
            locationPermissionStatus = .authorized
        @unknown default:
            locationPermissionStatus = .denied
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
    func test() {
        checkLocationPermissionStatus()
        if locationPermissionStatus != .authorized {
            //TODO: GO TO SETTINGS POPUP
            setupLocationManager()
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

enum LocationPermissionStatus {
    case notDetermined
    case denied
    case authorized
    case restricted
}
