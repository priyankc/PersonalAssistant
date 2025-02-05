//
//  Task.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import Foundation

struct UserTask: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let title: String
    let description: String?
    let actionRequired: Bool
    let createdAt: String  // ✅ Ensure this is a String to match Supabase timestamp format

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"  // ✅ Match Supabase column names
        case title
        case description
        case actionRequired = "action_required"
        case createdAt = "created_at"
    }
}
