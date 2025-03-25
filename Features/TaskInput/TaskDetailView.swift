//
//  TaskDetailView.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var task: TaskItem
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Task Title
                Text(task.title ?? "Untitled Task")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Task Details
                if let details = task.details, !details.isEmpty {
                    Text(details)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
                
                // Deadline
                if let deadline = task.deadline {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("Deadline: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .transition(.opacity) // Adding fade transition !
                }
                
                // Quadrant
                HStack {
                    Image(systemName: "square.grid.2x2")
                    Text("Quadrant: \(task.quadrant)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Completion Status
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    Text(task.isCompleted ? "Completed" : "Incomplete")
                        .font(.subheadline)
                        .foregroundColor(task.isCompleted ? .green : .red)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isEditing = true // Navigate to TaskInputView for editing
                }
            }
        }
        .sheet(isPresented: $isEditing) {
                    TaskInputView(task: task)
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                }
    }
}

#Preview("Task Detail View") {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskItem(context: context)
    task.title = "Sample Task"
    task.details = "This is a detailed description of the sample task."
    task.deadline = Date()
    task.quadrant = 2
    task.isCompleted = false
    
    // Save the context explicitly
    try? context.save()
    
    return TaskDetailView(task: task)
        .environment(\.managedObjectContext, context)
}
