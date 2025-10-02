//
//  ContentView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    @State private var userName = ""
    @State private var selectedTab = 0
    
    var body: some View {
        if hasCompletedOnboarding && !userName.isEmpty {
            MainTabView(userName: userName, selectedTab: $selectedTab)
        } else {
            OnboardingView(
                onComplete: { name in
                    userName = name
                    hasCompletedOnboarding = true
                }
            )
        }
    }
}

struct MainTabView: View {
    let userName: String
    @Binding var selectedTab: Int
    @State private var previousTab: Int = 0
    
    var body: some View {
        ZStack {
            // Noir background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle white glow overlay
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.06), Color.clear]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 420
            )
            .blur(radius: 28)
            .blendMode(.screen)
            .ignoresSafeArea()
            
            // Stronger monochromatic glow from top
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                center: .top,
                startRadius: 0,
                endRadius: 520
            )
            .blur(radius: 36)
            .blendMode(.screen)
            .ignoresSafeArea()
            
            // Stronger monochromatic glow from bottom
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                center: .bottom,
                startRadius: 0,
                endRadius: 520
            )
            .blur(radius: 36)
            .blendMode(.screen)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content based on selected tab
                Group {
                switch selectedTab {
                case 0:
                    HomeView(userName: userName)
                case 1:
                    ProgressView()
                case 2:
                    ForgeView()
                case 3:
                    ProfileView()
                default:
                    HomeView(userName: userName)
                }
                }
                .transition(.asymmetric(
                    insertion: selectedTab > previousTab ? 
                        .move(edge: .trailing).combined(with: .opacity) : 
                        .move(edge: .leading).combined(with: .opacity),
                    removal: selectedTab > previousTab ? 
                        .move(edge: .leading).combined(with: .opacity) : 
                        .move(edge: .trailing).combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                // Fixed Bottom Navigation
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack(spacing: 0) {
                        ForEach(0..<4) { index in
                            Button(action: {
                                previousTab = selectedTab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = index
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: bottomNavIcons[index])
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .white.opacity(0.7))
                                    
                                    Text(bottomNavLabels[index])
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Color.clear
                            .background(
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.black.opacity(0.1))
                                    .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: -2)
                                    .shadow(color: .white.opacity(0.05), radius: 16, x: 0, y: -4)
                            )
                    )
                }
            }
        }
    }
    
    private let bottomNavIcons = ["house.fill", "map.fill", "brain.head.profile", "person.fill"]
    private let bottomNavLabels = ["Home", "Journey", "Forge", "Profile"]
}

// Placeholder views for other tabs
struct ProgressView: View {
    var body: some View {
        VStack {
            Text("Your Journey")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text("Coming soon...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text("Coming soon...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
