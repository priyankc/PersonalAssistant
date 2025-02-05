//
//  PersonalAssistantApp.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI
import GoogleSignIn
import Supabase

@main
struct PersonalAssistantApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel) // ✅ Pass authentication state globally
                .onAppear {
                    authViewModel.checkAuth() // ✅ Check authentication status on launch
                }
        }
    }
}
