//
//  SearchBarView.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Search By Title", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .padding()
    }
}
