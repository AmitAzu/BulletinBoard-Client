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
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
