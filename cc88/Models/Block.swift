//
//  Block.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation
import SwiftUI

struct Block: Identifiable, Codable, Equatable {
    let id: UUID
    var position: CGPoint
    var rotation: Double
    var isRemoved: Bool
    var isVulnerable: Bool
    var layer: Int
    var indexInLayer: Int
    var size: CGSize
    
    init(id: UUID = UUID(), position: CGPoint, rotation: Double = 0, isRemoved: Bool = false, isVulnerable: Bool = false, layer: Int, indexInLayer: Int, size: CGSize = CGSize(width: 80, height: 25)) {
        self.id = id
        self.position = position
        self.rotation = rotation
        self.isRemoved = isRemoved
        self.isVulnerable = isVulnerable
        self.layer = layer
        self.indexInLayer = indexInLayer
        self.size = size
    }
}

