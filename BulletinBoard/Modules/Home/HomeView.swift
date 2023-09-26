//
//  HomeView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: BulletinViewModel
    @State private var sortByLocation = false
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { newValue in
                    viewModel.filterBulletinList()
                }
            
            Button(action: {
                viewModel.filteredBulletinList = viewModel.sortByDistanceFromUserLocation()
                sortByLocation.toggle()
            }) {
                Text("Tap to sort bulletins by location")
            }
            
            List {
                ForEach($viewModel.filteredBulletinList.indices, id: \.self) { index in
                    if index < viewModel.filteredBulletinList.count {
                        let bulletin = viewModel.filteredBulletinList[index]
                        HStack(alignment: .center, spacing: 30) {
                            let frame = UIScreen.main.bounds.width / 3
                            WebImage(url: URL(string: bulletin.url))
                                .renderingMode(.original)
                                .resizable()
                                .placeholder(Image(systemName: "photo"))
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .frame(width: frame, height: frame)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location: \(bulletin.geo.lat), \(bulletin.geo.lng)")
                                    .font(.subheadline)
                                Text("Title: \(bulletin.title)")
                                    .font(.headline)
                                Text("Body: \(bulletin.body)")
                                    .font(.body)
                                Text("User: \(bulletin.userName)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 12)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.removeItemAtIndex(index)
                    }
                }
            }
            .listStyle(.plain)
            .id(sortByLocation)
        }
        .onAppear {
//            viewModel.requestWhenInUseAuthorization()
        }
    }
}

//#Preview {
//    HomeView(viewModel: HomeViewModel(locationService: LocationService()))
//}
