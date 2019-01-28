//
//  StripeController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/19/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation


class StripeController {
    
    
    static let shared = StripeController()
    
    
    
    //Charge Customer for Subscription
    func subscribeToPremium(token: String, completion: @escaping (Error?) -> Void = {_ in }) {
        let url = baseUrl.appendingPathComponent("subscriptions")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let stripeParams = ["card_token": token] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: stripeParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            completion(error)
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending stripe token credentials to server: \(error)")
                completion(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code(subscribeToPremium) from the http request: \(httpResponse.statusCode)")
                completion(error)
                return
            }
            
            NSLog("User subscribed to unlimited premium service")
            completion(nil)
            
            }.resume()
    }
    
    
    //Cancel Subscription
    func cancelPremiumSubscription(completion: @escaping (Error?) -> Void = {_ in }) {
        let url = baseUrl.appendingPathComponent("subscriptions")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.delete.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending delete subscription request to server: \(error)")
                completion(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code(cancelPremiumSubscription) from the http request: \(httpResponse.statusCode)")
                completion(error)
                return
            }
            
            NSLog("User cancelled premium service")
            completion(nil)
            
            }.resume()
    }
    
    let baseUrl = URL(string: "https://sentimentbot-1.herokuapp.com/api")!
    //let baseUrl =  URL(string: "http://192.168.1.152:3000/api")!
}
