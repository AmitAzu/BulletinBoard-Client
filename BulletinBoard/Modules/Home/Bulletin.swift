//
//  Bulletin.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation

struct BulletinData: Codable, Identifiable {
    var id = UUID()
    let url: String
    let geo: Geo
    let title: String
    let body: String
    let userName: String
}

struct Geo: Codable {
    let lat: String
    let lng: String
}
