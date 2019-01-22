//
//  Survey.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation

struct Survey: Codable {
    let id: Int
    let schedule: String
    let question: String
    var feelings: [Feeling]
    let teamId: Int
}
