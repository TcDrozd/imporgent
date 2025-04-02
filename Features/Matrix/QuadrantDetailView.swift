//
//  QuadrantDetailView.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/26/25.
//

import SwiftUI

struct QuadrantDetailView: View {
    @Environment(\.managedObjectContext) private var context
    var quadrant: Int
    @FetchRequest private var tasks: FetchedResults<TaskItem>
    
    // Card sizing constants
    private let cardWidth: CGFloat = 350
    private let cardMinHeight: CGFloat = 80
    private let cardMaxHeight: CGFloat = 120
    
    init(quadrant: Int) {
        self.quadrant = quadrant
        _tasks = FetchRequest(
            entity: TaskItem.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.deadline, ascending: true)],
            predicate: NSPredicate(format: "quadrant == %d", quadrant)
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(tasks) { task in
                    TaskCard(task: task)
                        .frame(minHeight: cardMinHeight,
                               maxHeight: cardMaxHeight,
                               alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true) // in case of vertical expansion
                }
            }
            .padding(.vertical) //Vert padding
            .frame(maxWidth: .infinity) // Center cards
        }
        .navigationTitle("Quadrant \(quadrant)")
    }
}

#Preview("Quadrant 1 Detail") {
    let context = PersistenceController.preview.container.viewContext
    var tasks: [TaskItem] = []
    
    // Create sample tasks for quadrant 1
    for i in 1...5 {
        let task = TaskItem(context: context)
        task.title = "Q1 Task \(i)"
        task.details = "This is quadrant 1 sample task \(i)"
        task.quadrant = 1
        task.deadline = Date().addingTimeInterval(Double(i) * 86400) // Spread across 5 days
        tasks.append(task)
    }
    
    // Add some tasks from other quadrants (shouldn't appear in preview)
    for i in 1...3 {
        let task = TaskItem(context: context)
        task.title = "Other Task \(i)"
        task.quadrant = Int16([2, 3, 4].randomElement()!)
    }
    
    try? context.save()
    
    return NavigationStack {
        QuadrantDetailView(quadrant: 1)
            .environment(\.managedObjectContext, context)
    }
}

#Preview("Empty Quadrant") {
    let context = PersistenceController.preview.container.viewContext
    // No tasks added to this context
    return NavigationStack {
        QuadrantDetailView(quadrant: 2)
            .environment(\.managedObjectContext, context)
    }
}
