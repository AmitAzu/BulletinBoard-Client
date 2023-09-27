//
//  BulletinDetailView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 27/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BulletinDetailView: View {
    var bulletin: Bulletin
    
    var body: some View {
        WebImage(url: URL(string: bulletin.url))
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(10)
            .padding()
        
        VStack (alignment: .leading, spacing: 12) {
            Text(bulletin.title)
                .font(.title)
            
            Text(bulletin.body)
                .font(.body)
            
            Text("Location: \(bulletin.geo.lat), \(bulletin.geo.lng)")
                .font(.body)
            
            Button(action: {
                shareBulletinOnWhatsApp()
            }) {
                HStack (alignment: .firstTextBaseline){
                    Text("Share Bulletin")
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                }
            }
        }
        .padding()
        .navigationBarTitle("Bulletin Details", displayMode: .inline)
    }
    
    func shareBulletinOnWhatsApp() {
        let text = "Check out this bulletin: \(bulletin.title)\n\(bulletin.body)\nLocation: \(bulletin.geo.lat), \(bulletin.geo.lng)"
        if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let whatsappURL = URL(string: "whatsapp://send?text=\(encodedText)") {
            UIApplication.shared.open(whatsappURL)
        }
    }
}

