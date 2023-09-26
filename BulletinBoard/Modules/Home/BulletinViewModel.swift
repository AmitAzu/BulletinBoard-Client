//
//  HomeViewModel.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation
import CoreLocation
import SwiftUI

class BulletinViewModel: ObservableObject {
    var locationService: LocationService
    static let shared = BulletinViewModel(locationService: LocationService())

    @Published var searchText = ""
    @Published var filteredBulletinList: [BulletinData] = []
    @Published private var bulletinList: [BulletinData] = [] {
        didSet {
            filteredBulletinList = bulletinList
        }
    }

    init(locationService: LocationService) {
        self.locationService = locationService
        fetchBulletins()
    }
    
    func sortByDistanceFromUserLocation() {
        bulletinList.sort { (bulletin1, bulletin2) -> Bool in
            let location1 = CLLocation(latitude: Double(bulletin1.geo.lat) ?? 0.0,
                                       longitude: Double(bulletin1.geo.lng) ?? 0.0)
            let distance1 = locationService.userLocation?.distance(from: location1) ?? 0.0
            
            let location2 = CLLocation(latitude: Double(bulletin2.geo.lat) ?? 0.0,
                                       longitude: Double(bulletin2.geo.lng) ?? 0.0)
            let distance2 = locationService.userLocation?.distance(from: location2) ?? 0.0
            
            return distance1 < distance2
        }
    }
    
    func filterBulletinList() {
        if searchText.isEmpty {
            filteredBulletinList = bulletinList
        } else {
            filteredBulletinList = bulletinList.filter { bulletin in
                let searchString = searchText.lowercased()
                return bulletin.title.lowercased().contains(searchString)
            }
        }
    }
    
    // TODO: SEND DELETE REQUEST
    func removeItemAtIndex(_ index: Int) {
        bulletinList.remove(at: index)
    }
    
    // TODO: SEND POST REQUEST
    func addNewBulletin(_ bulletin: BulletinData) {
        bulletinList.append(bulletin)
    }
    
    //TODO: SEND GET REQUEST
    func fetchBulletins() {
        let bulletinList = [
            BulletinData(
                url: "https://via.placeholder.com/600/54176f",
                geo: Geo(lat: "-33.8650", lng: "151.2094"),
                title: "Title 4",
                body: "Body 4",
                userName: "User 4"
            ),
            BulletinData(
                url: "https://via.placeholder.com/600/92c952",
                geo: Geo(lat: "48.8566", lng: "2.3522"),
                title: "Title 1",
                body: "Body 1",
                userName: "User 1"
            ),
            BulletinData(
                url: "https://via.placeholder.com/600/771796",
                geo: Geo(lat: "40.7128", lng: "-74.0060"),
                title: "Title 2",
                body: "Body 2",
                userName: "User 2"
            ),
            BulletinData(
                url: "https://via.placeholder.com/600/f66b97",
                geo: Geo(lat: "-33.8650", lng: "151.2094"),
                title: "Title 3",
                body: "Body 3",
                userName: "User 3"
            ),
            BulletinData(url: "https://via.placeholder.com/600/f66b97",
                         geo: Geo(lat: "37.759062", lng: "-122.4243592"),
                         title: "Sen Francisco",
                         body: "body 4",
                         userName: "User 4"
                        ),
            BulletinData(url: "https://via.placeholder.com/600/f66b97",
                         geo: Geo(lat: "32.0717933", lng: "34.785018"),
                         title: "Ramat gan",
                         body: "Ramat gan",
                         userName: "Ramat gan"
                        ),
            BulletinData(url: "https://via.placeholder.com/600/f66b97",
                         geo: Geo(lat: "32.0717933", lng: "34.785018"),
                         title: "Tel Aviv",
                         body: "Tel Aviv",
                         userName: "Tel Aviv"
                        )
        ]
        self.bulletinList = bulletinList
    }
}
