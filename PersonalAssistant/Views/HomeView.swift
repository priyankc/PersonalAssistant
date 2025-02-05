//
//  HomeView.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Supabase

struct HomeView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    @State private var newTaskDescription: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    if let profilePictureURL = authViewModel.profilePictureURL, let url = URL(string: profilePictureURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                 .scaledToFill()
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
                if let userId = authViewModel.userId {
                    List(taskViewModel.tasks) { task in
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            if let description = task.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onAppear {
                        taskViewModel.fetchUserTasks(userId: userId)
                    }
                } else {
                    Text("Loading user info...")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                Button(action: handleSignOut) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Your Tasks")
        }
    }

    func handleSignOut() {
        Task {
            do {
                try await SupabaseManager.shared.client.auth.signOut()
                DispatchQueue.main.async {
                    authViewModel.isLoggedIn = false
                }
                print("User signed out successfully")
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
