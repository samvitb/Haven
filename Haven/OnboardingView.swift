//
//  OnboardingView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var userName = ""
    @State private var userAge = 18
    @State private var selectedOccupation = ""
    
    private let occupations = [
        "Student", "Software Engineer", "Teacher", "Healthcare Worker", "Construction Worker",
        "Sales Representative", "Manager", "Engineer", "Designer", "Consultant", "Veteran",
        "First Responder", "Military", "Police Officer", "Firefighter", "Nurse", "Doctor",
        "Lawyer", "Accountant", "Artist", "Writer", "Chef", "Mechanic", "Electrician",
        "Plumber", "Retail Worker", "Customer Service", "Driver", "Delivery Driver",
        "Security Guard", "Janitor", "Maintenance Worker", "Unemployed", "Freelancer",
        "Entrepreneur", "Business Owner", "Real Estate Agent", "Insurance Agent",
        "Financial Advisor", "Marketing Professional", "HR Professional", "Administrative Assistant",
        "Receptionist", "Data Analyst", "Project Manager", "Product Manager", "Other"
    ]
    
    var body: some View {
        ZStack {
            // Noir background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                HStack {
                    ForEach(0..<4, id: \.self) { index in
                        Rectangle()
                            .fill(index <= currentStep ? Color.white : Color.gray.opacity(0.3))
                            .frame(height: 2)
                            .shadow(color: index <= currentStep ? .white.opacity(0.4) : .clear, radius: 4, x: 0, y: 0)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Spacer()
                
                // Content based on current step
                Group {
                    switch currentStep {
                    case 0:
                        WelcomeScreenView(currentStep: $currentStep)
                    case 1:
                        NameInputView(userName: $userName, currentStep: $currentStep)
                    case 2:
                        AgeInputView(userAge: $userAge, currentStep: $currentStep)
                    case 3:
                        OccupationSelectionView(selectedOccupation: $selectedOccupation, occupations: occupations, currentStep: $currentStep, userName: userName, userAge: userAge)
                    default:
                        WelcomeScreenView(currentStep: $currentStep)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.5), value: currentStep)
                
                Spacer()
            }
        }
    }
}

struct WelcomeScreenView: View {
    @Binding var currentStep: Int
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            // App icon/logo placeholder
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.15), radius: 12, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.08), radius: 24, x: 0, y: 0)
                
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
            }
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            
            VStack(spacing: 20) {
                Text("Welcome to Haven")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your Mental Fitness Space")
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                // Get Started Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = 1
                    }
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                            .shadow(color: .white.opacity(0.1), radius: 16, x: 0, y: 0)
                    )
                }
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.1), value: currentStep)
                
                // Learn More Button
                Button(action: {
                    // TODO: Show modal with mission & privacy info
                }) {
                    Text("Learn More")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .underline()
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct NameInputView: View {
    @Binding var userName: String
    @Binding var currentStep: Int
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text("What's your name?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We'll use this to personalize your experience")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                TextField("Enter your name", text: $userName)
                    .font(.system(size: 18, weight: .medium))
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
                            .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 0)
                    )
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep = 2
                            }
                        }
                    }
                
                Button(action: {
                    if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 2
                        }
                    }
                }) {
                    HStack {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.white)
                            .shadow(color: userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .clear : .white.opacity(0.3), radius: 8, x: 0, y: 0)
                            .shadow(color: userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .clear : .white.opacity(0.1), radius: 16, x: 0, y: 0)
                    )
                }
                .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

struct AgeInputView: View {
    @Binding var userAge: Int
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text("How old are you?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("This helps us provide age-appropriate resources")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                // Age picker with custom styling
                Picker("Age", selection: $userAge) {
                    ForEach(15...80, id: \.self) { age in
                        Text("\(age)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .tag(age)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 120)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                )
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = 3
                    }
                }) {
                    HStack {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                            .shadow(color: .white.opacity(0.1), radius: 16, x: 0, y: 0)
                    )
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct OccupationSelectionView: View {
    @Binding var selectedOccupation: String
    let occupations: [String]
    @Binding var currentStep: Int
    let userName: String
    let userAge: Int
    @State private var searchText = ""
    
    private var filteredOccupations: [String] {
        if searchText.isEmpty {
            return occupations
        } else {
            return occupations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                Text("What do you do?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Help us tailor your mental fitness journey")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search occupations...", text: $searchText)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 0)
                )
                
                // Occupation list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredOccupations, id: \.self) { occupation in
                            Button(action: {
                                selectedOccupation = occupation
                            }) {
                                HStack {
                                    Text(occupation)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if selectedOccupation == occupation {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedOccupation == occupation ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedOccupation == occupation ? Color.white.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .shadow(color: selectedOccupation == occupation ? .white.opacity(0.2) : .clear, radius: 6, x: 0, y: 0)
                                        .shadow(color: selectedOccupation == occupation ? .white.opacity(0.1) : .clear, radius: 12, x: 0, y: 0)
                                )
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
                
                // Continue button
                Button(action: {
                    if !selectedOccupation.isEmpty {
                        // TODO: Complete onboarding and navigate to main app
                        print("Onboarding completed for \(userName), age \(userAge), occupation: \(selectedOccupation)")
                    }
                }) {
                    HStack {
                        Text("Complete Setup")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOccupation.isEmpty ? Color.gray : Color.white)
                            .shadow(color: selectedOccupation.isEmpty ? .clear : .white.opacity(0.3), radius: 8, x: 0, y: 0)
                            .shadow(color: selectedOccupation.isEmpty ? .clear : .white.opacity(0.1), radius: 16, x: 0, y: 0)
                    )
                }
                .disabled(selectedOccupation.isEmpty)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView()
}
