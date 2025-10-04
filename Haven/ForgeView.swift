//
//  ForgeView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI

struct ForgeView: View {
    @State private var selectedExercise: Exercise? = nil
    @State private var showBoxBreathing: Bool = false
    
    private let exercises = [
        Exercise(
            id: 1,
            title: "Box Breathing",
            subtitle: "Navy SEAL Technique",
            icon: "square.stack.3d.up.fill",
            shortDescription: "4-4-4-4 breathing pattern for stress regulation",
            fullDescription: "Box Breathing (Navy SEAL Technique)",
            benefits: "Activates parasympathetic nervous system, reduces cortisol, improves focus",
            howItWorks: "Inhale for 4 sec → hold 4 sec → exhale 4 sec → hold 4 sec → repeat",
            backedBy: "US Navy, stress regulation research",
            appFeature: "Animated square guide with calming visuals + audio pacing"
        ),
        Exercise(
            id: 2,
            title: "Progressive Muscle Relaxation",
            subtitle: "PMR",
            icon: "figure.strengthtraining.traditional",
            shortDescription: "Tense and release muscle groups from toes to head",
            fullDescription: "Progressive Muscle Relaxation (PMR)",
            benefits: "Reduces physical tension linked to stress/anxiety, improves body awareness",
            howItWorks: "Tense and release muscle groups from toes → head",
            backedBy: "Edmund Jacobson, widely used in CBT",
            appFeature: "Guided voice walkthrough; vibration feedback on phone for timing"
        ),
        Exercise(
            id: 3,
            title: "Grounding Technique",
            subtitle: "5-4-3-2-1 Method",
            icon: "hand.tap.fill",
            shortDescription: "Identify 5 things you see, 4 touch, 3 hear, 2 smell, 1 taste",
            fullDescription: "Grounding with the 5–4–3–2–1 Technique",
            benefits: "Stops spiraling thoughts, reduces panic attacks",
            howItWorks: "Identify 5 things you see, 4 touch, 3 hear, 2 smell, 1 taste",
            backedBy: "Cognitive behavioral therapy (CBT)",
            appFeature: "Interactive checklist with calming background sounds (nature, city, ocean)"
        ),
        Exercise(
            id: 4,
            title: "Gratitude Practice",
            subtitle: "3 Good Things",
            icon: "heart.fill",
            shortDescription: "List 3 good things that happened today and why they matter",
            fullDescription: "Gratitude Practice (3 Good Things)",
            benefits: "Shown to boost happiness and lower depressive symptoms for weeks",
            howItWorks: "List 3 good things that happened today and why they matter",
            backedBy: "Martin Seligman's positive psychology",
            appFeature: "Daily push at night, store entries in a \"gratitude log\" with visual growth chart"
        ),
        Exercise(
            id: 5,
            title: "Thought Record",
            subtitle: "Cognitive Restructuring",
            icon: "brain.head.profile",
            shortDescription: "Identify and challenge negative thoughts with evidence",
            fullDescription: "Thought Record (Cognitive Restructuring)",
            benefits: "Reduces depression and anxiety, improves emotional regulation, increases balanced thinking",
            howItWorks: "Identify negative thought → Examine evidence for/against → Create balanced alternative thought",
            backedBy: "Aaron Beck's Cognitive Behavioral Therapy (CBT)",
            appFeature: "Guided prompts with thought patterns library and reframing suggestions"
        ),
        Exercise(
            id: 6,
            title: "Problem-Solving Therapy",
            subtitle: "PST",
            icon: "lightbulb.fill",
            shortDescription: "Structured approach to tackle problems systematically",
            fullDescription: "Problem-Solving Therapy (PST)",
            benefits: "Increases sense of control, reduces hopelessness, improves coping skills",
            howItWorks: "Define problem → Brainstorm solutions → Evaluate options → Create action plan → Review results",
            backedBy: "Nezu & Nezu's research on depression treatment",
            appFeature: "Step-by-step guided problem-solving framework with action tracking"
        ),
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        HStack {
                            Text("The Forge")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        Text("Build your mental strength")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Exercise Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(exercises) { exercise in
                            ExerciseCardView(exercise: exercise) {
                                selectedExercise = exercise
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100) // Space for bottom nav
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedExercise != nil },
            set: { if !$0 { selectedExercise = nil } }
        )) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise)
            }
        }
    }
}

struct ExerciseCardView: View {
    let exercise: Exercise
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon
                Image(systemName: exercise.icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(.white)
                    .frame(height: 40)
                
                // Title and subtitle
                VStack(spacing: 4) {
                    Text(exercise.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(exercise.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                // Description
                Text(exercise.shortDescription)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.2), radius: 12, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.1), radius: 24, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.05), radius: 36, x: 0, y: 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    @State private var showBoxBreathing: Bool = false
    @State private var showPMR: Bool = false
    @State private var showGrounding: Bool = false
    @State private var showGratitude: Bool = false
    @State private var showThoughtRecord: Bool = false
    @State private var showProblemSolving: Bool = false
    
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        // Icon
                        Image(systemName: exercise.icon)
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(.white)
                            .frame(height: 60)
                        
                        // Title and subtitle
                        VStack(spacing: 8) {
                            Text(exercise.fullDescription)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Backed by: \(exercise.backedBy)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Content sections
                    VStack(spacing: 20) {
                        // How it works
                        DetailSectionView(
                            title: "How it works",
                            content: exercise.howItWorks,
                            icon: "play.circle.fill"
                        )
                        
                        // Benefits
                        DetailSectionView(
                            title: "Benefits",
                            content: exercise.benefits,
                            icon: "heart.circle.fill"
                        )
                        
                        // App Feature
                        DetailSectionView(
                            title: "App Feature",
                            content: exercise.appFeature,
                            icon: "sparkles"
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Start Exercise Button
                    Button(action: {
                        if exercise.id == 1 { // Box Breathing
                            showBoxBreathing = true
                        } else if exercise.id == 2 { // PMR
                            showPMR = true
                        } else if exercise.id == 3 { // Grounding
                            showGrounding = true
                        } else if exercise.id == 4 { // Gratitude
                            showGratitude = true
                        } else if exercise.id == 5 { // Thought Record
                            showThoughtRecord = true
                        } else if exercise.id == 6 { // Problem-Solving Therapy
                            showProblemSolving = true
                        }
                    }) {
                        HStack {
                            Text("Start Exercise")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .white.opacity(0.5), radius: 12, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.3), radius: 24, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.1), radius: 36, x: 0, y: 0)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showBoxBreathing) {
            BoxBreathingView()
        }
        .sheet(isPresented: $showPMR) {
            PMRView()
        }
        .sheet(isPresented: $showGrounding) {
            GroundingView()
        }
        .sheet(isPresented: $showGratitude) {
            GratitudeView()
        }
        .sheet(isPresented: $showThoughtRecord) {
            ThoughtRecordView()
        }
        .sheet(isPresented: $showProblemSolving) {
            ProblemSolvingView()
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: 0)
        )
    }
}

struct Exercise: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let shortDescription: String
    let fullDescription: String
    let benefits: String
    let howItWorks: String
    let backedBy: String
    let appFeature: String
}

#Preview {
    ForgeView()
}
