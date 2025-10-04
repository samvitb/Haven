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
        Group {
            if hasCompletedOnboarding && !userName.isEmpty {
                MainTabView(userName: userName, selectedTab: $selectedTab)
            } else {
                OnboardingView(
                    onComplete: { name in
                        userName = name
                        hasCompletedOnboarding = true
                        saveOnboardingData(name: name)
                    }
                )
            }
        }
        .onAppear {
            loadOnboardingData()
        }
    }
    
    // MARK: - UserDefaults Persistence
    
    private func loadOnboardingData() {
        let profile = UserProfileManager.loadProfile()
        
        if let name = profile.name, !name.isEmpty, profile.hasCompleted {
            userName = name
            hasCompletedOnboarding = true
        }
    }
    
    private func saveOnboardingData(name: String) {
        // Save is now handled in OnboardingView with full profile data
        // This is kept for backwards compatibility
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
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
                
                // Blur zone at bottom (covers area where nav bar sits)
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Gradient overlay to darken content underneath
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.clear, location: 0.0),
                                        .init(color: Color.black.opacity(0.5), location: 0.3),
                                        .init(color: Color.black.opacity(0.8), location: 0.7),
                                        .init(color: Color.black.opacity(0.9), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Blur effect
                        Rectangle()
                            .fill(Color.white.opacity(0.001))
                            .background(.ultraThinMaterial)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.clear, location: 0.0),
                                        .init(color: Color.white.opacity(0.5), location: 0.2),
                                        .init(color: Color.white, location: 0.4),
                                        .init(color: Color.white, location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(height: 140)
                    .allowsHitTesting(false)
                }
                .ignoresSafeArea()
                
                // Floating Navigation Bar - Completely separate from content
                VStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        ForEach(0..<4, id: \.self) { index in
                            Button(action: {
                                previousTab = selectedTab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = index
                                }
                            }) {
                                VStack(spacing: 2) {
                                    Image(systemName: bottomNavIcons[index])
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .gray.opacity(0.7))
                                    
                                    Text(bottomNavLabels[index])
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(selectedTab == index ? .white : .gray.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                                .background(
                                    ZStack {
                                        if selectedTab == index {
                                            // Glassy background with blur
                                            Capsule()
                                                .fill(Color.white.opacity(0.15))
                                                .background(
                                                    Capsule()
                                                        .fill(.ultraThinMaterial)
                                                )
                                                .overlay(
                                                    Capsule()
                                                        .stroke(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [
                                                                    Color.white.opacity(0.4),
                                                                    Color.white.opacity(0.1)
                                                                ]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            ),
                                                            lineWidth: 1
                                                        )
                                                )
                                                .shadow(color: Color.white.opacity(0.2), radius: 4, x: 0, y: 0)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                Color.black.opacity(0.3)
                            )
                            .overlay(
                                Capsule()
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
    @State private var showResetConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Profile")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                // User info section
                VStack(spacing: 16) {
                    if let name = UserProfileManager.userName {
                        ProfileInfoRow(label: "Name", value: name, icon: "person.fill")
                    }
                    
                    if let age = UserProfileManager.userAge {
                        ProfileInfoRow(label: "Age", value: "\(age)", icon: "calendar")
                    }
                    
                    if let occupation = UserProfileManager.userOccupation {
                        ProfileInfoRow(label: "Occupation", value: occupation, icon: "briefcase.fill")
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 40)
                
                // Reset profile button (for testing/future customization)
                Button(action: {
                    showResetConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Reset Profile")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 24)
                
                Text("This will clear all your data and return you to onboarding.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Reset Profile?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                UserProfileManager.clearProfile()
                // Force app restart by exiting
                exit(0)
            }
        } message: {
            Text("This will delete all your profile data and you'll need to complete onboarding again. This action cannot be undone.")
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.05), radius: 8, x: 0, y: 0)
        )
    }
}

#Preview {
    ContentView()
}
