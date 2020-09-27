//
//  RecipeMixUtils.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation
import UIKit

class RecipeMixUtils {
    
    // APP COLORS
    // TODO: Define the color
    static let appMainBackgroundColor = UIColor(red: 38/255, green: 196/255, blue: 133/255, alpha: 1)
    static let appCellAlternativeBackgroundColor = UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 1.0)
    
    func createErrorAlertViewController(title: String, message: String) -> UIAlertController {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        return errorAlert
    }
    
}
