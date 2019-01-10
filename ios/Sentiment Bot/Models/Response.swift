//
//  Response.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation
import CoreLocation

class Response: NSObject, Decodable {
    let id: Int
    let date: Date
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let userId: Int
    let surveyId: Int
    var location: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case longitude
        case latitude
        case userId
        case surveyId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
        let stringDate = try container.decode(String.self, forKey: .date)
        let date = dateFormatter.date(from: stringDate)
        let longitude = (try container.decode(String.self, forKey: .longitude) as NSString).doubleValue
        let latitude = (try container.decode(String.self, forKey: .latitude) as NSString).doubleValue
        let id = try container.decode(Int.self, forKey: .id)
        let userId = try container.decode(Int.self, forKey: .userId)
        let surveyId = try container.decode(Int.self, forKey: .surveyId)
        
        
        self.id = id
        self.date = date!
        self.longitude = longitude
        self.latitude = latitude
        self.userId = userId
        self.surveyId = surveyId
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
 
}
