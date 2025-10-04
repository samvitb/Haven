//
//  ThoughtRecordView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

enum ThoughtRecordStep {
    case situation
    case thought
    case emotions
    case evidenceFor
    case evidenceAgainst
    case balancedThought
    case rateEmotions
    case completion
}

struct ThoughtRecordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: ThoughtRecordStep = .situation
    @State private var situation: String = ""
    @State private var automaticThought: String = ""
    @State private var emotions: String = ""
    @State private var initialIntensity: Double = 5.0
    @State private var evidenceFor: String = ""
    @State private var evidenceAgainst: String = ""
    @State private var balancedThought: String = ""
    @State private var finalIntensity: Double = 5.0
    @FocusState private var focusedField: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.06), Color.clear]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 420
            )
            .blur(radius: 28)
            .blendMode(.screen)
            .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                center: .top,
                startRadius: 0,
                endRadius: 520
            )
            .blur(radius: 36)
            .blendMode(.screen)
            .ignoresSafeArea()
            
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
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Thought Record")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Progress indicator
                        ProgressIndicatorView(currentStep: currentStep)
                        
                        // Step content
                        stepContentView()
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 120)
                }
                
                Spacer()
            }
            
            // Navigation buttons
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    if currentStep != .situation {
                        Button(action: previousStep) {
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    
                    if currentStep != .completion {
                        Button(action: nextStep) {
                            Text(currentStep == .rateEmotions ? "Finish" : "Next")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                                )
                        }
                        .disabled(!canProceed())
                        .opacity(canProceed() ? 1.0 : 0.5)
                    } else {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                                )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func stepContentView() -> some View {
        switch currentStep {
        case .situation:
            SituationStepView(situation: $situation, focusedField: $focusedField)
        case .thought:
            ThoughtStepView(automaticThought: $automaticThought, focusedField: $focusedField)
        case .emotions:
            EmotionsStepView(emotions: $emotions, intensity: $initialIntensity, focusedField: $focusedField)
        case .evidenceFor:
            EvidenceForStepView(evidenceFor: $evidenceFor, focusedField: $focusedField)
        case .evidenceAgainst:
            EvidenceAgainstStepView(evidenceAgainst: $evidenceAgainst, focusedField: $focusedField)
        case .balancedThought:
            BalancedThoughtStepView(balancedThought: $balancedThought, focusedField: $focusedField)
        case .rateEmotions:
            RateEmotionsStepView(finalIntensity: $finalIntensity)
        case .completion:
            CompletionStepView(initialIntensity: initialIntensity, finalIntensity: finalIntensity)
        }
    }
    
    private func canProceed() -> Bool {
        switch currentStep {
        case .situation:
            return !situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .thought:
            return !automaticThought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .emotions:
            return !emotions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .evidenceFor:
            return !evidenceFor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .evidenceAgainst:
            return !evidenceAgainst.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .balancedThought:
            return !balancedThought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .rateEmotions:
            return true
        case .completion:
            return true
        }
    }
    
    private func nextStep() {
        withAnimation {
            switch currentStep {
            case .situation:
                currentStep = .thought
            case .thought:
                currentStep = .emotions
            case .emotions:
                currentStep = .evidenceFor
            case .evidenceFor:
                currentStep = .evidenceAgainst
            case .evidenceAgainst:
                currentStep = .balancedThought
            case .balancedThought:
                currentStep = .rateEmotions
            case .rateEmotions:
                currentStep = .completion
            case .completion:
                break
            }
        }
    }
    
    private func previousStep() {
        withAnimation {
            switch currentStep {
            case .situation:
                break
            case .thought:
                currentStep = .situation
            case .emotions:
                currentStep = .thought
            case .evidenceFor:
                currentStep = .emotions
            case .evidenceAgainst:
                currentStep = .evidenceFor
            case .balancedThought:
                currentStep = .evidenceAgainst
            case .rateEmotions:
                currentStep = .balancedThought
            case .completion:
                currentStep = .rateEmotions
            }
        }
    }
}

struct ProgressIndicatorView: View {
    let currentStep: ThoughtRecordStep
    
    private let steps: [ThoughtRecordStep] = [.situation, .thought, .emotions, .evidenceFor, .evidenceAgainst, .balancedThought, .rateEmotions, .completion]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<steps.count, id: \.self) { index in
                if index < steps.count {
                    Circle()
                        .fill(steps[index] == currentStep || isStepCompleted(steps[index]) ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func isStepCompleted(_ step: ThoughtRecordStep) -> Bool {
        let currentIndex = steps.firstIndex(of: currentStep) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex < currentIndex
    }
}

// MARK: - Step Views

struct SituationStepView: View {
    @Binding var situation: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧠")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("What's the situation?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Describe the situation that triggered your negative thought. Where were you? What was happening?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            TextEditor(text: $situation)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct ThoughtStepView: View {
    @Binding var automaticThought: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💭")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("What's the thought?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("What negative or unhelpful thought went through your mind? Write it exactly as it appeared.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(alignment: .center, spacing: 8) {
                Text("Common thought patterns:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                
                Text("• All-or-nothing thinking\n• Catastrophizing\n• Mind reading\n• Should statements")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.03))
            )
            
            TextEditor(text: $automaticThought)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct EmotionsStepView: View {
    @Binding var emotions: String
    @Binding var intensity: Double
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(emotionEmoji())
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("How did you feel?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Name the emotions you felt. Examples: anxious, sad, angry, frustrated, ashamed")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            TextEditor(text: $emotions)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 100)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("How intense? (1-10)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Text("1")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Slider(value: $intensity, in: 1...10, step: 1)
                        .tint(.white)
                    
                    Text("10")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text("\(Int(intensity))/10")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
    
    private func emotionEmoji() -> String {
        if intensity <= 3 {
            return "😐"
        } else if intensity <= 6 {
            return "😟"
        } else {
            return "😰"
        }
    }
}

struct EvidenceForStepView: View {
    @Binding var evidenceFor: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📝")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Evidence FOR the thought")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("What facts support this thought? Stick to objective evidence only, not feelings.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            TextEditor(text: $evidenceFor)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct EvidenceAgainstStepView: View {
    @Binding var evidenceAgainst: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚖️")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Evidence AGAINST the thought")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("What facts contradict this thought? Consider alternative explanations.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(alignment: .center, spacing: 8) {
                Text("Questions to consider:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                
                Text("• What would I tell a friend?\n• What's another way to look at this?\n• What's happened before that contradicts this?")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.03))
            )
            
            TextEditor(text: $evidenceAgainst)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct BalancedThoughtStepView: View {
    @Binding var balancedThought: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✨")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Create a balanced thought")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Based on the evidence, what's a more balanced and realistic way to think about this?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(alignment: .center, spacing: 8) {
                Text("Tips:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                
                Text("• Include both supporting and contradicting evidence\n• Avoid absolute words (always, never)\n• Make it realistic, not overly positive")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.03))
            )
            
            TextEditor(text: $balancedThought)
                .focused($focusedField)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct RateEmotionsStepView: View {
    @Binding var finalIntensity: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(emotionEmoji())
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("How do you feel now?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("After examining the evidence and creating a balanced thought, rate your emotion intensity again.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Current intensity (1-10)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Text("1")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Slider(value: $finalIntensity, in: 1...10, step: 1)
                        .tint(.white)
                    
                    Text("10")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text("\(Int(finalIntensity))/10")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
    
    private func emotionEmoji() -> String {
        if finalIntensity <= 3 {
            return "😌"
        } else if finalIntensity <= 6 {
            return "😐"
        } else {
            return "😟"
        }
    }
}

struct CompletionStepView: View {
    let initialIntensity: Double
    let finalIntensity: Double
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 64))
                .padding(.top, 32)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Great Work!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("You've completed the thought record. This is a powerful skill that gets easier with practice.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Intensity comparison
            VStack(spacing: 16) {
                Text("Your Progress")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Before")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Text("\(Int(initialIntensity))/10")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    
                    VStack(spacing: 8) {
                        Text("After")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Text("\(Int(finalIntensity))/10")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(finalIntensity < initialIntensity ? .green : .white)
                    }
                }
                
                if finalIntensity < initialIntensity {
                    Text("Your intensity decreased by \(Int(initialIntensity - finalIntensity)) points! 🎯")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.1), radius: 12, x: 0, y: 0)
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Remember:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("• Practice this whenever you notice negative thoughts\n• The more you do it, the more automatic it becomes\n• Progress isn't always linear — that's okay")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.03))
            )
        }
        .padding(.horizontal, 24)
    }
}

