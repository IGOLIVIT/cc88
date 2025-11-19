//
//  GameViewModel.swift
//  cc88
//
//  JengaPlay Game
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var blocks: [Block] = []
    @Published var gameState: GameState
    @Published var currentLevel: Level
    @Published var score: Int = 0
    @Published var mistakes: Int = 0
    @Published var blocksRemovedInLevel: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isLevelComplete: Bool = false
    @Published var timeRemaining: Int?
    @Published var showingNewAchievement: Achievement?
    
    private var timer: AnyCancellable?
    private let dataService = GameDataService.shared
    private var levelStartTime: Date?
    
    init() {
        let loadedState = dataService.loadGameState()
        self.gameState = loadedState
        self.currentLevel = Level.generateLevels()[loadedState.currentLevel - 1]
        setupLevel()
    }
    
    func setupLevel() {
        blocks = []
        score = 0
        mistakes = 0
        blocksRemovedInLevel = 0
        isGameOver = false
        isLevelComplete = false
        levelStartTime = Date()
        
        // Разные размеры блоков в зависимости от сложности
        let blockWidth: CGFloat
        let blockHeight: CGFloat
        let spacing: CGFloat
        
        switch currentLevel.difficulty {
        case .easy:
            blockWidth = 85
            blockHeight = 28
            spacing = 6
        case .medium:
            blockWidth = 75
            blockHeight = 24
            spacing = 5
        case .hard:
            blockWidth = 70
            blockHeight = 22
            spacing = 4
        case .expert:
            blockWidth = 65
            blockHeight = 20
            spacing = 3
        }
        
        for layer in 0..<currentLevel.layers {
            let isHorizontal = layer % 2 == 0
            let blocksInLayer = 3
            let baseY = CGFloat(layer) * (blockHeight + spacing)
            
            for i in 0..<blocksInLayer {
                let position: CGPoint
                if isHorizontal {
                    let baseX = CGFloat(i) * (blockWidth + spacing)
                    position = CGPoint(x: baseX, y: baseY)
                } else {
                    let baseX = CGFloat(i) * (blockWidth + spacing)
                    position = CGPoint(x: baseX, y: baseY)
                }
                
                let block = Block(
                    position: position,
                    rotation: isHorizontal ? 0 : 90,
                    layer: layer,
                    indexInLayer: i,
                    size: CGSize(width: blockWidth, height: blockHeight)
                )
                blocks.append(block)
            }
        }
        
        markVulnerableBlocks()
        
        if let timeLimit = currentLevel.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        }
    }
    
    private func markVulnerableBlocks() {
        var vulnerableIndices = Set<Int>()
        let availableBlocks = blocks.filter { !$0.isRemoved && $0.layer > 0 && $0.layer < currentLevel.layers - 1 }
        let shuffled = availableBlocks.shuffled()
        
        for i in 0..<min(currentLevel.vulnerableBlocksCount, shuffled.count) {
            if let index = blocks.firstIndex(where: { $0.id == shuffled[i].id }) {
                vulnerableIndices.insert(index)
            }
        }
        
        for index in vulnerableIndices {
            blocks[index].isVulnerable = true
        }
    }
    
    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if let time = self.timeRemaining {
                    if time > 0 {
                        self.timeRemaining = time - 1
                    } else {
                        self.timer?.cancel()
                        self.gameOver()
                    }
                }
            }
    }
    
    func removeBlock(_ block: Block) {
        guard let index = blocks.firstIndex(where: { $0.id == block.id }), !blocks[index].isRemoved else {
            return
        }
        
        if blocks[index].isVulnerable {
            gameOver()
            return
        }
        
        blocks[index].isRemoved = true
        blocksRemovedInLevel += 1
        score += calculateBlockScore(block)
        
        gameState.blocksRemoved += 1
        
        checkAchievements()
        
        if blocksRemovedInLevel >= currentLevel.targetBlocksToRemove {
            completeLevel()
        }
    }
    
    private func calculateBlockScore(_ block: Block) -> Int {
        let baseScore = 10
        let layerBonus = block.layer * 5
        let difficultyMultiplier: Int
        
        switch currentLevel.difficulty {
        case .easy: difficultyMultiplier = 1
        case .medium: difficultyMultiplier = 2
        case .hard: difficultyMultiplier = 3
        case .expert: difficultyMultiplier = 4
        }
        
        return (baseScore + layerBonus) * difficultyMultiplier
    }
    
    private func gameOver() {
        isGameOver = true
        timer?.cancel()
        
        if gameState.consecutiveLevelsCompleted > 0 {
            gameState.consecutiveLevelsCompleted = 0
        }
        
        saveGame()
    }
    
    private func completeLevel() {
        isLevelComplete = true
        timer?.cancel()
        
        let timeBonusMultiplier: Double
        if let elapsed = levelStartTime.map({ Date().timeIntervalSince($0) }),
           let limit = currentLevel.timeLimit {
            let remainingTime = Double(limit) - elapsed
            if remainingTime > 0 {
                timeBonusMultiplier = 1.0 + (remainingTime / Double(limit))
                
                if remainingTime > Double(limit) * 0.7 {
                    checkSpeedAchievement()
                }
            } else {
                timeBonusMultiplier = 1.0
            }
        } else {
            timeBonusMultiplier = 1.0
        }
        
        let finalScore = Int(Double(score) * timeBonusMultiplier)
        score = finalScore
        gameState.totalScore += finalScore
        
        if mistakes == 0 {
            checkPerfectRunAchievement()
        }
        
        let previousScore = gameState.levelScores[currentLevel.id] ?? 0
        if finalScore > previousScore {
            gameState.levelScores[currentLevel.id] = finalScore
        }
        
        gameState.consecutiveLevelsCompleted += 1
        
        if currentLevel.id >= gameState.unlockedLevels {
            gameState.unlockedLevels = min(currentLevel.id + 1, Level.generateLevels().count)
        }
        
        checkLevelAchievements()
        
        saveGame()
    }
    
    private func checkAchievements() {
        checkBlockAchievements()
    }
    
    private func checkBlockAchievements() {
        let blockAchievements = [
            ("first_block", 1),
            ("blocks_10", 10),
            ("blocks_50", 50),
            ("blocks_100", 100)
        ]
        
        for (id, requirement) in blockAchievements {
            if let index = gameState.achievements.firstIndex(where: { $0.id == id }) {
                gameState.achievements[index].progress = gameState.blocksRemoved
                if !gameState.achievements[index].isUnlocked && gameState.blocksRemoved >= requirement {
                    unlockAchievement(id: id)
                }
            }
        }
    }
    
    private func checkLevelAchievements() {
        let levelAchievements = [
            ("level_3", 3),
            ("level_5", 5),
            ("level_8", 8)
        ]
        
        for (id, requirement) in levelAchievements {
            if let index = gameState.achievements.firstIndex(where: { $0.id == id }) {
                gameState.achievements[index].progress = gameState.unlockedLevels - 1
                if !gameState.achievements[index].isUnlocked && gameState.unlockedLevels - 1 >= requirement {
                    unlockAchievement(id: id)
                }
            }
        }
        
        if let index = gameState.achievements.firstIndex(where: { $0.id == "streak_5" }) {
            gameState.achievements[index].progress = gameState.consecutiveLevelsCompleted
            if !gameState.achievements[index].isUnlocked && gameState.consecutiveLevelsCompleted >= 5 {
                unlockAchievement(id: "streak_5")
            }
        }
    }
    
    private func checkPerfectRunAchievement() {
        if let index = gameState.achievements.firstIndex(where: { $0.id == "no_mistakes" }) {
            if !gameState.achievements[index].isUnlocked {
                gameState.achievements[index].progress = 1
                unlockAchievement(id: "no_mistakes")
            }
        }
    }
    
    private func checkSpeedAchievement() {
        if let index = gameState.achievements.firstIndex(where: { $0.id == "speed_demon" }) {
            if !gameState.achievements[index].isUnlocked {
                gameState.achievements[index].progress = 1
                unlockAchievement(id: "speed_demon")
            }
        }
    }
    
    private func unlockAchievement(id: String) {
        if let index = gameState.achievements.firstIndex(where: { $0.id == id }) {
            gameState.achievements[index].isUnlocked = true
            showingNewAchievement = gameState.achievements[index]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.showingNewAchievement = nil
            }
        }
    }
    
    func selectLevel(_ level: Level) {
        guard level.id <= gameState.unlockedLevels else { return }
        currentLevel = level
        gameState.currentLevel = level.id
        setupLevel()
    }
    
    func nextLevel() {
        let levels = Level.generateLevels()
        if currentLevel.id < levels.count {
            currentLevel = levels[currentLevel.id]
            gameState.currentLevel = currentLevel.id
            setupLevel()
        }
    }
    
    func retryLevel() {
        setupLevel()
    }
    
    func resetGame() {
        dataService.resetGameState()
        gameState = GameState()
        currentLevel = Level.generateLevels()[0]
        setupLevel()
    }
    
    private func saveGame() {
        dataService.saveGameState(gameState)
    }
}

