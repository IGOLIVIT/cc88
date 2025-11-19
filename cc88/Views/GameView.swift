//
//  GameView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedBlock: Block?
    @State private var showingLevelComplete = false
    @State private var showingGameOver = false
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Кнопка назад
                HStack {
                    Button(action: {
                        onBack()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(difficultyColor)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                headerView
                
                gameAreaView
                
                Spacer()
            }
            
            if let achievement = viewModel.showingNewAchievement {
                achievementBanner(achievement)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            if showingLevelComplete || viewModel.isLevelComplete {
                levelCompleteOverlay
            }
            
            if showingGameOver || viewModel.isGameOver {
                gameOverOverlay
            }
        }
        .onChange(of: viewModel.isLevelComplete) { newValue in
            if newValue {
                withAnimation {
                    showingLevelComplete = true
                }
            }
        }
        .onChange(of: viewModel.isGameOver) { newValue in
            if newValue {
                withAnimation {
                    showingGameOver = true
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("Level \(viewModel.currentLevel.id)")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                        
                        Circle()
                            .fill(difficultyColor)
                            .frame(width: 8, height: 8)
                        
                        Text(viewModel.currentLevel.difficulty.rawValue.capitalized)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(difficultyColor)
                    }
                    
                    Text(viewModel.currentLevel.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(difficultyColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Score")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                    Text("\(viewModel.score)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(difficultyColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            HStack(spacing: 20) {
                progressItem(
                    icon: "cube.box",
                    value: "\(viewModel.blocksRemovedInLevel)/\(viewModel.currentLevel.targetBlocksToRemove)"
                )
                
                if let timeRemaining = viewModel.timeRemaining {
                    progressItem(
                        icon: "clock",
                        value: "\(timeRemaining)s",
                        color: timeRemaining < 30 ? .appDanger : difficultyColor
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color.appBackground)
    }
    
    private var difficultyColor: Color {
        switch viewModel.currentLevel.difficulty {
        case .easy:
            return Color(hex: "7CB342")
        case .medium:
            return Color(hex: "FFA726")
        case .hard:
            return Color(hex: "EF5350")
        case .expert:
            return Color(hex: "8E24AA")
        }
    }
    
    private func progressItem(icon: String, value: String, color: Color? = nil) -> some View {
        let displayColor = color ?? difficultyColor
        return HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(displayColor)
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(displayColor)
        }
    }
    
    private var gameAreaView: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let startY = geometry.size.height * 0.7
            
            ZStack {
                ForEach(viewModel.blocks) { block in
                    if !block.isRemoved {
                        BlockView(block: block, viewModel: viewModel)
                            .position(
                                x: centerX - 120 + block.position.x,
                                y: startY - block.position.y
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    viewModel.removeBlock(block)
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func achievementBanner(_ achievement: Achievement) -> some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievement Unlocked!")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    Text(achievement.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.appPrimary)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
            .padding(.top, 60)
            
            Spacer()
        }
    }
    
    private var levelCompleteOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Level Complete!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.appPrimary)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Score:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(viewModel.score)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.appPrimary)
                    }
                    
                    HStack {
                        Text("Blocks Removed:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(viewModel.blocksRemovedInLevel)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                
                if viewModel.currentLevel.id < Level.generateLevels().count {
                    Button(action: {
                        withAnimation {
                            showingLevelComplete = false
                            viewModel.nextLevel()
                        }
                    }) {
                        Text("Next Level")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.appPrimary)
                            .cornerRadius(16)
                    }
                } else {
                    Text("You've completed all levels!")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.appPrimary)
                }
                
                Button(action: {
                    withAnimation {
                        showingLevelComplete = false
                        viewModel.retryLevel()
                    }
                }) {
                    Text("Replay Level")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.appPrimary)
                }
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
    }
    
    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.appDanger)
                
                Text("Game Over")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.appPrimary)
                
                Text("You removed a vulnerable block!")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation {
                        showingGameOver = false
                        viewModel.retryLevel()
                    }
                }) {
                    Text("Try Again")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appPrimary)
                        .cornerRadius(16)
                }
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
    }
}

struct BlockView: View {
    let block: Block
    @ObservedObject var viewModel: GameViewModel
    
    private var blockColor: Color {
        if block.isVulnerable {
            return Color.appDanger
        }
        
        switch viewModel.currentLevel.difficulty {
        case .easy:
            return Color(hex: "7CB342")
        case .medium:
            return Color(hex: "FFA726")
        case .hard:
            return Color(hex: "EF5350")
        case .expert:
            return Color(hex: "8E24AA")
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(blockColor)
            .frame(width: block.size.width, height: block.size.height)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .rotationEffect(.degrees(block.rotation))
    }
}

