//
//  RecipeTableViewCell.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var servingPriceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let kRecipeCellId = "RecipeTableViewCellIdentifier"
    
}
