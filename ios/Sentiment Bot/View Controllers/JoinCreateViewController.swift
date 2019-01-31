//
//  JoinCreateViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/30/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class JoinCreateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var userInput: String?
    
    
    @IBAction func joinTeam(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Team Code", message: "Enter Code", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Code:"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
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
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func createTeam(_ sender: Any) {
        
        
        
        APIController.shared.createTeam(userId: UserDefaults.standard.userId, teamName: "sas") { (errorMessage) in
            
            if let errorMessage = errorMessage {
                print(errorMessage)
            } else {
                
                DispatchQueue.main.async {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let managerTVC = mainStoryBoard.instantiateViewController(withIdentifier: "ManagerTabBarContainerViewController") as! ManagerTabBarContainerViewController
                    self.present(managerTVC, animated: false)
                }
            }
        }
    }
    
}

