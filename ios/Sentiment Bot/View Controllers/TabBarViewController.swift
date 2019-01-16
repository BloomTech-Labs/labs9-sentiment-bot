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
        
        APIController.shared.getUser(userId: 34) { (user, error) in
            self.user = user!
            APIController.shared.getUserResponses(userId: 34, completion: { (responses, error) in
                self.userResponses = responses!
            })
        }

        // Do any additional setup after loading the view.
    }
    
    func passobjectstocontroller() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    var user: User?
    
    var userResponses: [Response]? {
        didSet {
            
        }
    }

}
