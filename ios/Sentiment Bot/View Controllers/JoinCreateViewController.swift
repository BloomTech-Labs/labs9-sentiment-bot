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
    
    @IBOutlet weak var teamCodeTextField: UITextField!
    
    @IBOutlet weak var teamNameTextField: UITextField!
    
    
    @IBAction func joinTeam(_ sender: Any) {
        guard let teamCode: Int = Int(teamCodeTextField.text!) else { return }
        
        
        APIController.shared.joinTeam(code: teamCode) { (_, errorMessage) in
            if let errorMessage = errorMessage {
                print(errorMessage)
            } else {
                DispatchQueue.main.async {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let teamMemberTVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.present(teamMemberTVC, animated: false)
                }
            }
        }
    }
    
    @IBAction func createTeam(_ sender: Any) {
        
        guard let teamName = teamNameTextField.text else { return }
        
        APIController.shared.createTeam(userId: UserDefaults.standard.userId, teamName: teamName) { (errorMessage) in
            
            if let errorMessage = errorMessage {
                print(errorMessage)
            } else {
                
                DispatchQueue.main.async {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let managerTVC = mainStoryBoard.instantiateViewController(withIdentifier: "ManagerTabBarViewController") as! ManagerTabBarViewController
                    self.present(managerTVC, animated: false)
                }
            }
        }
    }
    
}

