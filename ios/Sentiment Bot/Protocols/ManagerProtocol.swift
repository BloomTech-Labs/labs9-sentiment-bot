//
//  ManagerProtocol.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/22/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation

protocol ManagerProtocol {
    var user: User? {get set}
    var teamResponses: [Response]? {get set}
    var team: Team? {get set}
    var survey: Survey? {get set}
    var teamMembers: [User]? {get set}
}
