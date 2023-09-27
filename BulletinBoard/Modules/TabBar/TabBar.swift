//
//  TabBar.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 23/09/2023.
//

import SwiftUI

struct TabBar: View {
    @State var selectedTab: Int = 0
    var locationService: LocationService
    var networkService: NetworkService

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: BulletinViewModel.shared)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            MapView(viewModel: BulletinViewModel.shared)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)
            CreateNewBulletinView(viewModel: BulletinViewModel.shared, selectedTab: $selectedTab)
                .tabItem {
                    Label("New Bulletin", systemImage: "plus.circle.fill")
                }
                .tag(2)
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.secondary
            UITabBar.appearance().unselectedItemTintColor = UIColor.primaryText
        }
        .accentColor(Color.accentColor)
    }
}
