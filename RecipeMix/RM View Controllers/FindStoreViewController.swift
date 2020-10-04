//
//  FindStoreViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/29/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FindStoreViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func findStoresNearby() {
        //Search Params: The Map will filter the locations to be related only to stores that sell food
        let params: [String] = ["convenience store", "food store", "market", "food mart", "grocery store", "supermarket"]

        if let location = locationManager.location?.coordinate{
            let request = MKLocalSearch.Request()
            request.region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            for param in params {
                request.naturalLanguageQuery = param
                let search = MKLocalSearch(request: request)
                search.start { (response, error) in

                    guard let response = response else {
                        return
                    }

                    for item in response.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    //MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationId = "mapPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) as? MKMarkerAnnotationView
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            pinView?.canShowCallout = true
            pinView?.markerTintColor = RecipeMixUtils.appMainBackgroundColor
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let placemark = MKPlacemark.init(coordinate: view.annotation!.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = view.annotation?.title!
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension FindStoreViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            findStoresNearby()
        }
    }
}
