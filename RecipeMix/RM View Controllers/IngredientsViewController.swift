//
//  IngredientsViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/27/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addGroceriesButton: UIButton!
    
    var ingredients: [String]!
    var isRecipeSaved: Bool = false
    var savedRecipe: RM_Recipe!
    var apiUtils = RecipeMixAPIUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Ingredients"
        setupIngredientsTable()
        
        //Setup Add Groceries Button
        self.addGroceriesButton.isHidden = (self.isRecipeSaved && self.savedRecipe != nil) ? false : true
    }
    
    func setupIngredientsTable() {
        //TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // No FooterView
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        // Enable self sizing rows.
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    @IBAction func addGroceriesButtonAction(_ sender: Any) {
        do {
            try apiUtils.saveIngredients(recipe: self.savedRecipe, ingredients: self.ingredients)
            
            let alertController = UIAlertController(title: "Groceries", message: "The ingredients were added to your groceries list correctlty.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        
        } catch {
            let alertController = UIAlertController(title: "Error", message: "An error occurred while adding the ingredients to your groceries list. Please, try again alter.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
