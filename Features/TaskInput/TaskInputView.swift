//
//  TaskInputView.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import SwiftUI

struct TaskInputView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var deadline: Date = Date()
    @State private var suggestedQuadrant: Int = 1
    
    // Importance / Urgency scores
    @State private var importance: Double = 5
    @State private var urgency: Double = 5
    
    var task: TaskItem? // Optional task for editing
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .onChange(of: title) { _ in analyzeText() }
                    TextEditor(text: $details)
                        .frame(height: 100)
                        .onChange(of: details) { _ in analyzeText() }
                }
                
                Section(header: Text("Deadline")) {
                    DatePicker("Select Deadline", selection: $deadline, displayedComponents: .date)
                }
                
                Section(header: Text("Priority Settings")) {
                    VStack {
                        Text("Importance: \(Int(importance))")
                        Slider(value: $importance, in: 0...10, step: 1)
                    }

                    VStack {
                        Text("Urgency: \(Int(urgency))")
                        Slider(value: $urgency, in: 0...10, step: 1)
                    }
                }
            }
            .navigationTitle(task == nil ? "Add Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                if let task = task {
                    // Pre-fill fields for editing
                    title = task.title ?? ""
                    details = task.details ?? ""
                    deadline = task.deadline ?? Date()
                    suggestedQuadrant = Int(task.quadrant)
                    importance = task.importanceScore
                    urgency = task.urgencyScore
                } else {
                    print("🚨 Task is nil in TaskInputView.onAppear")

                }
            }
        }
    }
    
    private func saveTask() {
        let taskToSave = task ?? TaskItem(context: context)
        taskToSave.title = title
        taskToSave.details = details
        taskToSave.deadline = deadline
        taskToSave.urgencyScore = urgency
        taskToSave.importanceScore = importance

        // Determine quadrant based on importance and urgency
        if importance >= 5 && urgency >= 5 {
            taskToSave.quadrant = 1 // High priority, high urgency
        } else if importance >= 5 {
            taskToSave.quadrant = 2 // High priority, low urgency
        } else if urgency >= 5 {
            taskToSave.quadrant = 3 // High urgency, low priority
        } else {
            taskToSave.quadrant = 4 // Low priority, low urgency
        }

        taskToSave.isCompleted = task?.isCompleted ?? false

        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
    
    private func calculateUrgency() -> Double {
        // Basic urgency calculation based on deadline proximity
        let daysUntilDeadline = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        return Double(max(0, 10 - daysUntilDeadline)) // Higher urgency if closer to deadline
    }
    
    private func calculateImportance() -> Double {
        // Basic importance calculation based on keywords
        let importanceKeywords = ["critical", "important", "key", "essential"]
        let keywordCount = importanceKeywords.filter { details.lowercased().contains($0) }.count
        return Double(keywordCount) * 2.5
    }
    
    private func analyzeText() {
        let urgencyScore = calculateUrgency()
        let importanceScore = calculateImportance()
        
        if urgencyScore >= 5 && importanceScore >= 5 {
            suggestedQuadrant = 1
        } else if importanceScore >= 5 {
            suggestedQuadrant = 2
        } else if urgencyScore >= 5 {
            suggestedQuadrant = 3
        } else {
            suggestedQuadrant = 4
        }
    }
}


#Preview("Task Input View") {
    guard let context = try? PersistenceController.preview.container.viewContext else {
        return Text("Failed to load Core Data preview context")
    }

    let task = TaskItem(context: context)
    task.title = "New Task"
    task.details = "Enter details for your new task here."
    task.deadline = Date()
    task.quadrant = 2
    task.isCompleted = false

    try? context.save() // Ensure the task is properly saved

    return TaskInputView(task: task)
        .environment(\.managedObjectContext, context)
}
