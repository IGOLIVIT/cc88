//
//  OnboardingView.swift
//  cc88
//
//  JengaPlay Game
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Welcome",
            description: "Master the art of precision and strategy in this unique block removal game",
            icon: "cube.box.fill"
        ),
        OnboardingPage(
            title: "Remove Safe Blocks",
            description: "Tap blocks to remove them. Avoid red vulnerable blocks - they'll end your game!",
            icon: "hand.tap.fill"
        ),
        OnboardingPage(
            title: "Complete Objectives",
            description: "Each level has a target number of blocks to remove. Complete objectives to unlock new levels",
            icon: "target"
        ),
        OnboardingPage(
            title: "Earn Achievements",
            description: "Unlock achievements, climb the leaderboard, and become the ultimate JengaPlay master!",
            icon: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    HStack {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.appPrimary : Color.appSecondary)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                        .frame(height: 80)
                    
                    VStack(spacing: 20) {
                        Image(systemName: pages[currentPage].icon)
                            .font(.system(size: 80))
                            .foregroundColor(.appPrimary)
                        
                        Text(pages[currentPage].title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.appPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text(pages[currentPage].description)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                        .frame(height: 80)
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.appPrimary)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 40)
                    } else {
                        Button(action: {
                            withAnimation {
                                hasCompletedOnboarding = true
                            }
                        }) {
                            Text("Get Started")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.appPrimary)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.appPrimary)
                        }
                        .padding(.bottom, 20)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

