//
//  SettingsTableViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/29/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
import Stripe
class SettingsTableViewController: UITableViewController, STPAddCardViewControllerDelegate {
    
    var user: User?
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (user?.subscribed)! {
            self.subscriptionLabel.text = "Cancel"
        } else if !user!.subscribed {
           self.subscriptionLabel.text = "Subscribe"
        }
        themeSelector.selectedSegmentIndex = Theme.current.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func subscribe(_ sender: UIButton) {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        addCardViewController.title = "Subscribe to Premium"
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    var stripeToken: String?

    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        title = "Subscribe to Premium"
        stripeToken = token.tokenId
        print("Printing Strip response:\(token.allResponseFields)\n\n")
        print("Printing Strip Token:\(token.tokenId)")
        
        
        StripeController.shared.subscribeToPremium(token: stripeToken!) { (error) in
            DispatchQueue.main.async {
                self.subscriptionLabel.text = "Cancel"
                self.dismiss(animated: true)
            }
            self.user?.subscribed = true
        }
        
    }
    
    @IBAction func themeSelector(_ sender: Any) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()
            //self.tableView.reloadData()
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
        if (user?.subscribed)! {
            StripeController.shared.cancelPremiumSubscription { (error) in
                DispatchQueue.main.async {
                    self.subscriptionLabel.text = "Subscribe"
                }
                self.user?.subscribed = false
            }
            return
        }
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        addCardViewController.title = "Subscribe to Premium"
        
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        //self.navigationController?.pushViewController(addCardViewController, animated: true)
        present(navigationController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 && !(user?.isAdmin)! {
            return 0
        }
        if section == 2 {
            return 3
        }
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (user?.isAdmin)! {
            if indexPath.row == 0 && indexPath.section == 1 {
                toggleSubscrption()
            }
        }

        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
 

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section ==  1 && !(user?.isAdmin)! {
           return 0
        }
        return tableView.sectionHeaderHeight
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

