//
//  GameDataService.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation

class GameDataService {
    static let shared = GameDataService()
    
    private let gameStateKey = "JengaPlayGameState"
    private let leaderboardKey = "JengaPlayLeaderboard"
    
    private init() {}
    
    func saveGameState(_ gameState: GameState) {
        if let encoded = try? JSONEncoder().encode(gameState) {
            UserDefaults.standard.set(encoded, forKey: gameStateKey)
        }
    }
    
    func loadGameState() -> GameState {
        if let data = UserDefaults.standard.data(forKey: gameStateKey),
           let decoded = try? JSONDecoder().decode(GameState.self, from: data) {
            return decoded
        }
        return GameState()
    }
    
    func resetGameState() {
        UserDefaults.standard.removeObject(forKey: gameStateKey)
    }
    
    func saveLeaderboard(_ entries: [LeaderboardEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: leaderboardKey)
        }
    }
    
    func loadLeaderboard() -> [LeaderboardEntry] {
        if let data = UserDefaults.standard.data(forKey: leaderboardKey),
           let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            return decoded.sorted { $0.score > $1.score }
        }
        return []
    }
    
    func addLeaderboardEntry(_ entry: LeaderboardEntry) {
        var entries = loadLeaderboard()
        entries.append(entry)
        entries.sort { $0.score > $1.score }
        if entries.count > 50 {
            entries = Array(entries.prefix(50))
        }
        saveLeaderboard(entries)
    }
}

