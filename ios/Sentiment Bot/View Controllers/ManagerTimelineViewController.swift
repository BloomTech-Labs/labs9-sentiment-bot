//
//  ManagerTimelineViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTimelineViewController: UIViewController {

    var user: User?
    
    var teamMembersResponses: [Response]? {
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
    }
}

extension ManagerTimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMembersResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = teamMembersResponses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberFeelzCell") as! TimeLineTableViewCell
        //cell.setResponse(response: response)
        cell.textLabel?.text = response.emoji
        return cell
    }
    
}
