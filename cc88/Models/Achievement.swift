//
//  Achievement.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation

struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let requirement: Int
    var isUnlocked: Bool
    var progress: Int
    let icon: String
    
    static func allAchievements() -> [Achievement] {
        return [
            Achievement(id: "first_block", title: "First Touch", description: "Remove your first block", requirement: 1, isUnlocked: false, progress: 0, icon: "hand.tap"),
            Achievement(id: "blocks_10", title: "Getting Started", description: "Remove 10 blocks total", requirement: 10, isUnlocked: false, progress: 0, icon: "square.stack.3d.up"),
            Achievement(id: "blocks_50", title: "Block Remover", description: "Remove 50 blocks total", requirement: 50, isUnlocked: false, progress: 0, icon: "cube.box"),
            Achievement(id: "blocks_100", title: "Century Club", description: "Remove 100 blocks total", requirement: 100, isUnlocked: false, progress: 0, icon: "shippingbox"),
            Achievement(id: "level_3", title: "Rising Up", description: "Complete level 3", requirement: 3, isUnlocked: false, progress: 0, icon: "arrow.up.circle"),
            Achievement(id: "level_5", title: "Halfway There", description: "Complete level 5", requirement: 5, isUnlocked: false, progress: 0, icon: "star.circle"),
            Achievement(id: "level_8", title: "Master Player", description: "Complete all levels", requirement: 8, isUnlocked: false, progress: 0, icon: "crown"),
            Achievement(id: "no_mistakes", title: "Perfect Run", description: "Complete a level without mistakes", requirement: 1, isUnlocked: false, progress: 0, icon: "checkmark.seal"),
            Achievement(id: "speed_demon", title: "Speed Demon", description: "Complete a timed level in under 30 seconds", requirement: 1, isUnlocked: false, progress: 0, icon: "bolt.circle"),
            Achievement(id: "streak_5", title: "On Fire", description: "Complete 5 levels in a row", requirement: 5, isUnlocked: false, progress: 0, icon: "flame")
        ]
    }
}

