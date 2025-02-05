//
//  LoginView.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI
import GoogleSignIn
import Supabase

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to AI Assistant")
                .font(.largeTitle)
                .padding()
            
            Button(action: handleGoogleSignIn) {
                Text("Sign in with Google")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
    
    func handleGoogleSignIn() {
        guard let rootViewController = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?
                .rootViewController else {
                print("Error: No root view controller found")
                return
            }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let signInResult = result else {
                print("Google Sign-In result is nil")
                return
            }

            let user = signInResult.user
            let idToken = user.idToken?.tokenString
            let refreshToken = user.accessToken.tokenString
            let refreshTokenExpiresAt = user.accessToken.expirationDate
            let profilePictureURL = user.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""

            print("✅ Google Sign-In successful: \(user.profile?.name ?? "Unknown User")")
            print("✅ Google Sign-In successful: \(refreshToken)")

            // Pass `idToken` to Supabase for authentication
            Task { [weak authViewModel] in
                do {
                    // First sign in with Supabase using Google token
                    let authResponse = try await SupabaseManager.shared.client.auth.signInWithIdToken(
                        credentials: .init(
                            provider: .google,
                            idToken: idToken ?? ""
                        )
                    )
                    
                    // Now we can get the current user
                    let currentUser = try await SupabaseManager.shared.client.auth.user()
                    let userId = currentUser.id

                    let refreshTokenExpiresAt = Calendar.current.date(byAdding: .month, value: 6, to: Date())

                    let userInfo = User(
                        id: userId,
                        email: authResponse.user.email ?? "",
                        name: user.profile?.name ?? "",
                        profilePictureURL: profilePictureURL,
                        refreshToken: refreshToken,
                        refreshTokenExpiresAt: refreshTokenExpiresAt
                    )

                    try await SupabaseManager.shared.client
                        .from("users")
                        .upsert(userInfo)
                        .execute()

                    DispatchQueue.main.async {
                        authViewModel?.isLoggedIn = true
                        authViewModel?.userId = userId
                        authViewModel?.profilePictureURL = profilePictureURL
                    }

                    print("✅ Supabase Authentication and Upsert Successful")

                } catch {
                    print("❌ Supabase Authentication Failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
