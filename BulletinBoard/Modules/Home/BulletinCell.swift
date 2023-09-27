//
//  BulletinCell.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 27/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BulletinCell: View {
    var bulletin: Bulletin
    
    var body: some View {
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
                HStack(alignment: .top) {
                    Text("Title:")
                        .font(.headline)
                    Text("\(bulletin.title)")
                        .font(.subheadline)
                }
                HStack(alignment: .top) {
                    Text("User:")
                        .font(.headline)
                    Text("\(bulletin.userName)")
                        .font(.subheadline)
                }
                HStack(alignment: .top) {
                    Text("Location:")
                        .font(.headline)
                    Text("\(bulletin.geo.lat), \(bulletin.geo.lng)")
                        .font(.subheadline)
                }
            }
        }
        .padding(.vertical, 12)
    }
}
