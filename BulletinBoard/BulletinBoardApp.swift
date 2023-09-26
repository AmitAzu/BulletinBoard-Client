//
//  BulletinBoardApp.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 23/09/2023.
//

import SwiftUI
import GoogleMaps

@main
struct BulletinBoardApp: App {
    @StateObject var locationService = LocationService()
    @StateObject var networkService = NetworkService()
    
    init() {
        GMSServices.provideAPIKey("AIzaSyDqgmpR3d_fmhnpVR9tZot4icKinlAdDtk")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationService: locationService,
                        networkService: networkService)
            .preferredColorScheme(.dark)
        }
    }
}
