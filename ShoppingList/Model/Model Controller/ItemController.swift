//
//  ItemController.swift
//  ShoppingList
//
//  Created by Kyle Jennings on 11/15/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    static let sharedInstance = ItemController()
    
    var fetchedResultsController: NSFetchedResultsController<Item>
    init() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    func create(name: String) {
        _ = Item(name: name)
        saveToPersistentStorage()
    }
    
    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStorage()
    }
    
    func toggle(item: Item) {
        item.isPurchased.toggle()
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error, error.localizedDescription)
        }
    }
}
