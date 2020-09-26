//
//  RecipeDashboardViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/11/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class RecipeDashboardViewController: BaseViewController, SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [Recipe]()
    var noResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        // Setup NavBar
        setupNavBar()
        
        // Setup TableView
        setupTableView()
        
        // Load Initial Recipes
        loadRecipes(tags: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavBar() {
        // NavBar
        self.navigationController?.navigationBar.isHidden = false
        configureNavigationBar(largeTitleColor: .white, backgoundColor: RecipeMixUtils.appMainBackgroundColor, tintColor: .systemBlue, title: "Recipes", preferredLargeTitle: true)
        
        // Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type your search here..."
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.extendedLayoutIncludesOpaqueBars = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setupTableView() {
        // Setting Delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // No FooterView
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        // Enable self sizing rows.
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func loadRecipes(tags: String) {
        self.recipes = []
        self.noResults = false
        RecipeMixClient.recipeMixSharedInstance.searchRecipeMixRecipes(tags: tags) { (recipes, error) in
            
            if error != nil {
                let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "There was an error trying to search recipes. Please try again.")
                
                self.present(errorAlert, animated: true)
            } else {
                self.noResults = recipes?.count == 0 ? true : false
                self.recipes = recipes ?? []
                // Scroll to top
                if self.tableView.numberOfRows(inSection: 0) != 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.tableView.contentInset.top), animated: true)
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
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RecipeTableViewCell.kRecipeCellId
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.noResults {
            let noResultsCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NoResultsCell")
           
            noResultsCell.selectionStyle = .none
            noResultsCell.textLabel?.text = "No recipes found."
            noResultsCell.textLabel?.textAlignment = .center
            
            return noResultsCell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.kRecipeCellId, for: indexPath) as! RecipeTableViewCell
            
            cell.selectionStyle = .none
            cell.recipeImageView.showAnimatedGradientSkeleton()
            cell.recipeTitleLabel.textAlignment = .left
            
            let recipe = self.recipes[indexPath.row]
            cell.recipeTitleLabel.text = recipe.title?.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.servingPriceLabel.text = "$" + recipe.pricePerServing!.description
            cell.timeLabel.text = "⌚︎" + String(recipe.readyInMinutes!) + "'"
            // Using Kingsfire to load images
            if let imageUrl = recipe.image {
                let resourceUrl = URL(string: imageUrl)
                    let imageResource = ImageResource(downloadURL: resourceUrl!, cacheKey: imageUrl)
                
                DispatchQueue.main.async {
                    cell.recipeImageView.kf.setImage(with: imageResource, placeholder: nil, options: nil, progressBlock: nil) { result in
                        switch result {
                            case .success( _) :
                                cell.recipeImageView.hideSkeleton()
                        case .failure( _):
                                cell.recipeImageView.hideSkeleton()
                        }
                    }
                }
            } else {
                cell.recipeImageView.hideSkeleton()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.noResults {
            print("Nothing to do here")
        } else {
            
            let selectedRecipe = self.recipes[indexPath.row]
            let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
            recipeVC.recipe = selectedRecipe
            
            self.navigationController?.pushViewController(recipeVC, animated: true)
            //self.navigationController?.present(recipeVC, animated: true, completion: nil)
            
            /*
            let selectedRecipe = self.recipes[indexPath.row]
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetaolViewController") as! RecipeDetailViewController
            detailVC.recipe = selectedRecipe
            
            self.navigationController?.pushViewController(detailVC, animated: false)
            */
        }
    }
}

extension RecipeDashboardViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Review how to handle the pagination
        loadRecipes(tags: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}


