//
//  TaskDetailView.swift
//  PersonalAssistant
//
//  Created by Priyank Chodisetti on 2/3/25.
//

import SwiftUI

struct TaskDetailView: View {
    let task: UserTask
    
    var body: some View {
        VStack(spacing: 20) {
            Text("AI Suggestion for: \(task.title)")
                .font(.title2)
                .padding()
            Text("This is the reply I'm sending: \nHey Alex, I'll be there! Are you cool with it?")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            HStack {
                Button("Approve") {
                    // Handle approval action
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Edit") {
                    // Handle edit action
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
