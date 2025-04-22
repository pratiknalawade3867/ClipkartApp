//
//  ContentView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cartManager = CartManager()
    @StateObject private var vm = ShowMapViewModel()
    var body: some View {
        LoginView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cartManager) // Provide the CartManager to the environment
            .environmentObject(vm)
    }
}

#Preview {
    ContentView()
}

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model") // Replace with your app name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
