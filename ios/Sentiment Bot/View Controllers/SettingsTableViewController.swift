//
//  SettingsTableViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/29/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeSelector.selectedSegmentIndex = Theme.current.rawValue

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func themeSelector(_ sender: Any) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()

        }
    }

    @IBAction func doneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.view.window!.rootViewController?.dismiss(animated: true)
        GIDSignIn.sharedInstance()?.signOut()
        APIController.shared.logout()
    }
    
    private func toggleSubscrption() {
        print("Subscribed")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 && indexPath.section == 1 {
            toggleSubscrption()
        }
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    
}

//OLD CODE
//
//  ProfileViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//
//
//import UIKit
//import GoogleSignIn
//
//class ProfileViewController: UIViewController {
//
//    @IBOutlet weak var profileView: UIView!
//    @IBOutlet weak var teamId: UITextField!
//    @IBOutlet weak var themeSelector: UISegmentedControl!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        profileView.layer.cornerRadius = 10
//
//        themeSelector.selectedSegmentIndex = Theme.current.rawValue
//    }
//
//    @IBAction func applyTheme(_ sender: UIButton) {
//        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
//            selectedTheme.apply()
//        }
//        dismiss(animated: true)
//    }
//
//    @IBAction func logOutButton(_ sender: UIButton) {
//        self.view.window!.rootViewController?.dismiss(animated: true)
//        GIDSignIn.sharedInstance()?.signOut()
//        APIController.shared.logout()
//    }
//
//    @IBAction func cancelButton(_ sender: UIButton) {
//        dismiss(animated: true)
//    }
//
//    @IBOutlet weak var subscriptionButton: UIButton!
//
//    @IBAction func toggleSubscription(_ sender: Any) {
//    }
//
//
//}

