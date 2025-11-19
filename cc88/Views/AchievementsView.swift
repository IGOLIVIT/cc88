//
//  AchievementsView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.gameState.achievements) { achievement in
                            AchievementCard(achievement: achievement)
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

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.icon)
                .font(.system(size: 32))
                .foregroundColor(achievement.isUnlocked ? .appPrimary : .gray)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(achievement.isUnlocked ? .appPrimary : .gray)
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    ProgressView(value: Double(achievement.progress), total: Double(achievement.requirement))
                        .progressViewStyle(LinearProgressViewStyle(tint: .appPrimary))
                        .frame(height: 8)
                    
                    Text("\(achievement.progress)/\(achievement.requirement)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.appSecondary)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding(16)
        .background(achievement.isUnlocked ? Color.appPrimary.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isUnlocked ? Color.appPrimary : Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}

