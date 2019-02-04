//
//  Response.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import CoreLocation

class Response: NSObject, Decodable {
    let id: Int
    let date: String
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let mood: String
    let emoji: String
    let userId: Int
    let surveyId: Int?
    var imageUrl: URL?
    var place: String?

    
    var title: String? {
        return "\(self.mood.capitalized)"
    }
    
    var subtitle: String? {
        return self.place
    }
    
    
}


