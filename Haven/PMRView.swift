//
//  PMRView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI
import UIKit

struct PMRView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: PMRStep = .welcome
    @State private var currentMuscleGroup: MuscleGroup = .toes
    @State private var currentExercisePhase: ExercisePhase = .tensing
    @State private var isRunning: Bool = false
    @State private var timeRemaining: Int = 0
    @State private var showBody: Bool = false
    @State private var vibrationTimer: Timer?
    @State private var userReflection: String = ""
    @State private var showReflectionInput: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    enum PMRStep: String, CaseIterable {
        case welcome = "Welcome"
        case instructions = "Instructions"
        case preparation = "Preparation"
        case exercise = "Exercise"
        case completion = "Completion"
    }
    
    enum ExercisePhase {
        case tensing, relaxing
    }
    
    enum MuscleGroup: String, CaseIterable {
        case toes = "Toes"
        case calves = "Calves"
        case thighs = "Thighs"
        case glutes = "Glutes"
        case abdomen = "Abdomen"
        case hands = "Hands"
        case arms = "Arms"
        case shoulders = "Shoulders"
        case neck = "Neck"
        case face = "Face"
        
        var instruction: String {
            switch self {
            case .toes: return "Tense your toes and feet"
            case .calves: return "Tense your calves and lower legs"
            case .thighs: return "Tense your thighs and upper legs"
            case .glutes: return "Tense your glutes and buttocks"
            case .abdomen: return "Tense your abdomen and core"
            case .hands: return "Tense your hands and fingers"
            case .arms: return "Tense your arms and biceps"
            case .shoulders: return "Tense your shoulders and upper back"
            case .neck: return "Tense your neck and jaw"
            case .face: return "Tense your face and forehead"
            }
        }
        
        var bodyPart: BodyPart {
            switch self {
            case .toes: return .feet
            case .calves: return .legs
            case .thighs: return .legs
            case .glutes: return .torso
            case .abdomen: return .torso
            case .hands: return .arms
            case .arms: return .arms
            case .shoulders: return .torso
            case .neck: return .head
            case .face: return .head
            }
        }
    }
    
    enum BodyPart: String, CaseIterable {
        case head = "Head"
        case torso = "Torso"
        case arms = "Arms"
        case legs = "Legs"
        case feet = "Feet"
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
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("Progressive Muscle Relaxation")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("PMR - Edmund Jacobson Technique")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Content based on current step
                Group {
                    switch currentStep {
                    case .welcome:
                        WelcomeView()
                    case .instructions:
                        InstructionsView()
                    case .preparation:
                        PreparationView()
                    case .exercise:
                        ExerciseView(
                            currentMuscleGroup: currentMuscleGroup,
                            currentExercisePhase: currentExercisePhase,
                            timeRemaining: timeRemaining,
                            showBody: showBody
                        )
                    case .completion:
                        CompletionView(
                            userReflection: $userReflection,
                            showReflectionInput: $showReflectionInput,
                            onSave: saveReflection
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Navigation buttons (hidden during exercise)
                if currentStep != .exercise {
                    HStack(spacing: 20) {
                        if currentStep != .welcome {
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
                                Text(currentStep == .completion ? "Finish" : "Next")
                                    .font(.system(size: 16, weight: .semibold))
                                if currentStep != .completion {
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
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 24)
        }
        .onReceive(timer) { _ in
            if isRunning && currentStep == .exercise {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    if currentExercisePhase == .tensing {
                        // Switch to relaxation phase
                        currentExercisePhase = .relaxing
                        timeRemaining = 5 // 5 seconds of relaxation
                        stopContinuousVibration() // Stop vibration during relaxation
                        
                        // Light vibration for relaxation transition
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    } else {
                        // Move to next muscle group
                        nextMuscleGroup()
                    }
                }
            }
        }
        .onAppear {
            // Prevent screen timeout during PMR exercise
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Re-enable screen timeout when leaving the exercise
            UIApplication.shared.isIdleTimerDisabled = false
            // Stop vibration when leaving the exercise
            stopContinuousVibration()
        }
    }
    
    private func nextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .instructions
        case .instructions:
            currentStep = .preparation
        case .preparation:
            currentStep = .exercise
            startExercise()
        case .exercise:
            currentStep = .completion
            isRunning = false
        case .completion:
            dismiss()
        }
    }
    
    private func previousStep() {
        switch currentStep {
        case .welcome:
            break
        case .instructions:
            currentStep = .welcome
        case .preparation:
            currentStep = .instructions
        case .exercise:
            currentStep = .preparation
            isRunning = false
        case .completion:
            currentStep = .exercise
            startExercise()
        }
    }
    
    private func startExercise() {
        isRunning = true
        currentMuscleGroup = .toes
        currentExercisePhase = .tensing
        timeRemaining = 15 // 15 seconds of tensing
        showBody = true
        startContinuousVibration()
    }
    
    private func startContinuousVibration() {
        // Stop any existing vibration timer
        stopContinuousVibration()
        
        // Create a timer that provides constant intense vibration during tensing
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if currentExercisePhase == .tensing {
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
            }
        }
    }
    
    private func stopContinuousVibration() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
    
    private func saveReflection() {
        // TODO: Save reflection to user data
        print("User reflection: \(userReflection)")
        dismiss()
    }
    
    private func nextMuscleGroup() {
        let allGroups = MuscleGroup.allCases
        if let currentIndex = allGroups.firstIndex(of: currentMuscleGroup) {
            if currentIndex < allGroups.count - 1 {
                currentMuscleGroup = allGroups[currentIndex + 1]
                currentExercisePhase = .tensing
                timeRemaining = 15 // 15 seconds of tensing
                startContinuousVibration() // Start vibration for new muscle group
                
                // Strong vibration when moving to next muscle group
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
                
                // Additional longer vibration sequence
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let impactFeedback2 = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback2.impactOccurred()
                }
            } else {
                currentStep = .completion
                isRunning = false
                stopContinuousVibration() // Stop vibration when exercise completes
            }
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                Text("Welcome to Progressive Muscle Relaxation")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("This technique helps reduce physical tension and stress by systematically tensing and relaxing muscle groups throughout your body.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
    }
}

// MARK: - Instructions View
struct InstructionsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.seated.side")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text("Getting Ready")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    InstructionItem(
                        icon: "bed.double.fill",
                        title: "Find a Comfortable Position",
                        description: "Lie down if possible, or sit in a comfortable chair"
                    )
                    
                    InstructionItem(
                        icon: "iphone",
                        title: "Place Your Device",
                        description: "Put your phone somewhere you can easily see the screen to follow the instructions"
                    )
                    
                    InstructionItem(
                        icon: "hand.raised.fill",
                        title: "Follow the Instructions",
                        description: "Tense each muscle group when prompted, your phone will vibrate"
                    )
                }
            }
        }
    }
}

struct InstructionItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preparation View
struct PreparationView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text("About This Exercise")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Text("We'll work through 10 muscle groups from your toes to your head. For each group:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 8) {
                        Text("1. Tense the muscle group for 15 seconds")
                        Text("2. Release and relax for 5 seconds")
                        Text("3. Move to the next muscle group")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
    }
}

// MARK: - Exercise View
struct ExerciseView: View {
    let currentMuscleGroup: PMRView.MuscleGroup
    let currentExercisePhase: PMRView.ExercisePhase
    let timeRemaining: Int
    let showBody: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            // Human body visualization
            if showBody {
                HumanBodyView(currentMuscleGroup: currentMuscleGroup)
                    .frame(height: 300)
            }
            
            // Current instruction
            VStack(spacing: 16) {
                if currentExercisePhase == .tensing {
                    Text(currentMuscleGroup.instruction)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Hold for \(timeRemaining) seconds")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                } else {
                    Text("Now relax and release")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Relax for \(timeRemaining) seconds")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            
            // Progress indicator
            VStack(spacing: 8) {
                Text("Progress")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                let currentIndex = PMRView.MuscleGroup.allCases.firstIndex(of: currentMuscleGroup) ?? 0
                let totalGroups = PMRView.MuscleGroup.allCases.count
                
                HStack(spacing: 4) {
                    ForEach(0..<totalGroups, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index <= currentIndex ? Color.white : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .frame(maxWidth: 200)
            }
        }
    }
}

// MARK: - Human Body View
struct HumanBodyView: View {
    let currentMuscleGroup: PMRView.MuscleGroup
    
    var body: some View {
        ZStack {
            // Display only the relevant body part for the current muscle group
            BodyPartView(muscleGroup: currentMuscleGroup)
        }
    }
}

// MARK: - Body Part View
struct BodyPartView: View {
    let muscleGroup: PMRView.MuscleGroup
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 250, height: 250)
                .blur(radius: 30)
            
            // Main glow
            Circle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 180, height: 180)
                .blur(radius: 20)
            
            // Emoji with glow
            Text(emojiIcon)
                .font(.system(size: emojiSize))
                .shadow(color: Color.white.opacity(0.6), radius: 20, x: 0, y: 0)
                .shadow(color: Color.white.opacity(0.4), radius: 30, x: 0, y: 0)
                .shadow(color: Color.white.opacity(0.2), radius: 40, x: 0, y: 0)
        }
    }
    
    private var emojiIcon: String {
        switch muscleGroup {
        case .toes:
            return "👣"
        case .calves:
            return "🦵"
        case .thighs:
            return "🦵"
        case .glutes:
            return "🍑"
        case .abdomen:
            return "🆎"
        case .hands:
            return "✋"
        case .arms:
            return "💪"
        case .shoulders:
            return "💪"
        case .neck:
            return "🧑"
        case .face:
            return "😊"
        }
    }
    
    private var emojiSize: CGFloat {
        switch muscleGroup {
        case .toes, .calves, .thighs:
            return 100
        case .glutes, .abdomen:
            return 110
        case .hands:
            return 90
        case .arms, .shoulders:
            return 100
        case .neck, .face:
            return 90
        }
    }
}

// Helper shape wrapper
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @Binding var userReflection: String
    @Binding var showReflectionInput: Bool
    let onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            if !showReflectionInput {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.green)
                
                VStack(spacing: 12) {
                    Text("Exercise Complete!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("You've successfully completed Progressive Muscle Relaxation. Notice how your body feels more relaxed and tension-free.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 16)
                }
                
                Button(action: {
                    withAnimation {
                        showReflectionInput = true
                    }
                }) {
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add Reflection")
                            .font(.system(size: 16, weight: .semibold))
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
                .padding(.top, 8)
            } else {
                VStack(spacing: 16) {
                    Text("How are you feeling?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Take a moment to reflect on your experience")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Text input
                    ZStack(alignment: .topLeading) {
                        if userReflection.isEmpty {
                            Text("Type your thoughts here...")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $userReflection)
                            .frame(height: 120)
                            .scrollContentBackground(.hidden)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Button(action: onSave) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Save & Finish")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
                        )
                    }
                    .disabled(userReflection.isEmpty)
                    .opacity(userReflection.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    PMRView()
}
