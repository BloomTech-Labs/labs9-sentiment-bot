//
//  MapViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UserProtocol {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    private var userTrackingButton = MKUserTrackingButton()
    
    override func viewDidLoad() {
        self.locationManager = CLLocationManager()
        super.viewDidLoad()
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            }
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.mapView.delegate = self
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ResponseAnnotationView")
        
        guard let responses = userResponses else {
            NSLog("User Response not set on MapViewController")
            return
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(responses)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let response = annotation as? Response else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ResponseAnnotationView", for: response) as! MKMarkerAnnotationView
        annotationView.glyphText = response.emoji
        annotationView.glyphTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    var updated = false
    let scottCoordinates = CLLocationCoordinate2D(latitude: 38.943359375, longitude: -84.7267800844133)
    let moinsCoordinates = CLLocationCoordinate2D(latitude: 40.70912330225265, longitude: -73.78719990509816)

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.locationManager?.stopUpdatingLocation()
        if !updated {
            let userCurrentLocation = userLocation.coordinate
            
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            let region = MKCoordinateRegion(center: scottCoordinates, span: span)
            
            self.mapView.setRegion(region, animated: true)
            updated = true
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Unable to access your current location")
    }
    
    var userResponses: [Response]? 
    var user: User?    
    let locationHelper = LocationHelper()

}
