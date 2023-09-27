//
//  HomeView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: BulletinViewModel
    @State private var selectedBulletin: Bulletin? = nil
    
    var body: some View {
        if viewModel.showError {
            ErrorView() {
                viewModel.fetchBulletins()
            }
        } else {
            NavigationView {
                VStack {
                    SearchBarView(searchText: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.filterBulletinList()
                        }
                    Button(action: {
                        viewModel.sortByDistanceFromUserLocation()
                    }) {
                        Text("Tap to sort bulletins by location")
                    }
                    List {
                        ForEach($viewModel.filteredBulletinList.indices, id: \.self) { index in
                            if index < viewModel.filteredBulletinList.count {
                                let bulletin = viewModel.filteredBulletinList[index]
                                
                                NavigationLink(
                                    destination: BulletinDetailView(bulletin: bulletin)
                                ) {
                                    BulletinCell(bulletin: bulletin)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.removeItemAtIndex(index)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
}
