//
//  GratitudeView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

struct GratitudeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    @State private var goodThings: [String] = ["", "", ""]
    @State private var whyMatters: [String] = ["", "", ""]
    @FocusState private var focusedField: Field?
    
    private let totalSteps = 3
    
    enum Field {
        case goodThing, whyMatters
    }
    
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
                    Text("Gratitude Practice")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("3 Good Things")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                if currentStep < totalSteps {
                    // Current entry
                    VStack(spacing: 24) {
                        // Heart emoji
                        Text("❤️")
                            .font(.system(size: 60))
                            .shadow(color: Color.white.opacity(0.6), radius: 20, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(0.4), radius: 30, x: 0, y: 0)
                        
                        // Step indicator
                        Text("Good Thing \(currentStep + 1) of \(totalSteps)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Input fields
                        VStack(spacing: 20) {
                            // What happened
                            VStack(alignment: .leading, spacing: 8) {
                                Text("What happened?")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ZStack(alignment: .topLeading) {
                                    if goodThings[currentStep].isEmpty {
                                        Text("Describe something good that happened today...")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    TextEditor(text: $goodThings[currentStep])
                                        .frame(height: 100)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                        .focused($focusedField, equals: .goodThing)
                                }
                            }
                            
                            // Why it matters
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Why does it matter?")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ZStack(alignment: .topLeading) {
                                    if whyMatters[currentStep].isEmpty {
                                        Text("Explain why this is meaningful to you...")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    TextEditor(text: $whyMatters[currentStep])
                                        .frame(height: 100)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                        .focused($focusedField, equals: .whyMatters)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Progress indicator
                        HStack(spacing: 8) {
                            ForEach(0..<totalSteps, id: \.self) { index in
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
                            Text("Practice Complete!")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("You've recorded 3 good things that happened today. Regular gratitude practice has been shown to boost happiness and lower depressive symptoms.")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                    }
                    Spacer()
                }
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentStep > 0 && currentStep < totalSteps {
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
                            Text(currentStep >= totalSteps ? "Finish" : "Next")
                                .font(.system(size: 16, weight: .semibold))
                            if currentStep < totalSteps {
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
                    .disabled(currentStep < totalSteps && !canProceed())
                    .opacity(currentStep < totalSteps && !canProceed() ? 0.5 : 1.0)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func canProceed() -> Bool {
        return !goodThings[currentStep].isEmpty && !whyMatters[currentStep].isEmpty
    }
    
    private func nextStep() {
        if currentStep >= totalSteps {
            // Save data and dismiss
            saveGratitudeData()
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
    
    private func saveGratitudeData() {
        // TODO: Save gratitude data
        for i in 0..<totalSteps {
            print("Good Thing \(i + 1): \(goodThings[i])")
            print("Why it matters: \(whyMatters[i])")
        }
    }
}

#Preview {
    GratitudeView()
}

