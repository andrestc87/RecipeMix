//
//  RecipeTableViewCell.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import SkeletonView

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    static let kRecipeCellId = "RecipeTableViewCellIdentifier"
    
}
