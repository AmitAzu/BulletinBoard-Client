//
//  MapView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: BulletinViewModel
    
    var body: some View {
        GoogleMapView(userLocation: $viewModel.locationService.userLocation,
                      bulletinList: viewModel.filteredBulletinList)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
