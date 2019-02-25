//
//  JoinCreateViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/30/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class JoinCreateViewController: UIViewController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (user, errorMessage) in
            if let errorMessage = errorMessage {
                NSLog("Error getting user \(errorMessage)")
            } else if let user = user {
                self.user = user
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        joinTeamButton.applyDesign()
        createTeamButton.applyDesign()
    }
    
    var userInput: String?
    
    @IBOutlet weak var joinTeamButton: UIButton!
    @IBOutlet weak var createTeamButton: UIButton!
    
    @IBAction func joinTeam(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Team Code", message: "Enter Code", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Code:"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.userInput = textField.text
            let teamCode = Int(self.userInput!)!
            APIController.shared.joinTeam(code: teamCode) { (_, errorMessage) in
                if let errorMessage = errorMessage {
                    print(errorMessage)
                } else {
                    DispatchQueue.main.async {
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let teamMemberTVC = mainStoryBoard.instantiateViewController(withIdentifier: "UserTabBarContainerViewController") as! UserTabBarContainerViewController
                        self.present(teamMemberTVC, animated: false)
                    }
                }
            }
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [] (_) in
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func createTeam(_ sender: Any) {
        let alert = UIAlertController(title: "Team Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name:"
        }
        
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.userInput = textField.text
            APIController.shared.createTeam(userId: self.user!.id, teamName: self.userInput!, completion: { (errorMessage) in
                if let errorMessage = errorMessage {
                    print(errorMessage)
                } else {
                    DispatchQueue.main.async {
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let managerTVC = mainStoryBoard.instantiateViewController(withIdentifier: "ManagerTabBarContainerViewController") as! ManagerTabBarContainerViewController
                        self.present(managerTVC, animated: false)
                    }
                }
            })
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [] (_) in
        }))
        
        present(alert, animated: true)
        
    }
    
}

