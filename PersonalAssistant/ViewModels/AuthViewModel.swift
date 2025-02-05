//
//  AuthViewModel.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI
import Supabase

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userId: UUID?
    @Published var profilePictureURL: String?

    func checkAuth() {
        Task {
            await fetchUser() // ✅ No need for `self.` inside Task block
        }
    }

    @MainActor  // ✅ Ensures this function runs on the main thread
    private func fetchUser() async {
        do {
            let user = try await SupabaseManager.shared.client.auth.user()
            self.isLoggedIn = user != nil
            self.userId = user.id
            
            if let metadata = user.userMetadata as? [String: AnyJSON] {
                if let pictureJSON = metadata["picture"],
                   case let .string(profileURL) = pictureJSON {
                    self.profilePictureURL = profileURL
                    
                } else {
                    self.profilePictureURL = nil
                }
            } else {
                self.profilePictureURL = nil
            }
        } catch {
            print("Error fetching session: \(error.localizedDescription)")

            self.isLoggedIn = false
            self.userId = nil
            self.profilePictureURL = nil
        }
    }
}
