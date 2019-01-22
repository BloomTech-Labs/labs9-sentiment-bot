//
//  ManagerTabBarViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    func passToVCs() {
        for childVC in children {
            
            if var childVC = childVC as? ManagerProtocol {
                
                childVC.user = user
                childVC.teamResponses = teamResponses
                childVC.survey = team?.survey
                childVC.teamMembers = team?.users
                childVC.team = team
            }
            
        }
    }
    
    func getUserData() {
        
        APIController.shared.getManagingTeam(userId: 1) { (team, errorMessage) in
            if let errorMessage = errorMessage {
                print(errorMessage)
            } else {
                self.team = team
                guard let team = team else {
                    NSLog("Problem unwrapping team in ManagerTabBarViewController")
                    return
                }
                
                APIController.shared.getTeamResponses(teamId: team.id, completion: { (responses, error) in
                    if let error = error {
                        NSLog("There was error retreiving User's Team Responses: \(error)")
                    } else if let responses = responses {
                        APIController.shared.getUser(userId: 1, completion: { (user, errorMessage) in
                            self.user = user
                            self.teamResponses = responses
                        })
                    }
                })
            }
        }
        
    }
    
    var user: User?
    var team: Team?
    
    var teamResponses: [Response]? {
        didSet {
            passToVCs()
        }
    }
    
}
