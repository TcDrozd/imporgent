//
//  ContentView.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import SwiftUI
import CoreData

struct MatrixView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(entity: TaskItem.entity(), sortDescriptors: [])
    private var tasks: FetchedResults<TaskItem>
    
    @State private var isShowingTaskInput = false
    @State private var selectedTask: TaskItem? // Track selected task
    @State private var selectedSpace: String? = nil // Track selected space

    private var filteredTasks: [TaskItem] {
        if let space = selectedSpace {
            return tasks.filter { $0.tags?.contains(space) == true }
        }
        return Array(tasks)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                VStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(1...4, id: \.self) { quadrant in
                            NavigationLink(destination: QuadrantDetailView(quadrant: quadrant)){
                                QuadrantView(
                                    tasks: filteredTasks.filter { $0.quadrant == quadrant },
                                    quadrant: quadrant,
                                    selectedTask: $selectedTask
                                )
                                .frame(height: 200) // Fixed height per quadrant
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevents default button styling
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height * (2/3)) // Takes up 2/3 of the screen

                Spacer() // Pushes everything to top 2/3rds
            }
            .padding()
            .navigationBarTitle(selectedSpace.map { "Imporgent - \($0)" } ?? "Imporgent")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("All Tasks") { selectedSpace = nil }
                        Button("Work") { selectedSpace = "Work" }
                        Button("Personal") { selectedSpace = "Personal" }
                        Button("Hobby") { selectedSpace = "Hobby" }
                    } label: {
                        Label("Select Space", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingTaskInput = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingTaskInput) {
                TaskInputView()
                    .environment(\.managedObjectContext, context)
            }
            .navigationDestination(item: $selectedTask) { task in
                TaskDetailView(task: task)
            }
        }
    }
}

struct QuadrantView: View {
    var tasks: [TaskItem]
    var quadrant: Int
    @Binding var selectedTask: TaskItem?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Quadrant \(quadrant)")
                .font(.quadrantTitle)
                .foregroundColor(.primary)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(tasks) { task in
                        TaskCard(task: task)
                            .onTapGesture {
                                selectedTask = task // Set the selected task
                            }
                    }
                }
                .frame(maxWidth: .infinity) // Ensure task list expands
            }
            .frame(maxHeight: .infinity) // Allow scrolling to take full quadrant height
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure quadrant takes full available space
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct TaskCard: View {
    var task: TaskItem

    var body: some View {
        VStack(alignment: .leading) {
            // Use nil-coalescing to provide a default value for optional properties
            Text(task.title ?? "Untitled")
                .font(.cardTitle)
                .foregroundColor(.primary)
                .lineLimit(1)
                .accessibilityLabel("Task: \(task.title ?? "Untitled")")
            
            // Use nil-coalescing for optional details
            if let details = task.details, !details.isEmpty {
                Text(details)
                    .font(.cardDetail)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .accessibilityLabel("Task: \(details)")
            } else {
                // Provide a placeholder if details are nil or empty
                Text("No details")
                    .font(.cardDetail)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .accessibilityLabel("Task: No details")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// Previews
#Preview {
    MatrixView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

#Preview("Quadrant View") {
    let context = PersistenceController.preview.container.viewContext
    var tasks: [TaskItem] = []
    
    for i in 1...5 {
        let task = TaskItem(context: context)
        task.title = "Sample Task \(i)"
        task.details = "This is sample task \(i) for preview."
        task.quadrant = 1
        tasks.append(task)
    }
    
    // Save the context explicitly
    try? context.save()
    
    return QuadrantView(tasks: tasks, quadrant: 1, selectedTask: .constant(nil))
        .environment(\.managedObjectContext, context)
}

#Preview("Task Card") {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskItem(context: context)
    task.title = "Test Task"
    task.details = "This task is an example of a fully detailed task card preview."
    task.deadline = Date()
    
    return TaskCard(task: task)
}
