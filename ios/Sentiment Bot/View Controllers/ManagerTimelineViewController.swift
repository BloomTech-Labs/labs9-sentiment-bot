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
    
    var refresher: UIRefreshControl!
    
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
        refresher = UIRefreshControl()
        refresher.tintColor = .white
        //refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(ManagerTimelineViewController.populate), for: UIControl.Event.valueChanged)
        self.managerTimelineTableView.addSubview(refresher)
        managerTimelineTableView.addSubview(refresher)
        managerTimelineTableView.layoutMargins = UIEdgeInsets.zero
        managerTimelineTableView.separatorInset = UIEdgeInsets.zero
        managerTimelineTableView.dataSource = self
        managerTimelineTableView.delegate = self
    }
    
    @objc func populate() {
        APIController.shared.getTeamResponses(teamId: (team?.id)!) { (responses, errorMessage) in
            if let errorMessage = errorMessage {
                
            } else if let responses = responses {
                self.teamResponses = responses
                DispatchQueue.main.async {
                    self.managerTimelineTableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
        }
    }
}

extension ManagerTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamResponses?.count ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refresher == self.refresher
        {
            if scrollView.contentOffset.y < -90  && !self.refresher.isRefreshing{
                self.refresher.beginRefreshing()
                self.populate()
                print("zz refreshing")
            }
        }
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
