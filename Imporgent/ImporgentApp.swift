//
//  ImporgentApp.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import SwiftUI

@main
struct ImporgentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MatrixView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
