//
//  ErrorView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 27/09/2023.
//

import SwiftUI

struct ErrorView: View {
    var onRetry: () -> Void
    
    var body: some View {
        
        VStack {
            Text("Failed to fetch data. Please try again later.")
                .foregroundColor(Color.accentColor)
                .padding()
            Button {
                onRetry()
            } label: {
                Text("Try Again")
                    .foregroundColor(Color.primaryText)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
            }
        }
    }
}
