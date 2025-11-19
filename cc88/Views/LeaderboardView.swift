//
//  LeaderboardView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Общая статистика
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.appPrimary)
                            Text("Your Progress")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            StatCard(
                                icon: "trophy.fill",
                                title: "Total Score",
                                value: "\(viewModel.gameState.totalScore)",
                                color: Color(hex: "FFD700")
                            )
                            
                            StatCard(
                                icon: "flag.checkered.fill",
                                title: "Levels Completed",
                                value: "\(viewModel.gameState.unlockedLevels - 1) / \(Level.generateLevels().count)",
                                color: Color(hex: "7CB342")
                            )
                            
                            StatCard(
                                icon: "cube.box.fill",
                                title: "Total Blocks Removed",
                                value: "\(viewModel.gameState.blocksRemoved)",
                                color: Color(hex: "FFA726")
                            )
                            
                            StatCard(
                                icon: "star.fill",
                                title: "Achievements Unlocked",
                                value: "\(viewModel.gameState.achievements.filter { $0.isUnlocked }.count) / \(viewModel.gameState.achievements.count)",
                                color: Color(hex: "EF5350")
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Лучшие результаты по уровням
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "medal.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.appPrimary)
                            Text("Best Scores")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            Spacer()
                        }
                        
                        if viewModel.gameState.levelScores.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "star.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(.appSecondary)
                                Text("No scores yet")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.gray)
                                Text("Complete levels to see your best scores")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 30)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(Array(viewModel.gameState.levelScores.sorted(by: { $0.key < $1.key })), id: \.key) { levelId, score in
                                    if let level = Level.generateLevels().first(where: { $0.id == levelId }) {
                                        LevelScoreRow(level: level, score: score)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(color.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
}

struct LevelScoreRow: View {
    let level: Level
    let score: Int
    
    private var difficultyColor: Color {
        switch level.difficulty {
        case .easy: return Color(hex: "7CB342")
        case .medium: return Color(hex: "FFA726")
        case .hard: return Color(hex: "EF5350")
        case .expert: return Color(hex: "8E24AA")
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Level \(level.id)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Circle()
                        .fill(difficultyColor)
                        .frame(width: 6, height: 6)
                    
                    Text(level.difficulty.rawValue.capitalized)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(difficultyColor)
                }
                
                Text(level.name)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)
                
                Text("\(score)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("pts")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(difficultyColor.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(difficultyColor.opacity(0.3), lineWidth: 1)
        )
    }
}

