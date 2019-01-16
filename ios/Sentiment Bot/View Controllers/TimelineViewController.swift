//
//  TimelineViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UserProtocol {

    var user: User?
    
    var userResponses: [Response]?
    

    @IBOutlet weak var timelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }    
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = userResponses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelzCell") as! TimeLineTableViewCell
        cell.setResponse(response: response)
        return cell
    }
    
    
}
