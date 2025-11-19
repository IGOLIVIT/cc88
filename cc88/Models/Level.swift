//
//  Level.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation
import CoreGraphics

struct Level: Identifiable, Codable {
    let id: Int
    let name: String
    let targetBlocksToRemove: Int
    let vulnerableBlocksCount: Int
    let layers: Int
    let timeLimit: Int?
    let difficulty: Difficulty
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
        case expert
    }
    
    static func generateLevels() -> [Level] {
        return [
            Level(id: 1, name: "First Steps", targetBlocksToRemove: 3, vulnerableBlocksCount: 2, layers: 6, timeLimit: nil, difficulty: .easy),
            Level(id: 2, name: "Rising Tower", targetBlocksToRemove: 5, vulnerableBlocksCount: 3, layers: 8, timeLimit: nil, difficulty: .easy),
            Level(id: 3, name: "Balance Master", targetBlocksToRemove: 7, vulnerableBlocksCount: 4, layers: 10, timeLimit: 120, difficulty: .medium),
            Level(id: 4, name: "Precision", targetBlocksToRemove: 9, vulnerableBlocksCount: 5, layers: 12, timeLimit: 100, difficulty: .medium),
            Level(id: 5, name: "Tower Challenge", targetBlocksToRemove: 12, vulnerableBlocksCount: 6, layers: 14, timeLimit: 90, difficulty: .hard),
            Level(id: 6, name: "Expert Builder", targetBlocksToRemove: 15, vulnerableBlocksCount: 7, layers: 16, timeLimit: 80, difficulty: .hard),
            Level(id: 7, name: "Master Architect", targetBlocksToRemove: 18, vulnerableBlocksCount: 8, layers: 18, timeLimit: 70, difficulty: .expert),
            Level(id: 8, name: "Ultimate Test", targetBlocksToRemove: 22, vulnerableBlocksCount: 10, layers: 20, timeLimit: 60, difficulty: .expert)
        ]
    }
}

