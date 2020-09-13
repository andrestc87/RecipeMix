//
//  RecipeDashboardViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/11/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class RecipeDashboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [Recipe]()
    var noResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searhBar.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        // Load Initial Recipes
        // TODO: Review how to handle the pagination
        loadRecipes(tags: "", page: 5)
    }
    
    func loadRecipes(tags: String, page: Int) {
        print("Get Recipes")
        
        RecipeMixClient.recipeMixSharedInstance.searchRecipeMixRecipes(tags: tags, page: 5) { (recipes, error) in
            print("FROM DASHBOARD")
            
            if error != nil {
                let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "There was an error trying to search recipes. Please try again.")
                
                self.present(errorAlert, animated: true)
            } else {
                self.noResults = recipes?.count == 0 ? true : false
                self.recipes = recipes ?? []
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func logOutButtonAction(_ sender: Any) {
        
        print("Sign Out")
        
    }
    
    // Mark: Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noResults {
            return 1
        } else {
            return self.recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCellIdentifier", for: indexPath) as! RecipeTableViewCell
        
        cell.selectionStyle = .none
        
        if self.noResults {
            cell.recipeCellLabel.text = "No recipes found."
            cell.recipeCellLabel.textAlignment = .center
            
        } else {
            cell.recipeCellLabel.textAlignment = .left
            let recipe = self.recipes[indexPath.row]
            
            cell.recipeCellLabel.text = recipe.title
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.noResults {
            print("Nothing to do here")
        } else {
            print("NAVIGATE TO DETAIL")
        }
    }
    
}

extension RecipeDashboardViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Review how to handle the pagination
        loadRecipes(tags: searchBar.text ?? "", page: 5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
}
