//
//  LevelSelectionView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct LevelSelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var showingGame: Bool
    
    let levels = Level.generateLevels()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(levels) { level in
                            LevelCard(
                                level: level,
                                isUnlocked: level.id <= viewModel.gameState.unlockedLevels,
                                bestScore: viewModel.gameState.levelScores[level.id]
                            )
                            .onTapGesture {
                                if level.id <= viewModel.gameState.unlockedLevels {
                                    viewModel.selectLevel(level)
                                    showingGame = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct LevelCard: View {
    let level: Level
    let isUnlocked: Bool
    let bestScore: Int?
    
    private var difficultyColor: Color {
        switch level.difficulty {
        case .easy: return Color(hex: "7CB342")
        case .medium: return Color(hex: "FFA726")
        case .hard: return Color(hex: "EF5350")
        case .expert: return Color(hex: "8E24AA")
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level.id)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(isUnlocked ? .gray : .gray.opacity(0.5))
                    
                    Text("\(level.id)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(isUnlocked ? difficultyColor : .gray)
                }
                
                Spacer()
                
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: difficultyIcon(level.difficulty))
                        .font(.system(size: 28))
                        .foregroundColor(difficultyColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(level.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(isUnlocked ? .primary : .gray)
                    .lineLimit(1)
                
                if isUnlocked {
                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(difficultyColor)
                                .frame(width: 6, height: 6)
                            Text(level.difficulty.rawValue.capitalized)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("•")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 3) {
                            Image(systemName: "cube.box")
                                .font(.system(size: 10))
                            Text("\(level.targetBlocksToRemove)")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.secondary)
                        
                        if level.timeLimit != nil {
                            Text("•")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let score = bestScore {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                            Text("\(score) pts")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.yellow)
                        .padding(.top, 2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: isUnlocked ? [difficultyColor.opacity(0.15), difficultyColor.opacity(0.05)] : [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isUnlocked ? difficultyColor : Color.gray, lineWidth: isUnlocked ? 2 : 1)
        )
        .shadow(color: isUnlocked ? difficultyColor.opacity(0.2) : Color.clear, radius: isUnlocked ? 4 : 0, x: 0, y: 2)
    }
    
    private func difficultyIcon(_ difficulty: Level.Difficulty) -> String {
        switch difficulty {
        case .easy: return "leaf.fill"
        case .medium: return "star.fill"
        case .hard: return "flame.fill"
        case .expert: return "bolt.fill"
        }
    }
}

