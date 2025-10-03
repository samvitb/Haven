//
//  GroundingView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

struct GroundingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    @State private var seeItems: [String] = ["", "", "", "", ""]
    @State private var touchItems: [String] = ["", "", "", ""]
    @State private var hearItems: [String] = ["", "", ""]
    @State private var smellItems: [String] = ["", ""]
    @State private var tasteItems: [String] = [""]
    
    private let steps = [
        (count: 5, sense: "See", emoji: "👁️", prompt: "Name 5 things you can see"),
        (count: 4, sense: "Touch", emoji: "✋", prompt: "Describe 4 things you can touch"),
        (count: 3, sense: "Hear", emoji: "👂", prompt: "Name 3 things you can hear"),
        (count: 2, sense: "Smell", emoji: "👃", prompt: "Describe 2 things you smell"),
        (count: 1, sense: "Taste", emoji: "👅", prompt: "Describe 1 thing you taste")
    ]
    
    var body: some View {
        ZStack {
            // Noir background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
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
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("Grounding Exercise")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("5-4-3-2-1 Technique")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                if currentStep < steps.count {
                    // Current step content
                    VStack(spacing: 20) {
                        // Emoji icon
                        Text(steps[currentStep].emoji)
                            .font(.system(size: 60))
                            .shadow(color: Color.white.opacity(0.6), radius: 20, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(0.4), radius: 30, x: 0, y: 0)
                        
                        // Prompt
                        Text(steps[currentStep].prompt)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        // Input fields
                        VStack(spacing: 12) {
                            ForEach(0..<steps[currentStep].count, id: \.self) { index in
                                HStack {
                                    Text("\(index + 1).")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 25)
                                    
                                    TextField("Type here...", text: binding(for: currentStep, at: index))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
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
                        .padding(.horizontal, 24)
                        
                        // Progress indicator
                        HStack(spacing: 8) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                Circle()
                                    .fill(index <= currentStep ? Color.white : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                } else {
                    // Completion view
                    Spacer()
                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.green)
                        
                        VStack(spacing: 12) {
                            Text("Exercise Complete!")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("You've successfully grounded yourself using the 5-4-3-2-1 technique. Notice how you feel more present and calm.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                    }
                    Spacer()
                }
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentStep > 0 && currentStep < steps.count {
                        Button(action: previousStep) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
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
                    
                    Button(action: nextStep) {
                        HStack {
                            Text(currentStep >= steps.count ? "Finish" : "Next")
                                .font(.system(size: 16, weight: .semibold))
                            if currentStep < steps.count {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
                        )
                    }
                    .disabled(currentStep < steps.count && !canProceed())
                    .opacity(currentStep < steps.count && !canProceed() ? 0.5 : 1.0)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func binding(for step: Int, at index: Int) -> Binding<String> {
        switch step {
        case 0: return $seeItems[index]
        case 1: return $touchItems[index]
        case 2: return $hearItems[index]
        case 3: return $smellItems[index]
        case 4: return $tasteItems[index]
        default: return .constant("")
        }
    }
    
    private func canProceed() -> Bool {
        switch currentStep {
        case 0: return seeItems.allSatisfy { !$0.isEmpty }
        case 1: return touchItems.allSatisfy { !$0.isEmpty }
        case 2: return hearItems.allSatisfy { !$0.isEmpty }
        case 3: return smellItems.allSatisfy { !$0.isEmpty }
        case 4: return tasteItems.allSatisfy { !$0.isEmpty }
        default: return true
        }
    }
    
    private func nextStep() {
        if currentStep >= steps.count {
            // Save data and dismiss
            saveGroundingData()
            dismiss()
        } else {
            withAnimation {
                currentStep += 1
            }
        }
    }
    
    private func previousStep() {
        withAnimation {
            currentStep -= 1
        }
    }
    
    private func saveGroundingData() {
        // TODO: Save grounding data
        print("See: \(seeItems)")
        print("Touch: \(touchItems)")
        print("Hear: \(hearItems)")
        print("Smell: \(smellItems)")
        print("Taste: \(tasteItems)")
    }
}

#Preview {
    GroundingView()
}

