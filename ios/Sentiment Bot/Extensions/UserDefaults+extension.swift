//
//  UserDefaults+extension.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/14/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    var userId: Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    var token: String? {
        return string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    var deviceToken: String? {
        return string(forKey: UserDefaultsKeys.deviceToken.rawValue)
    }
    
    var longitude: String? {
        return string(forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    var latitude: String? {
        return string(forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    var teamID: Int {
        return integer(forKey: UserDefaultsKeys.teamId.rawValue)
    }
}
