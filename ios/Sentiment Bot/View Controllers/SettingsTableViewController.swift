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
        themeSelector.layer.cornerRadius = 5.0
        themeSelector.clipsToBounds = true
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
    
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
    
    @IBAction func themeSelector(_ sender: Any) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()
            reloadViewFromNib()
            setNavigationBarTint()
        }
    }
    
    func setNavigationBarTint() {
        let themeInt = UserDefaults.standard.integer(forKey: "SelectedTheme")
        
        switch themeInt {
        case 0:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case 1:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        default:
            NSLog("Theme not picked")
        }
    }

    @IBAction func doneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
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
        
        guard let user = user else {
            NSLog("User wasn't passed to SettingsViewController")
            return 0
        }
        
        if section == 0 {
            return 1
        }
        if section == 1 && !user.isAdmin {
            return 0
        }
        if section == 2 && user.isAdmin {
            return 2
        } else if section == 2 && !user.isAdmin{
            return 3
        }
        return 1
    }
    
    func leaveTeam() {
        
        guard let user = user else {
            NSLog("User wasn't set on SettingsViewController")
            return
        }
        let alert = UIAlertController(title: "Are You Sure?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak alert] (_) in
            APIController.shared.removeMemberFromTeam(teamId: user.teamId!, userId: user.id, completion: { (errorMessage) in
                DispatchQueue.main.async {
                    self.logout(self)
                }

            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [weak alert] (_) in
            
        }))
        
        present(alert, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (user?.isAdmin)! {
            if indexPath.row == 0 && indexPath.section == 1 {
                toggleSubscrption()
            }
        } else if !(user?.isAdmin)! {
            if indexPath.row == 2 && indexPath.section == 2 {
                leaveTeam()
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


