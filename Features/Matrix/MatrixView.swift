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

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(1...4, id: \.self) { quadrant in
                        QuadrantView(tasks: tasks.filter { $0.quadrant == quadrant }, quadrant: quadrant, selectedTask: $selectedTask)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Imporgent")
            .toolbar {
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
            
            ForEach(tasks) { task in
                TaskCard(task: task)
                    .onTapGesture {
                        selectedTask = task // Set the selected task
                    }
            }
        }
        .padding()
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

/*
 TEMPORAILY DIABLING PREVIEWS
 
 
// Previews
#Preview {
    MatrixView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

#Preview("Quadrant View") {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskItem(context: context)
    task.title = "Sample Task"
    task.details = "This is a sample task for preview."
    task.quadrant = 1
    
    QuadrantView(tasks: [task], quadrant: 1, selectedTask: .constant(nil))
        .environment(\.managedObjectContext, context)
}

#Preview("Task Card") {
    let context = PersistenceController.preview.container.viewContext
    let task = TaskItem(context: context)
    task.title = "Sample Task"
    task.details = "This is a sample task for preview."
    task.quadrant = 1
    
    TaskCard(task: task)
        .environment(\.managedObjectContext, context)
        .previewLayout(.sizeThatFits)
        .padding()
}

 */
