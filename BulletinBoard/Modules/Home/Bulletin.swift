//
//  Bulletin.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 24/09/2023.
//

import Foundation

struct Bulletins: Codable {
    let bulletins: [Bulletin]
}

struct Bulletin: Codable {
    let id: Int
    let url: String
    let geo: Geo
    let title: String
    let userName: String

    enum CodingKeys: String, CodingKey {
        case url = "imageUrl"
        case geo, title, userName, id
    }

    struct Geo: Codable {
        let lat: String
        let lng: String
    }
}

struct DeleteResponse: Codable {
    let message: String?
    let error: String?
}

struct UploadBulletinResponse: Codable {
    let bulletin: Bulletin
    let message: String
    let error: String?
}
