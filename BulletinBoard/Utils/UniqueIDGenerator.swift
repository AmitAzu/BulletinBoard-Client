//
//  UniqueIDGenerator.swift
//  BulletinBoard
//
//  Created by Amit Azulay on 27/09/2023.
//

import Foundation

class UniqueIDGenerator {
    static let shared = UniqueIDGenerator()
    private var usedIDs = Set<Int>()

    func generateUniqueID() -> Int {
        var randomID: Int
        repeat {
            randomID = Int.random(in: 1...999999)
        } while usedIDs.contains(randomID)
        usedIDs.insert(randomID)
        return randomID
    }
}
