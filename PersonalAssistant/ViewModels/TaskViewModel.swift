//
//  TaskViewModel.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI
import Supabase

class TaskViewModel: ObservableObject {
    @Published var tasks: [UserTask] = []

    func fetchUserTasks(userId: UUID) {
        Task {
            do {
                let response: [UserTask] = try await SupabaseManager.shared.client
                    .from("user_tasks")
                    .select()
                    .eq("user_id", value: userId)  // ✅ Ensure UUID is passed as String
                    .order("created_at", ascending: false)  // ✅ Sort by latest tasks
                    .execute()
                    .value

                DispatchQueue.main.async {
                    self.tasks = response
                }
            } catch {
                print("Error fetching user tasks: \(error.localizedDescription)")
            }
        }
    }
    
    func createTask(userId: UUID, title: String, description: String?, actionRequired: Bool) async {
        let newTask = UserTask(
            id: UUID(),
            userId: userId,
            title: title,
            description: description,
            actionRequired: actionRequired,
            createdAt: ISO8601DateFormatter().string(from: Date())
        )

        do {
            try await SupabaseManager.shared.addUserTask(userTask: newTask)
            print("Task successfully added")
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
    }
}
