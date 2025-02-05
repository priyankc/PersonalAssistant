//
//  SupabaseManager.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "http://127.0.0.1:54321")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
        )
    }
    
    func addUserTask(userTask: UserTask) async throws {
        try await client
            .from("user_tasks")
            .insert(userTask) // ✅ Using Encodable struct instead of [String: Any]
            .execute()
        print("User task added to Supabase")
    }
}
