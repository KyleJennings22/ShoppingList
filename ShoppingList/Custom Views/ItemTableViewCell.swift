//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by Kyle Jennings on 11/15/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

// need a protocol to tell the VC what to do
protocol ItemTableViewCellDelegate: class {
    func purchasedToggled(_ sender: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {
    // MARK: - OUTLETS
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var purchasedButton: UIButton!
    
    // MARK: - VARIABLES
    weak var delegate: ItemTableViewCellDelegate?

    @IBAction func purchasedButtonTapped(_ sender: UIButton) {
        delegate?.purchasedToggled(self)
    }
    
}

extension ItemTableViewCell {
    func updateViews(item: Item) {
        itemLabel.text = item.name
        if item.isPurchased {
            purchasedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        } else {
            purchasedButton.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        }
    }
}
