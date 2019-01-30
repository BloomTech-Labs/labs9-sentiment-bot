//
//  ManagerTimelineViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTimelineViewController: UIViewController , ManagerProtocol{

    var teamMembers: [User]?
    var team: Team?
    var survey: Survey?
    var user: User?
    
    var teamResponses: [Response]? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        
        DispatchQueue.main.async {
            self.managerTimelineTableView?.reloadData()
        }
    }
    
    @IBOutlet weak var managerTimelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        managerTimelineTableView.layoutMargins = UIEdgeInsets.zero
        managerTimelineTableView.separatorInset = UIEdgeInsets.zero
        managerTimelineTableView.dataSource = self
        managerTimelineTableView.delegate = self
    }
}

extension ManagerTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberFeelzCell") as! ManagerTimelineTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        cell.feelzImageView.layer.cornerRadius = cell.feelzImageView.frame.size.width / 2
        cell.feelzImageView.layer.masksToBounds = true
        let response = teamResponses![indexPath.row]
        
        cell.setResponse(response: response)
        
        return cell

    }
    
}
