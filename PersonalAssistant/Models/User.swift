//
//  User.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/4/25.
//


import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let name: String?
    let profilePictureURL: String?
    let refreshToken: String?
    let refreshTokenExpiresAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, email, name
        case profilePictureURL = "profile_picture_url"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresAt = "refresh_token_expires_at"
    }
}
