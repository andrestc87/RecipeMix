//
//  GroceriesListViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/27/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class GroceriesListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groceriesTableView: UITableView!
    
    var apiUtils = RecipeMixAPIUtils()
    var groceries = [RM_Groceries]()
    var noResults = false
    
    struct Groceries {
        var sectionName: String!
        var sectionObjects: [String]!
    }
    
    var groceryArray = [Groceries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .always

        //Setup NavBar
        setupNavBar()
        //Setup TableView
        setupGroceriesTableView()
        loadGroceries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //Load Groceries
        loadGroceries()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.groceryArray = []
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        configureNavigationBar(largeTitleColor: .white, backgoundColor: RecipeMixUtils.appMainBackgroundColor, tintColor: .systemBlue, title: "Groceries List", preferredLargeTitle: true)
    }
    
    func setupGroceriesTableView() {
        // Setting Delegates
        self.groceriesTableView.delegate = self
        self.groceriesTableView.dataSource = self
        
        // No FooterView
        self.groceriesTableView.tableFooterView = UIView()
        self.groceriesTableView.tableHeaderView = UIView()
        
        // Enable self sizing rows.
        self.groceriesTableView.estimatedRowHeight = 80.0
        self.groceriesTableView.rowHeight = UITableView.automaticDimension
    }
    
    func loadGroceries() {
        var sections = [String]()
        self.groceryArray = []
        self.groceries = []
        self.groceries = apiUtils.getGroceries()
        
        self.noResults = self.groceries.count == 0 ? true : false
        
        //Sections
        for grocery in groceries {
            sections.append((grocery.recipe?.title)!)
        }
        
        sections = sections.uniqueElements()
        
        var sectionItems = [String]()
        // Add the groceries for each section
        for section in sections {
            for grocery in groceries {
                if section == grocery.recipe?.title {
                    sectionItems.append(grocery.name!)
                }
            }
            groceryArray.append(Groceries.init(sectionName: section, sectionObjects: sectionItems))
            sectionItems = []
        }
        
        self.groceriesTableView.reloadData()
    }

    // TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noResults {
            return 1
        } else {
            return groceryArray[section].sectionObjects.count
            //return self.groceries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.noResults {
            let noResultsCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NoResultsCell")
           
            noResultsCell.selectionStyle = .none
            noResultsCell.textLabel?.text = "No groceries found."
            noResultsCell.textLabel?.textAlignment = .center
            
            return noResultsCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryTableViewCell", for: indexPath) as! GroceryTableViewCell
            
            cell.selectionStyle = .none
            
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = RecipeMixUtils.appCellAlternativeBackgroundColor
            } else {
                cell.backgroundColor = UIColor.clear
            }
            
            cell.groceryLabel.text = groceryArray[indexPath.section].sectionObjects[indexPath.row]
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groceryArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groceryArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.9333, green: 0.4196, blue: 0, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        header.textLabel?.numberOfLines = 0
    }

    
    @IBAction func findStoreButtonAction(_ sender: Any) {
    }
    
}

extension Array where Element: Hashable {
    func uniqueElements() -> [Element] {
        var seen = Set<Element>()
        var out = [Element]()

        for element in self {
            if !seen.contains(element) {
                out.append(element)
                seen.insert(element)
            }
        }

        return out
    }
}
