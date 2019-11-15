//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Kyle Jennings on 11/15/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // setting our fetchedresultscontroller delegate to this VC
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        // creating and displaying the alert
        let alert = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alert.textFields?[0].text else {return}
            ItemController.sharedInstance.create(name: itemName)
        }
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // don't have multiple sections so only returning the amount of objects
        return ItemController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // creating cell and casting as custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {return UITableViewCell()}

        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        // need to update our views in our cell
        cell.updateViews(item: item)
        // setting our cells delegate as ourself
        cell.delegate = self

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ItemController.sharedInstance.delete(item: item)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}

// MARK: - Fetched Results Controller Delegate
// conforming to NSFetchedResultsControllerDelegate
extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
            
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
// conforming to ItemTableViewCellDelegate
extension ShoppingListTableViewController: ItemTableViewCellDelegate {
    func purchasedToggled(_ sender: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ItemController.sharedInstance.toggle(item: item)
        sender.updateViews(item: item)
    }
}
