//
//  RecipeSelectionViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/26/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import CoreData

class RecipeSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var selectionTableView: UITableView!
    
    var recipes = [RM_Recipe]()
    var noResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        //Setup NavBar
        setupNavBar()
        //Setup the Table View
        setupSelectionTableView()
        //Load the recipes stored in the device
        loadRecipeSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        configureNavigationBar(largeTitleColor: .white, backgoundColor: RecipeMixUtils.appMainBackgroundColor, tintColor: .systemBlue, title: "My Selection", preferredLargeTitle: true)
    }
    
    fileprivate func setupSelectionTableView() {
        // Setting Delegates
        self.selectionTableView.delegate = self
        self.selectionTableView.dataSource = self
        
        // No FooterView
        self.selectionTableView.tableFooterView = UIView()
        self.selectionTableView.tableHeaderView = UIView()
        
        // Enable self sizing rows.
        self.selectionTableView.estimatedRowHeight = 80.0
        self.selectionTableView.rowHeight = UITableView.automaticDimension
    }
    
    func loadRecipeSelection() {
        self.noResults = false
        let fetchRequest: NSFetchRequest<RM_Recipe> = RM_Recipe.fetchRequest()
        
        if let results = try? DataController.shared.viewContext.fetch(fetchRequest) {
            self.recipes = results
            self.selectionTableView.reloadData()
        }
        self.noResults = self.recipes.count == 0 ? true : false
    }
    
    // TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noResults {
            return 1
        } else {
            return self.recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.noResults {
            let noResultsCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NoResultsCell")
           
            noResultsCell.selectionStyle = .none
            noResultsCell.textLabel?.text = "No recipes found."
            noResultsCell.textLabel?.textAlignment = .center
            
            return noResultsCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeSelectionTableViewCell", for: indexPath) as! RecipeSelectionTableViewCell
            
            cell.selectionStyle = .none
            
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = RecipeMixUtils.appCellAlternativeBackgroundColor
            } else {
                cell.backgroundColor = UIColor.clear
            }
            
            let recipe = self.recipes[indexPath.row]
            cell.recipeTitleLabel.text = recipe.title
            
            //Date Label
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.recipeDateLabel.text = formatter.string(from: recipe.registeredDate!)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.noResults {
            print("Nothing to do here")
        } else {
            
            let selectedRecipe = self.recipes[indexPath.row]
            let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
            recipeVC.savedRecipe = selectedRecipe
            recipeVC.recipeId = Int(selectedRecipe.id)
            recipeVC.comesFromDashboard = false
            
            self.navigationController?.pushViewController(recipeVC, animated: true)
            
        }
    }

}
