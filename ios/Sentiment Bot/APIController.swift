//
//  APIController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


class APIController {
    
    
    func getUserResponses(userId: Int, completion: @escaping ([Response]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
                         .appendingPathComponent("responses")
        
        
    }
    
    func getManagingTeam(completion: @escaping (Team?, Error?) -> Void) {
        
    }
    
    
    
    
    
    let baseUrl = URL(string: "http://localhost:3000/")!
}
