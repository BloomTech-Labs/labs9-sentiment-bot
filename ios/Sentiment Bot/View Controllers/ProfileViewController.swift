//
//  ProfileViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var teamId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.layer.cornerRadius = 10
    }
    

    @IBAction func joinTeamButton(_ sender: UIButton) {
        NSLog("Team ID: \(teamId.text ?? "")")
        dismiss(animated: true)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        NSLog("Log Out")
        dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        NSLog("Cancel")
        dismiss(animated: true)
    }
    
}
