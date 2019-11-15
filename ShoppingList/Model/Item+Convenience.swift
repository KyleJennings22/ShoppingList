//
//  Item+Convenience.swift
//  ShoppingList
//
//  Created by Kyle Jennings on 11/15/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import Foundation
import CoreData


extension Item {
    // initializing, isPurchased defaults to false because if an item is added to a shopping list it hasn't been purchased
    convenience init(name: String, isPurchased: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isPurchased = isPurchased
    }
}
