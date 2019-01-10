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
    let date: Date
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let mood: String
    let emoji: String
    let userId: Int
    let surveyId: Int
    var location: CLLocationCoordinate2D
    var imageUrl: URL
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case longitude
        case latitude
        case userId
        case surveyId
        case mood
        case emoji
        case imageUrl = "image"
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
        let mood = try container.decode(String.self, forKey: .mood)
        let emoji = try container.decode(String.self, forKey: .emoji)
        let userId = try container.decode(Int.self, forKey: .userId)
        let surveyId = try container.decode(Int.self, forKey: .surveyId)
        let imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        
        self.id = id
        self.date = date!
        self.longitude = longitude
        self.latitude = latitude
        self.mood = mood
        self.emoji = emoji
        self.userId = userId
        self.surveyId = surveyId
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.imageUrl = imageUrl
    }
    
 
}

