//
//  GameState.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation

struct GameState: Codable {
    var currentLevel: Int
    var unlockedLevels: Int
    var totalScore: Int
    var blocksRemoved: Int
    var achievements: [Achievement]
    var levelScores: [Int: Int]
    var consecutiveLevelsCompleted: Int
    var lastPlayedDate: Date?
    
    init() {
        self.currentLevel = 1
        self.unlockedLevels = 1
        self.totalScore = 0
        self.blocksRemoved = 0
        self.achievements = Achievement.allAchievements()
        self.levelScores = [:]
        self.consecutiveLevelsCompleted = 0
        self.lastPlayedDate = nil
    }
}

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let playerName: String
    let score: Int
    let level: Int
    let date: Date
    
    init(playerName: String = "Player", score: Int, level: Int, date: Date = Date()) {
        self.id = UUID()
        self.playerName = playerName
        self.score = score
        self.level = level
        self.date = date
    }
}

