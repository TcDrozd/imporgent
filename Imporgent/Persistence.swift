//
//  Persistence.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Imporgent")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Enable lightweight migration
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Preview instance
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true) // Use in-memory store for preview
        let viewContext = controller.container.viewContext

        // Create sample tasks
        let task = TaskItem(context: viewContext)
        task.title = "Sample Task"
        task.details = "This is a preview task."
        task.deadline = Date()
        task.quadrant = 1
        task.isCompleted = false

        do {
            try viewContext.save()
        } catch {
            fatalError("❌ Failed to save preview data: \(error)")
        }

        return controller
    }()
}
