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
        teamMembersTableView.delegate = self
    }
}

extension MembersTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMembers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let response = teamMembers![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersCell") as! TimeLineTableViewCell
        //cell.setResponse(response: response)
        cell.textLabel?.text = "\(response.firstName) \(response.lastName)"
        return cell
    }
    
}

