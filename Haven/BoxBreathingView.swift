//
//  BoxBreathingView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI
import UIKit

struct BoxBreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPhase: BreathingPhase = .inhale
    @State private var timeRemaining: Int = 4
    @State private var cycleCount: Int = 0
    @State private var isRunning: Bool = false
    @State private var isCompleted: Bool = false
    @State private var showCompletion: Bool = false
    @State private var userFeeling: String = ""
    @State private var showFeelingInput: Bool = false
    @State private var showStartButton: Bool = true
    
    private let totalCycles = 4
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    enum BreathingPhase: String, CaseIterable {
        case inhale = "Inhale"
        case hold1 = "Hold In"
        case exhale = "Exhale"
        case hold2 = "Hold Out"
        
        var instruction: String {
            switch self {
            case .inhale: return "Breathe in slowly"
            case .hold1: return "Hold your breath"
            case .exhale: return "Breathe out slowly"
            case .hold2: return "Hold your breath"
            }
        }
        
        var color: Color {
            switch self {
            case .inhale: return .green
            case .hold1: return .blue
            case .exhale: return .orange
            case .hold2: return .purple
            }
        }
    }
    
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
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 8) {
                    Text("Box Breathing")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Navy SEAL Technique")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                if !isCompleted {
                    // Animated Square Guide
                    VStack(spacing: 30) {
                        // Breathing Square with Tracing Animation
                        ZStack {
                            // Animated tracing square
                            BoxBreathingSquareView(currentPhase: currentPhase, isRunning: isRunning)
                        }
                        .frame(width: 200, height: 200)
                        
                        // Instructions
                        VStack(spacing: 16) {
                            Text(currentPhase.instruction)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("\(timeRemaining)")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(currentPhase.color)
                                .scaleEffect(isRunning ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isRunning)
                            
                            Text("seconds")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        // Progress
                        VStack(spacing: 8) {
                            Text("Cycle \(cycleCount + 1) of \(totalCycles)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 8) {
                                ForEach(0..<totalCycles, id: \.self) { index in
                                    Circle()
                                        .fill(index < cycleCount ? Color.white : Color.gray.opacity(0.3))
                                        .frame(width: 12, height: 12)
                                        .scaleEffect(index == cycleCount ? 1.2 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: cycleCount)
                                }
                            }
                        }
                    }
                    
                    // Start Button
                    if showStartButton {
                        Button(action: startExercise) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Start")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
                            )
                        }
                        .transition(.opacity)
                    }
                } else {
                    // Completion Screen
                    VStack(spacing: 30) {
                        // Success Icon
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 0)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        VStack(spacing: 16) {
                            Text("Exercise Complete!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Great job completing the Box Breathing exercise. How are you feeling now?")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        if showFeelingInput {
                            VStack(spacing: 16) {
                                TextField("How are you feeling?", text: $userFeeling, axis: .vertical)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    .lineLimit(3...6)
                                
                                Button(action: saveFeeling) {
                                    Text("Save & Finish")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
                                        )
                                }
                            }
                        } else {
                            Button(action: {
                                showFeelingInput = true
                            }) {
                                Text("Continue")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
                                    )
                            }
                        }
                        
                        // Action Buttons
                        HStack(spacing: 20) {
                            Button(action: {
                                resetExercise()
                                isCompleted = false
                                showFeelingInput = false
                                userFeeling = ""
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Do Again")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            Button(action: {
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Finish")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onReceive(timer) { _ in
            if isRunning && !isCompleted {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    nextPhase()
                }
            }
        }
        .onAppear {
            // Prevent screen timeout during breathing exercise
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Re-enable screen timeout when leaving the exercise
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    
    private func startExercise() {
        withAnimation(.easeOut(duration: 0.3)) {
            showStartButton = false
        }
        timeRemaining = 4
        currentPhase = .inhale
        cycleCount = 0
        
        // Start the exercise after a delay to show the full 4-second countdown
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isRunning = true
        }
    }
    
    
    private func resetExercise() {
        isRunning = false
        timeRemaining = 4
        currentPhase = .inhale
        cycleCount = 0
        isCompleted = false
        showFeelingInput = false
        userFeeling = ""
        showStartButton = true
    }
    
    private func nextPhase() {
        let phases = BreathingPhase.allCases
        if let currentIndex = phases.firstIndex(of: currentPhase) {
            if currentIndex < phases.count - 1 {
                // Move to next phase
                currentPhase = phases[currentIndex + 1]
                timeRemaining = 4
            } else {
                // Complete one cycle
                cycleCount += 1
                if cycleCount >= totalCycles {
                    // Exercise complete
                    isRunning = false
                    isCompleted = true
                } else {
                    // Start next cycle
                    currentPhase = .inhale
                    timeRemaining = 4
                }
            }
        }
    }
    
    private func saveFeeling() {
        // TODO: Save feeling to user data
        print("User feeling: \(userFeeling)")
        dismiss()
    }
}

struct BoxBreathingSquareView: View {
    let currentPhase: BoxBreathingView.BreathingPhase
    let isRunning: Bool
    @State private var tracingProgress: Double = 0.0
    
    var body: some View {
        ZStack {
            // Static square outline
            Rectangle()
                .stroke(Color.white.opacity(0.3), lineWidth: 6)
                .frame(width: 200, height: 200)
            
            // Animated ball that traces the square
            if isRunning {
                CircularTraceView(progress: tracingProgress, currentPhase: currentPhase)
            }
        }
        .onChange(of: currentPhase) { _ in
            if isRunning {
                tracingProgress = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 5.0)) {
                        tracingProgress = 1.0
                    }
                }
            }
        }
        .onChange(of: isRunning) { running in
            if running && currentPhase == .inhale {
                withAnimation(.linear(duration: 5.0)) {
                    tracingProgress = 1.0
                }
            } else if !running {
                tracingProgress = 0.0
            }
        }
    }
    
}

struct CircularTraceView: View {
    let progress: Double
    let currentPhase: BoxBreathingView.BreathingPhase
    
    private var ballPosition: CGPoint {
        let squareSize: CGFloat = 200
        let halfSize = squareSize / 2
        
        switch currentPhase {
        case .inhale:
            // Top edge: left to right
            let x = -halfSize + (squareSize * progress)
            return CGPoint(x: x, y: -halfSize)
            
        case .hold1:
            // Right edge: top to bottom
            let y = -halfSize + (squareSize * progress)
            return CGPoint(x: halfSize, y: y)
            
        case .exhale:
            // Bottom edge: right to left
            let x = halfSize - (squareSize * progress)
            return CGPoint(x: x, y: halfSize)
            
        case .hold2:
            // Left edge: bottom to top
            let y = halfSize - (squareSize * progress)
            return CGPoint(x: -halfSize, y: y)
        }
    }
    
    private var ballColor: Color {
        switch currentPhase {
        case .inhale: return .green
        case .hold1: return .blue
        case .exhale: return .orange
        case .hold2: return .purple
        }
    }
    
    var body: some View {
        Circle()
            .fill(ballColor)
            .frame(width: 16, height: 16)
            .offset(x: ballPosition.x, y: ballPosition.y)
            .shadow(color: ballColor.opacity(0.8), radius: 12, x: 0, y: 0)
            .shadow(color: ballColor.opacity(0.4), radius: 24, x: 0, y: 0)
            .shadow(color: ballColor.opacity(0.2), radius: 36, x: 0, y: 0)
    }
}

#Preview {
    BoxBreathingView()
}
