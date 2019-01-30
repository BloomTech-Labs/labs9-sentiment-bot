//
//  MembersTableViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class MembersTableViewController: UIViewController, ManagerProtocol {
    
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
    
    private func updateViews() {
        
        DispatchQueue.main.async {
            self.teamMembersTableView?.reloadData()
        }
    }
    
    
    @IBOutlet weak var teamMembersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        teamMembersTableView.layoutMargins = UIEdgeInsets.zero
        teamMembersTableView.separatorInset = UIEdgeInsets.zero
        teamMembersTableView.dataSource = self
        teamMembersTableView.delegate = self
    }
    
}

//Todo: Implement remove team member on UI and Backend
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
                DispatchQueue.main.async {
                    self.teamMembers?.remove(at: indexPath.row)
                    self.teamMembersTableView.reloadData()
                }
            }
        }
    }
    
}

