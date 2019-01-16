//
//  TabBarViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/16/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func passToVCs() {
        
    }
    
    func getUserData() {
        APIController.shared.getUser(userId: TestUser.userID) { (user, error) in
            if let error = error {
                NSLog("There was error retreiving current User: \(error)")
            } else if let user = user {
                self.user = user
            }
            APIController.shared.getUserResponses(userId: TestUser.userID, completion: { (responses, error) in
                if let error = error {
                    NSLog("There was error retreiving current User Responses: \(error)")
                } else if let responses = responses {
                    self.userResponses = responses
                }
            })
        }
    }
    
    var user: User?
    
    var userResponses: [Response]? {
        didSet {
            passToVCs()
        }
    }

}
