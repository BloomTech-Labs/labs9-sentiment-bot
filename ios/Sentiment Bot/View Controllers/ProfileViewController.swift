//
//  ProfileViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var teamId: UITextField!
    @IBOutlet weak var themeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.layer.cornerRadius = 10
        
        themeSelector.selectedSegmentIndex = Theme.current.rawValue
    }
    
    @IBAction func applyTheme(_ sender: UIButton) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()
        }
        dismiss(animated: true)
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true)
        GIDSignIn.sharedInstance()?.signOut()
        APIController.shared.logout()
        self.view.window!.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
