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
            VStack(spacing: 10) {
                ForEach(tasks) { task in
                    TaskCard(task: task)
                }
            }
            .padding()
        }
        .navigationTitle("Quadrant \(quadrant)")
    }
}
