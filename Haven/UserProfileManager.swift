//
//  UserProfileManager.swift
//  Haven
//
//  Created by samvit bhattacharya on 9/27/25.
//

import Foundation

/// Manages user profile data persistence using UserDefaults
struct UserProfileManager {
    
    // MARK: - Keys
    
    private enum Keys {
        static let userName = "userName"
        static let userAge = "userAge"
        static let userOccupation = "userOccupation"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    // MARK: - Save Profile
    
    static func saveProfile(name: String, age: Int, occupation: String) {
        UserDefaults.standard.set(name, forKey: Keys.userName)
        UserDefaults.standard.set(age, forKey: Keys.userAge)
        UserDefaults.standard.set(occupation, forKey: Keys.userOccupation)
        UserDefaults.standard.set(true, forKey: Keys.hasCompletedOnboarding)
        print("💾 Saved user profile: \(name), \(age), \(occupation)")
    }
    
    // MARK: - Load Profile
    
    static func loadProfile() -> (name: String?, age: Int?, occupation: String?, hasCompleted: Bool) {
        let name = UserDefaults.standard.string(forKey: Keys.userName)
        let age = UserDefaults.standard.integer(forKey: Keys.userAge)
        let occupation = UserDefaults.standard.string(forKey: Keys.userOccupation)
        let hasCompleted = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)
        
        // Age of 0 means it was never set
        let validAge = age > 0 ? age : nil
        
        if let name = name, !name.isEmpty, hasCompleted {
            print("✅ Loaded user profile: \(name), \(validAge ?? 0), \(occupation ?? "N/A")")
        } else {
            print("ℹ️ No saved profile found")
        }
        
        return (name, validAge, occupation, hasCompleted)
    }
    
    // MARK: - Individual Getters
    
    static var userName: String? {
        return UserDefaults.standard.string(forKey: Keys.userName)
    }
    
    static var userAge: Int? {
        let age = UserDefaults.standard.integer(forKey: Keys.userAge)
        return age > 0 ? age : nil
    }
    
    static var userOccupation: String? {
        return UserDefaults.standard.string(forKey: Keys.userOccupation)
    }
    
    static var hasCompletedOnboarding: Bool {
        return UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    // MARK: - Clear Profile (for testing or reset)
    
    static func clearProfile() {
        UserDefaults.standard.removeObject(forKey: Keys.userName)
        UserDefaults.standard.removeObject(forKey: Keys.userAge)
        UserDefaults.standard.removeObject(forKey: Keys.userOccupation)
        UserDefaults.standard.removeObject(forKey: Keys.hasCompletedOnboarding)
        print("🗑️ Cleared user profile")
    }
}

