//
//  HomeView.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import SwiftUI
import Charts

struct HomeView: View {
    let userName: String
    @State private var emotionValue: Double = 5.0
    @State private var stressValue: Double = 5.0
    @State private var hasCompletedToday = false
    @State private var weeklyStressData: [StressDataPoint] = []
    @State private var showResetExercise = false
    
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
            
            // Stronger monochromatic glow from top (subtler opacity)
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                center: .top,
                startRadius: 0,
                endRadius: 520
            )
            .blur(radius: 36)
            .blendMode(.screen)
            .ignoresSafeArea()
            
            // Stronger monochromatic glow from bottom (subtler opacity)
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
                    // Welcome Header
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Welcome, \(userName)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("How are you feeling today?")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Date indicator
                        Text(Date().formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Daily Check-in Section
                    VStack(spacing: 20) {
                        Text("Daily Check-in")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !hasCompletedToday {
                            VStack(spacing: 16) {
                                // Emotion Slider
                                EmotionSliderView(value: $emotionValue)
                                
                                // Stress Slider
                                StressSliderView(value: $stressValue)
                                
                                // Complete Button
                                Button(action: {
                                    completeDailyCheckIn()
                                }) {
                                    HStack {
                                        Text("Complete Check-in")
                                            .font(.system(size: 16, weight: .semibold))
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(color: .white.opacity(0.5), radius: 12, x: 0, y: 0)
                                            .shadow(color: .white.opacity(0.3), radius: 24, x: 0, y: 0)
                                            .shadow(color: .white.opacity(0.1), radius: 36, x: 0, y: 0)
                                    )
                                }
                            }
                        } else {
                            // Completed state
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 20))
                                    
                                    Text("Check-in completed for today")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                
                                Text("Great job taking care of your mental fitness! Come back tomorrow for your next check-in.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: 0)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Weekly Stress Graph
                    VStack(spacing: 16) {
                            HStack {
                                Text("Weekly Stress Levels")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                        
                        if weeklyStressData.isEmpty {
                            // Empty state
                            VStack(spacing: 12) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(.gray)
                                
                                Text("No data yet")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("Complete your daily check-ins to see your stress trends")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        } else {
                            // Graph with data
                            VStack(spacing: 12) {
                                // Chart
                                if #available(iOS 16.0, *) {
                                    Chart(weeklyStressData) { dataPoint in
                                        LineMark(
                                            x: .value("Day", dataPoint.day),
                                            y: .value("Stress", dataPoint.stressLevel)
                                        )
                                        .foregroundStyle(.white)
                                        .lineStyle(StrokeStyle(lineWidth: 3))
                                        
                                        AreaMark(
                                            x: .value("Day", dataPoint.day),
                                            y: .value("Stress", dataPoint.stressLevel)
                                        )
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    }
                                    .frame(height: 120)
                                    .chartYScale(domain: 1...10)
                                    .chartXAxis {
                                        AxisMarks(values: .stride(by: 1)) { _ in
                                            AxisValueLabel()
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .chartYAxis {
                                        AxisMarks(values: .stride(by: 2)) { _ in
                                            AxisValueLabel()
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 12))
                                        }
                                    }
                                } else {
                                    // Fallback for older iOS versions
                                    Text("Chart requires iOS 16+")
                                        .foregroundColor(.gray)
                                        .frame(height: 120)
                                }
                                
                                // Gentle nudge
                                if shouldShowNudge() {
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.yellow)
                                        
                                        Text(nudgeMessage())
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button("Try Exercise") {
                                            showResetExercise = true
                                        }
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.white)
                                        )
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
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: 0)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // SOS Button
                    VStack(spacing: 16) {
                        Button(action: {
                            call988()
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Text("SOS - Call 988")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red)
                                    .shadow(color: .red.opacity(0.5), radius: 12, x: 0, y: 0)
                                    .shadow(color: .red.opacity(0.3), radius: 24, x: 0, y: 0)
                                    .shadow(color: .red.opacity(0.1), radius: 36, x: 0, y: 0)
                            )
                        }
                        
                        Text("24/7 Suicide & Crisis Lifeline")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100) // Space for bottom nav
                    
                }
            }
        }
        .onAppear {
            loadUserData()
        }
        .sheet(isPresented: $showResetExercise) {
            ResetExerciseView()
        }
    }
    
    private func completeDailyCheckIn() {
        // Store the data
        let today = Date()
        let stressData = StressDataPoint(
            day: today,
            stressLevel: stressValue,
            emotionLevel: emotionValue
        )
        
        // Save to UserDefaults (in a real app, you'd use Core Data or similar)
        saveStressData(stressData)
        
        // Update UI
        hasCompletedToday = true
        
        // Add to weekly data
        weeklyStressData.append(stressData)
        
        // Keep only last 7 days
        if weeklyStressData.count > 7 {
            weeklyStressData.removeFirst()
        }
    }
    
    private func loadUserData() {
        // Load existing data
        weeklyStressData = loadStressData()
        
        // Check if completed today
        let today = Calendar.current.startOfDay(for: Date())
        hasCompletedToday = weeklyStressData.contains { 
            Calendar.current.isDate($0.day, inSameDayAs: today)
        }
    }
    
    private func saveStressData(_ data: StressDataPoint) {
        // Simple UserDefaults storage (in production, use proper data persistence)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: "stressData_\(data.day.timeIntervalSince1970)")
        }
    }
    
    private func loadStressData() -> [StressDataPoint] {
        // Load last 7 days of data
        var stressDataArray: [StressDataPoint] = []
        let calendar = Calendar.current
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let key = "stressData_\(date.timeIntervalSince1970)"
                if let data = UserDefaults.standard.data(forKey: key),
                   let stressData = try? JSONDecoder().decode(StressDataPoint.self, from: data) {
                    stressDataArray.append(stressData)
                }
            }
        }
        
        return stressDataArray.sorted { $0.day < $1.day }
    }
    
    private func shouldShowNudge() -> Bool {
        guard weeklyStressData.count >= 3 else { return false }
        
        let lastThree = Array(weeklyStressData.suffix(3))
        return lastThree[0].stressLevel < lastThree[1].stressLevel && 
               lastThree[1].stressLevel < lastThree[2].stressLevel
    }
    
    private func nudgeMessage() -> String {
        return "Your stress has been trending up for 3 days — here's a 2-minute reset exercise"
    }
    
    private func call988() {
        if let url = URL(string: "tel:988") {
            UIApplication.shared.open(url)
        }
    }
}

struct EmotionSliderView: View {
    @Binding var value: Double
    
    private var emoji: String {
        switch Int(value.rounded()) {
        case 1: return "😭"      // super sad
        case 2: return "😢"
        case 3: return "☹️"
        case 4: return "🙁"
        case 5: return "😐"
        case 6: return "🙂"
        case 7: return "😊"
        case 8: return "😄"
        case 9: return "😃"
        case 10: return "🤩"     // super joyful
        default: return "😐"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("How are you feeling?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(emoji)
                    .font(.system(size: 24))
            }
            
            HStack {
                Text("1")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Slider(value: $value, in: 1...10, step: 0.1)
                    .accentColor(.white)
                
                Text("10")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 0)
        )
    }
}

struct StressSliderView: View {
    @Binding var value: Double
    
    private var stressLevel: String {
        switch Int(value) {
        case 1...3: return "Low"
        case 4...6: return "Moderate"
        case 7...8: return "High"
        case 9...10: return "Very High"
        default: return "Moderate"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Stress Level")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(stressLevel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("1")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                Slider(value: $value, in: 1...10, step: 0.1)
                    .accentColor(.white)
                
                Text("10")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 0)
        )
    }
}

struct StressDataPoint: Identifiable, Codable {
    let id = UUID()
    let day: Date
    let stressLevel: Double
    let emotionLevel: Double
}

struct ResetExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("2-Minute Reset Exercise")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Take a moment to reset and refocus")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                // Placeholder for exercise content
                VStack(spacing: 16) {
                    Image(systemName: "figure.mind.and.body")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.white)
                    
                    Text("Exercise content will go here")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .white.opacity(0.3), radius: 8, x: 0, y: 0)
                )
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    HomeView(userName: "Sam")
}
