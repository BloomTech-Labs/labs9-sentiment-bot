//
//  UserProtocol.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/16/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


protocol UserProtocol {
    var user: User? {get set}
    var userResponses: [Response]? {get set}
}
