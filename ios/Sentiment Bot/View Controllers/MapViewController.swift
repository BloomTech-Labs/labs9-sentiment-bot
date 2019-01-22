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
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
        }
        super.viewDidLoad()
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            }
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
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

        annotationView.glyphTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    //MARK:- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        
        enum location {
            static let pioneer = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
            static let live = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location.pioneer, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Unable to access your current location")
    }
    
    var userResponses: [Response]? 
    
    var user: User?
    
    let locationHelper = LocationHelper()

}
