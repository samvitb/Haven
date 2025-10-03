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
            
            ZStack {
                // Full-screen content with horizontal swipe navigation
                TabView(selection: $selectedTab) {
                    HomeView(userName: userName)
                        .tag(0)
                    
                    ProgressView()
                        .tag(1)
                    
                    ForgeView()
                        .tag(2)
                    
                    ProfileView()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                .ignoresSafeArea(.all, edges: [.top, .bottom])
                
                // Floating Navigation Bar - Completely separate from content
                VStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { index in
                            Button(action: {
                                previousTab = selectedTab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = index
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: bottomNavIcons[index])
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .gray.opacity(0.7))
                                    
                                    Text(bottomNavLabels[index])
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .gray.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedTab == index ? Color.white.opacity(0.2) : Color.clear)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.black.opacity(0.3)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .shadow(color: Color.white.opacity(0.1), radius: 15, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(0.05), radius: 25, x: 0, y: 0)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8) // Moved much closer to bottom
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
