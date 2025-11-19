//
//  MainMenuView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedTab = 0
    @State private var showingGame = false
    
    var body: some View {
        if showingGame {
            GameView(viewModel: viewModel, onBack: {
                showingGame = false
            })
        } else {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    tabContent
                    
                    Divider()
                        .background(Color.appPrimary.opacity(0.2))
                    
                    tabBar
                }
            }
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            homeView
        case 1:
            LevelSelectionView(viewModel: viewModel, showingGame: $showingGame)
        case 2:
            AchievementsView(viewModel: viewModel)
        case 3:
            LeaderboardView(viewModel: viewModel)
        case 4:
            SettingsView(viewModel: viewModel)
        default:
            homeView
        }
    }
    
    private var homeView: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer()
                    .frame(height: 40)
                
                VStack(spacing: 12) {
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.appPrimary)
                    
                    Text("Balance • Precision • Mastery")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.appPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Remove blocks wisely, avoid the red ones")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                VStack(spacing: 16) {
                    Button(action: {
                        viewModel.selectLevel(Level.generateLevels()[viewModel.gameState.currentLevel - 1])
                        showingGame = true
                    }) {
                        Text("Continue Level \(viewModel.gameState.currentLevel)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.appPrimary)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("Level Selection")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.appPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.appPrimary.opacity(0.1))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.appPrimary, lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                    .frame(height: 40)
            }
        }
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "house.fill", title: "Home", isSelected: selectedTab == 0)
                .onTapGesture { selectedTab = 0 }
            TabBarItem(icon: "square.grid.2x2.fill", title: "Levels", isSelected: selectedTab == 1)
                .onTapGesture { selectedTab = 1 }
            TabBarItem(icon: "star.fill", title: "Achievements", isSelected: selectedTab == 2)
                .onTapGesture { selectedTab = 2 }
            TabBarItem(icon: "chart.bar.fill", title: "Progress", isSelected: selectedTab == 3)
                .onTapGesture { selectedTab = 3 }
            TabBarItem(icon: "gearshape.fill", title: "Settings", isSelected: selectedTab == 4)
                .onTapGesture { selectedTab = 4 }
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color.appBackground)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .appPrimary : .gray)
            
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .appPrimary : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

