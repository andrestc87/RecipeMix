//
//  FindStoreViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/29/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit

class FindStoreViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
    
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
