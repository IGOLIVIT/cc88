//
//  SettingsView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        statsSection
                        
                        actionsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Reset Game"),
                message: Text("Are you sure you want to reset all game progress? This action cannot be undone."),
                primaryButton: .destructive(Text("Reset")) {
                    viewModel.resetGame()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.appPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                StatRow(icon: "trophy.fill", label: "Total Score", value: "\(viewModel.gameState.totalScore)")
                StatRow(icon: "cube.box.fill", label: "Blocks Removed", value: "\(viewModel.gameState.blocksRemoved)")
                StatRow(icon: "flag.fill", label: "Levels Completed", value: "\(viewModel.gameState.unlockedLevels - 1)")
                StatRow(icon: "star.fill", label: "Achievements", value: "\(viewModel.gameState.achievements.filter { $0.isUnlocked }.count)/\(viewModel.gameState.achievements.count)")
            }
            .padding(16)
            .background(Color.appPrimary.opacity(0.1))
            .cornerRadius(16)
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 16) {
            Text("Actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.appPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20))
                    Text("Reset Game Progress")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(16)
                .background(Color.appDanger)
                .cornerRadius(16)
            }
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.appPrimary)
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.appPrimary)
        }
    }
}

