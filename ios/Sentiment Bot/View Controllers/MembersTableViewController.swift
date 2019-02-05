//
//  MembersTableViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class MembersTableViewController: UIViewController, ManagerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamMembersTableView: UITableView!
    
    // MARK: - Properties
    
    var teamResponses: [Response]?
    var team: Team?
    var survey: Survey?
    var user: User?
    
    var teamMembers: [User]? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        teamMembersTableView.layoutMargins = UIEdgeInsets.zero
        teamMembersTableView.separatorInset = UIEdgeInsets.zero
        teamMembersTableView.dataSource = self
        teamMembersTableView.delegate = self
        
        if #available(iOS 10.0, *) {
            teamMembersTableView.refreshControl = refreshControl
        } else {
            teamMembersTableView.addSubview(refreshControl)
        }
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        DispatchQueue.main.async {
            self.teamMembersTableView?.reloadData()
        }
    }
    
    // MARK: - Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MembersTableViewController.refreshTeamMembers(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func refreshTeamMembers(_ refreshControl: UIRefreshControl) {
        APIController.shared.getTeamMembers(teamId: (team?.id)!) { (user, errorMessage) in
            if let errorMessage = errorMessage {
                NSLog("Error getting Team Members: \(errorMessage)")
            } else if let user = user {
                self.teamMembers = user
                DispatchQueue.main.async {
                    self.updateViews()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
}

extension MembersTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMembers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersCell") as! MembersTableViewCell
        let teamMember = teamMembers![indexPath.row]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        cell.memberImageView.layer.cornerRadius = cell.memberImageView.frame.size.width / 2
        cell.memberImageView.layer.masksToBounds = true
        cell.nameLabel.text = "\(teamMember.firstName) \(teamMember.lastName)"
        
        var dateString = "None"
        if let surveyDate = teamMember.lastSurveyDate {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: surveyDate)
            inputFormatter.dateFormat = "MMMM dd, yyyy"
            dateString = inputFormatter.string(from: showDate!)
        }
                
        cell.lastInLabel.text = "Last Survey: \(dateString)"
        
        if let imageUrl = teamMember.imageUrl {
            APIController.shared.getImage(url: imageUrl) { (image, error) in
                if let error = error {
                    NSLog("Error getting image \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        cell.memberImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let teamMember = teamMembers![indexPath.row]
            APIController.shared.removeMemberFromTeam(teamId: team!.id, userId: teamMember.id) { (errorMessage) in
            }
            self.teamMembers?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
}

