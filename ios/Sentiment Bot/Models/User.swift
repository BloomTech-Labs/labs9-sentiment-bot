//
//  User.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


struct User: Codable {
    let id: Int
    var firstName: String
    var lastName: String
    var teamId: Int?
//    var teamName: String
    var imageUrl: URL?
    var subscribed: Bool
    let isAdmin: Bool
    let isTeamMember: Bool
    let deviceToken: String?
    let lastSurveyDate: String?
    
    static var currentUserId = UserDefaults.standard.userId
    
}

struct UserArray: Codable {
    var user: [User]
}

struct JWT: Codable {
    var jwt: String
    
    enum CodingKeys: String, CodingKey {
        case jwt
    }
}


