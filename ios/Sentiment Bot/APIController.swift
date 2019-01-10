//
//  APIController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


class APIController {
    
    static let shared = APIController()
    
    func getUserResponses(userId: Int, completion: @escaping ([Response]?, Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
                         .appendingPathComponent("\(userId)")
                         .appendingPathComponent("responses")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user responses: \(error)")
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                completion(nil, error)
                return
            }
            
            
            guard let data = data else {
                NSLog("Error retrieving data: \(error)")
                completion(nil, error)
                return
            }
            
            do {
                let responses = try JSONDecoder().decode([Response].self, from: data)
                completion(responses, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                completion(nil, error)
                return
            }
            
            NSLog("Successfully fetched all User Responses")
            
            
        }.resume()
    }
    
    func getManagingTeam(completion: @escaping (Team?, Error?) -> Void) {
        
    }
    
    
    
    
    
    let baseUrl = URL(string: "http://localhost:3000/")!
}
