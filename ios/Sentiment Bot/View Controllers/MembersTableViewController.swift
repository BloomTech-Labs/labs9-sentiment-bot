//
//  MembersTableViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class MembersTableViewController: UIViewController, ManagerProtocol {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersCell")
        let response = teamMembers![indexPath.row]

        //cell.setResponse(response: response)
        cell?.textLabel?.text = "\(response.firstName) \(response.lastName)"
        cell?.imageView?.layer.cornerRadius = 45 //(cell?.imageView?.frame.size.width)! / 2
        cell?.imageView?.clipsToBounds = true
        cell?.imageView?.image = #imageLiteral(resourceName: "missing-image-5")
        return cell!
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

