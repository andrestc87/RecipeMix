//
//  ShadowView.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/21/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
}
