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
        getUserData()
    }
    
    func passToVCs() {
        for childVC in children {
            guard let userResponses = userResponses
            else { return }
            
            if var childVC = childVC as? UserProtocol {
                childVC.user = user
                childVC.userResponses = userResponses
            }

        }
    }
    
    func getUserData() {
        APIController.shared.getUserResponses(userId: TestUser.userID, completion: { (responses, error) in
            if let error = error {
                NSLog("There was error retreiving current User Responses: \(error)")
            } else if let responses = responses {
                self.userResponses = responses
            }
        })
        
    }
    
    var user: User?
    
    var userResponses: [Response]? {
        didSet {
            passToVCs()
        }
    }

}
