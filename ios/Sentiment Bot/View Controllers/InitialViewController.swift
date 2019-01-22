//
//  InitialViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/22/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var teamCodeTextField: UITextField!
    
    @IBOutlet weak var teamNameTextField: UITextField!
    
    
    @IBAction func joinTeam(_ sender: Any) {
//        guard let teamCode: Int = Int(teamCodeTextField.text!) else { return }
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let teamMemberTVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        present(teamMemberTVC, animated: false) {
            
        }
    }
    
    @IBAction func createTeam(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let managerTVC = mainStoryBoard.instantiateViewController(withIdentifier: "ManagerTabBarViewController") as! ManagerTabBarViewController
        present(managerTVC, animated: false) {
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
