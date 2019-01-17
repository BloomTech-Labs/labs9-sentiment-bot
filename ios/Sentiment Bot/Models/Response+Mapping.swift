//
//  Response+Mapping.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation
import MapKit

extension Response: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
