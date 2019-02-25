//
//  ManagerTimelineViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTimelineViewController: UIViewController , ManagerProtocol{
    
    // MARK: - Outlets
    
    @IBOutlet weak var managerTimelineTableView: UITableView!
    
    // MARK: - Properties

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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerTimelineTableView.layoutMargins = UIEdgeInsets.zero
        managerTimelineTableView.separatorInset = UIEdgeInsets.zero
        managerTimelineTableView.dataSource = self
        managerTimelineTableView.delegate = self
        //self.managerTimelineTableView.addSubview(self.refreshControl)
        managerTimelineTableView.refreshControl = refreshControl
    }
    
    // MARK: - Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ManagerTimelineViewController.refreshTeamResponses(_:)), for: .valueChanged)
       // refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func refreshTeamResponses(_ refreshControl: UIRefreshControl) {
        APIController.shared.getTeamResponses(teamId: (team?.id)!) { (responses, errorMessage) in
            if let errorMessage = errorMessage {
                NSLog("Error getting TeamResponses \(errorMessage)")
            } else if let responses = responses {
                self.teamResponses = responses
                DispatchQueue.main.async {
                    self.managerTimelineTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
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
        if let imageUrl = response.imageUrl {
            APIController.shared.getImage(url: imageUrl) { (image, error) in
                if let error = error {
                    NSLog("Error getting image \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        cell.feelzImageView.image = image
                    }
                }
            }
        }
        cell.setResponse(response: response)
        
        return cell

    }
    
}
