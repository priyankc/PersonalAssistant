//
//  ContentView.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel() 

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                HomeView()
                    .environmentObject(authViewModel)
            } else {
                LoginView().environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.checkAuth()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
