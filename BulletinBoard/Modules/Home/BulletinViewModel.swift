//
//  HomeViewModel.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class BulletinViewModel: ObservableObject {
    static let shared = BulletinViewModel(locationService: LocationService(), networkService: NetworkService())
    var locationService: LocationService
    private var networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var showError: Bool = false
    @Published var searchText = ""
    @Published var filteredBulletinList: [Bulletin] = []
    private var bulletinList: [Bulletin] = [] {
        didSet {
            filteredBulletinList = bulletinList
        }
    }
    
    init(locationService: LocationService,
         networkService: NetworkService) {
        self.networkService = networkService
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
    
    func removeItemAtIndex(_ index: Int) {
        guard index >= 0, index < bulletinList.count else {
            print("Error deleting item: index out of range")
            return
        }
        let idToDelete = bulletinList[index].id
        let request = EndPointRequest(apiUrl: .deleteBulletin(id: idToDelete), method: .delete)
        networkService.dataTaskPublisher(from: request, ofType: DeleteResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error deleting item: \(error)")
                }
            }, receiveValue: { [weak self] response in
                if let error = response.error {
                    print("Error deleting item: \(error)")
                } else {
                    self?.bulletinList.remove(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
    func addNewBulletin(_ bulletin: Bulletin) {
        let request = EndPointRequest(apiUrl: .addBulletin, method: .post)
        networkService.postDataTaskPublisher(to: request, ofType: UploadBulletinResponse.self, withData: bulletin)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("upload bulletin failed: \(error)")
                case .finished: break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let error = response.error {
                    print("upload bulletin failed: \(error)")
                } else if let newBulletin = response.bulletin {
                    bulletinList.insert(newBulletin, at: 0)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchBulletins() {
        let request = EndPointRequest(apiUrl: .getBulletins, method: .get)
        networkService.dataTaskPublisher(from: request, ofType: Bulletins.self)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        guard let self = self else { return }
                        self.showError = true
                        print("error: \(error)")
                    case .finished: break
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.showError = false
                    self.bulletinList = response.bulletins
                }
            )
            .store(in: &cancellables)
    }
}
