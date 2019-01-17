//
//  TimelineViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class TimelineViewController: UIViewController {

    @IBOutlet weak var timelineTableView: UITableView!
    
    var responses: [Response]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        APIController.shared.getUserResponses(userId: TestUser.userID) { (responses, error) in
            DispatchQueue.main.async {
                self.responses = responses
                self.timelineTableView.reloadData()
            }
        }
    }
    
    // TODO: - ViewDidAppear not running after modal, fix
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let userAuth = GIDSignIn.sharedInstance()?.hasAuthInKeychain() else { return }
        if !userAuth {
            NSLog("User not logged in")
        } else {
            NSLog("User still logged in")
        }
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = responses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelzCell") as! TimeLineTableViewCell
        cell.setResponse(response: response)
        return cell
    }
    
}
