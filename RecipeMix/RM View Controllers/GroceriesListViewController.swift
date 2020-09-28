//
//  GroceriesListViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/27/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class GroceriesListViewController: UIViewController {
    
    var apiUtils = RecipeMixAPIUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .always

        //Setup NavBar
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        configureNavigationBar(largeTitleColor: .white, backgoundColor: RecipeMixUtils.appMainBackgroundColor, tintColor: .systemBlue, title: "Groceries List", preferredLargeTitle: true)
    }

    @IBAction func loadGroceriesButtonAction(_ sender: Any) {
        let groceries = apiUtils.getGroceries()
        
        for grocery in groceries {
            print(grocery.name! + " - " + (grocery.recipe?.title)!)
        }
    }
    

}
