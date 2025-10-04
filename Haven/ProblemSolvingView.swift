//
//  ProblemSolvingView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

enum ProblemSolvingStep {
    case intro
    case defineProblem
    case setPriority
    case brainstorm
    case evaluate
    case actionPlan
    case completion
}

struct Solution: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var pros: String = ""
    var cons: String = ""
    var rating: Int = 0
}

struct ProblemSolvingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: ProblemSolvingStep = .intro
    @State private var problemDescription: String = ""
    @State private var priority: Double = 5.0
    @State private var solutions: [Solution] = []
    @State private var newSolutionText: String = ""
    @State private var selectedSolution: Solution?
    @State private var actionSteps: String = ""
    @State private var deadline: String = ""
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
                    
                    Text("Problem-Solving")
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
                        if currentStep != .intro {
                            PSTProgressIndicatorView(currentStep: currentStep)
                        }
                        
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
                    if shouldShowBackButton() {
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
                            Text(nextButtonText())
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
        case .intro:
            IntroStepView()
        case .defineProblem:
            DefineProblemStepView(problemDescription: $problemDescription, focusedField: $focusedField)
        case .setPriority:
            SetPriorityStepView(priority: $priority)
        case .brainstorm:
            BrainstormStepView(
                solutions: $solutions,
                newSolutionText: $newSolutionText,
                focusedField: $focusedField
            )
        case .evaluate:
            EvaluateStepView(
                solutions: $solutions,
                selectedSolution: $selectedSolution,
                focusedField: $focusedField
            )
        case .actionPlan:
            ActionPlanStepView(
                selectedSolution: $selectedSolution,
                actionSteps: $actionSteps,
                deadline: $deadline,
                focusedField: $focusedField
            )
        case .completion:
            PSTCompletionStepView(
                problem: problemDescription,
                solution: selectedSolution?.text ?? "",
                actionSteps: actionSteps
            )
        }
    }
    
    private func shouldShowBackButton() -> Bool {
        return currentStep != .intro && currentStep != .completion
    }
    
    private func nextButtonText() -> String {
        switch currentStep {
        case .intro:
            return "Start"
        case .actionPlan:
            return "Finish"
        default:
            return "Next"
        }
    }
    
    private func canProceed() -> Bool {
        switch currentStep {
        case .intro:
            return true
        case .defineProblem:
            return !problemDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .setPriority:
            return true
        case .brainstorm:
            return solutions.count >= 2
        case .evaluate:
            return selectedSolution != nil
        case .actionPlan:
            return !actionSteps.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !deadline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .completion:
            return true
        }
    }
    
    private func nextStep() {
        withAnimation {
            switch currentStep {
            case .intro:
                currentStep = .defineProblem
            case .defineProblem:
                currentStep = .setPriority
            case .setPriority:
                currentStep = .brainstorm
            case .brainstorm:
                currentStep = .evaluate
            case .evaluate:
                currentStep = .actionPlan
            case .actionPlan:
                currentStep = .completion
            case .completion:
                break
            }
        }
    }
    
    private func previousStep() {
        withAnimation {
            switch currentStep {
            case .intro:
                break
            case .defineProblem:
                currentStep = .intro
            case .setPriority:
                currentStep = .defineProblem
            case .brainstorm:
                currentStep = .setPriority
            case .evaluate:
                currentStep = .brainstorm
            case .actionPlan:
                currentStep = .evaluate
            case .completion:
                currentStep = .actionPlan
            }
        }
    }
}

struct PSTProgressIndicatorView: View {
    let currentStep: ProblemSolvingStep
    
    private let steps: [ProblemSolvingStep] = [.defineProblem, .setPriority, .brainstorm, .evaluate, .actionPlan, .completion]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<steps.count, id: \.self) { index in
                Circle()
                    .fill(steps[index] == currentStep || isStepCompleted(steps[index]) ? Color.white : Color.white.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func isStepCompleted(_ step: ProblemSolvingStep) -> Bool {
        let currentIndex = steps.firstIndex(of: currentStep) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex < currentIndex
    }
}

// MARK: - Step Views

struct IntroStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("💡")
                .font(.system(size: 64))
                .padding(.top, 32)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Problem-Solving Therapy")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("A structured approach to tackle problems that feel overwhelming.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("You'll learn to:")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                StepItemView(number: "1", text: "Clearly define the problem")
                StepItemView(number: "2", text: "Brainstorm multiple solutions")
                StepItemView(number: "3", text: "Evaluate pros and cons")
                StepItemView(number: "4", text: "Create an action plan")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.1), radius: 12, x: 0, y: 0)
            )
            
            Text("This takes about 10-15 minutes. Find a quiet place where you can focus.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)
        }
    }
}

struct StepItemView: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.white)
                )
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct DefineProblemStepView: View {
    @Binding var problemDescription: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Define the problem")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Describe the problem clearly and specifically. What exactly is the issue you want to solve?")
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
                
                Text("• Be specific, not vague\n• Focus on one problem at a time\n• State it as a challenge to solve, not a catastrophe")
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
            
            TextEditor(text: $problemDescription)
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

struct SetPriorityStepView: View {
    @Binding var priority: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(priorityEmoji())
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("How urgent is this?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Rate how important it is to solve this problem right now.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Text("1")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Slider(value: $priority, in: 1...10, step: 1)
                        .tint(.white)
                    
                    Text("10")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text("\(Int(priority))/10")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(priorityDescription())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(20)
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
    
    private func priorityEmoji() -> String {
        if priority <= 3 {
            return "😌"
        } else if priority <= 6 {
            return "🤔"
        } else {
            return "🚨"
        }
    }
    
    private func priorityDescription() -> String {
        if priority <= 3 {
            return "Low urgency - you have time to think this through"
        } else if priority <= 6 {
            return "Moderate urgency - worth addressing soon"
        } else {
            return "High urgency - needs attention now"
        }
    }
}

struct BrainstormStepView: View {
    @Binding var solutions: [Solution]
    @Binding var newSolutionText: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🌟")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Brainstorm solutions")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Come up with at least 2-3 possible solutions. Don't judge them yet — just get ideas out!")
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
                
                Text("• Think creatively\n• Include both practical and ambitious ideas\n• Ask: what would I tell a friend?")
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
            
            // Add solution field
            HStack(spacing: 12) {
                TextField("Type a solution...", text: $newSolutionText)
                    .focused($focusedField)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                
                Button(action: addSolution) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
                .disabled(newSolutionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(newSolutionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.3 : 1.0)
            }
            
            // Solutions list
            if solutions.isEmpty {
                Text("No solutions yet. Add at least 2 to continue.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(solutions.enumerated()), id: \.element.id) { index, solution in
                        HStack {
                            Text("\(index + 1).")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            Text(solution.text)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                solutions.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red.opacity(0.7))
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
    
    private func addSolution() {
        let trimmed = newSolutionText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            solutions.append(Solution(text: trimmed))
            newSolutionText = ""
        }
    }
}

struct EvaluateStepView: View {
    @Binding var solutions: [Solution]
    @Binding var selectedSolution: Solution?
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚖️")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Evaluate solutions")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("For each solution, think about pros and cons. Then pick the best one to try first.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            VStack(spacing: 16) {
                ForEach(solutions.indices, id: \.self) { index in
                    SolutionEvaluationCard(
                        solution: $solutions[index],
                        isSelected: selectedSolution?.id == solutions[index].id,
                        onSelect: {
                            selectedSolution = solutions[index]
                        },
                        focusedField: $focusedField
                    )
                }
            }
        }
    }
}

struct SolutionEvaluationCard: View {
    @Binding var solution: Solution
    let isSelected: Bool
    let onSelect: () -> Void
    @FocusState.Binding var focusedField: Bool
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Solution header
            HStack {
                Text(solution.text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Pros
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Pros:")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                        
                        TextEditor(text: $solution.pros)
                            .focused($focusedField)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .frame(height: 60)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.03))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Cons
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Cons:")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.red)
                        
                        TextEditor(text: $solution.cons)
                            .focused($focusedField)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .frame(height: 60)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.03))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Select button
                    Button(action: onSelect) {
                        HStack {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 18, weight: .semibold))
                            Text(isSelected ? "Selected" : "Select This Solution")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(isSelected ? .green : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected ? Color.green.opacity(0.2) : Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(isSelected ? Color.green : Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(isSelected ? 0.08 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                )
        )
    }
}

struct ActionPlanStepView: View {
    @Binding var selectedSolution: Solution?
    @Binding var actionSteps: String
    @Binding var deadline: String
    @FocusState.Binding var focusedField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📋")
                .font(.system(size: 48))
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("Create action plan")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Break down your chosen solution into specific, actionable steps.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            // Selected solution
            if let solution = selectedSolution {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your solution:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(solution.text)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            // Action steps
            VStack(alignment: .leading, spacing: 8) {
                Text("Action steps:")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("What specific steps will you take?")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                TextEditor(text: $actionSteps)
                    .focused($focusedField)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
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
            
            // Deadline
            VStack(alignment: .leading, spacing: 8) {
                Text("When will you start?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("e.g., Tomorrow morning, This weekend", text: $deadline)
                    .focused($focusedField)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
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
}

struct PSTCompletionStepView: View {
    let problem: String
    let solution: String
    let actionSteps: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 64))
                .padding(.top, 32)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            Text("You've Got a Plan!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("You've completed problem-solving therapy. You now have a clear action plan.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Summary
            VStack(spacing: 16) {
                SummarySection(title: "Problem", content: problem, icon: "exclamationmark.circle.fill")
                SummarySection(title: "Solution", content: solution, icon: "lightbulb.fill")
                SummarySection(title: "Action Steps", content: actionSteps, icon: "list.bullet")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Next steps:")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("• Follow through on your action plan\n• Review your progress after a few days\n• Adjust if needed — problem-solving is flexible\n• Celebrate small wins along the way")
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

struct SummarySection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

