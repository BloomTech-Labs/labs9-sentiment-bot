//
//  LocationHelper.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {    

    
    let locationManager = CLLocationManager()
    
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    //This will used during push notification building the response(feelzy)
    func setPlace(completion: @escaping (String?, Error?) -> Void) {
        let geoCoder = CLGeocoder()
        guard let long = locationManager.location?.coordinate.longitude,
        let lat = locationManager.location?.coordinate.latitude else {
            NSLog("Couldn't get current location longitude and latitude to set place")
            return
        }
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error retreiving place from reverse GeoCode: \(error)")
                completion(nil, error)
            }
            guard let placeMark = placemarks!.first else { return }
            let place = "\(ReversedGeoLocation(with: placeMark).city), \(ReversedGeoLocation(with: placeMark).state)"
    
            completion(place, nil)
        }
    }
    
    
    func saveLocation() {
        let longitude = locationManager.location?.coordinate.longitude
        let latitude = locationManager.location?.coordinate.latitude
        UserDefaults.standard.set(longitude, forKey: UserDefaultsKeys.longitude.rawValue)
        UserDefaults.standard.set(latitude, forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    
}
