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
        managerTimelineTableView.dataSource = self
        managerTimelineTableView.delegate = self
    }
}

extension ManagerTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberFeelzCell")
        let response = teamResponses![indexPath.row]
        
        //cell.setResponse(response: response)
        cell?.textLabel?.text = "\(response.emoji)  \(response.mood)"
        cell?.detailTextLabel?.text = "\(response.date)"
        return cell ?? UITableViewCell()

    }
    
}
