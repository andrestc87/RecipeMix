//
//  IngredientsTableViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/26/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    var ingredients: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ingredients"
        setupIngredientsTable()
    }
    
    fileprivate func setupIngredientsTable() {
        // No FooterView
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        // Enable self sizing rows.
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as! IngredientTableViewCell
        
        cell.selectionStyle = .none
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = RecipeMixUtils.appCellAlternativeBackgroundColor
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        let ingredientDesc = self.ingredients[indexPath.row]
        cell.ingredientLabel.text = ingredientDesc
        
        return cell
    }
    
}
