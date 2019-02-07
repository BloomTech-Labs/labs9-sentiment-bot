//
//  MapViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UserProtocol {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var userResponses: [Response]?
    var user: User?
    let locationHelper = LocationHelper()
    var updated = false
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
//        let initialLocation = CLLocation(latitude: 38.943359375, longitude: -84.7267800844133)
//        centerMapOnLoacation(location: initialLocation)
        
        guard let responses = userResponses else {
            NSLog("User Response not set on MapViewController")
            return
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(responses)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ResponseAnnotationView")
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLoacation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.locationManager.stopUpdatingLocation()
        if !updated {
            let userCurrentLocation = userLocation.coordinate
            
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            let region = MKCoordinateRegion(center: userCurrentLocation, span: span)
            
            self.mapView.setRegion(region, animated: true)
            updated = true
        }
    }
 
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //guard let annotation = annotation as? Artwork else { return nil }
        guard let response = annotation as? Response else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ResponseAnnotationView", for: response) as! MKMarkerAnnotationView
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .roundedRect)
        annotationView.glyphText = response.emoji
        annotationView.titleVisibility = .hidden
        
        return annotationView
        
    }
}

