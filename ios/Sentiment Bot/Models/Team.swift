//
//  Team.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


struct Team: Codable {
    let id: Int
    var teamName: String
    var teamCode: Int
    let code: Int
    let userId: Int?
    let users: [User]?
    let survey: Survey?
}
