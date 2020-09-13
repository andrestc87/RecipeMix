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
    
    func createErrorAlertViewController(title: String, message: String) -> UIAlertController {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        return errorAlert
    }
    
}
