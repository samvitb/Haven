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
    
    var body: some View {
        if hasCompletedOnboarding && !userName.isEmpty {
            HomeView(userName: userName)
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

#Preview {
    ContentView()
}
