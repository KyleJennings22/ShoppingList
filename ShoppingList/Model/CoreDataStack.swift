//
//  CoreDataStack.swift
//  ShoppingList
//
//  Created by Kyle Jennings on 11/15/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        }
        return container
    }()
    
    
    static var context: NSManagedObjectContext {return container.viewContext}
}
