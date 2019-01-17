//
//  User.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


class User: Codable {
    let id: Int
    var firstName: String
    var lastName: String
    var teamId: Int?
    var imageUrl: URL?
    
}

struct JWT: Codable {
    var jwt: String
    
    enum CodingKeys: String, CodingKey {
        case jwt
    }
}


