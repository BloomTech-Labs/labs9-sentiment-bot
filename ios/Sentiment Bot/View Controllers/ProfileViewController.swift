//
//  ProfileViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
import Stripe
class ProfileViewController: UIViewController, STPAddCardViewControllerDelegate {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var teamId: UITextField!
    @IBOutlet weak var themeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (user, errorMessage) in
            if let errorMessage = errorMessage {
                
            } else if let user = user {
                self.user = user
                DispatchQueue.main.async {
                    if user.subscribed {
                        self.subscriptionButton.setTitle("Cancel", for: .normal)
                    } else if !user.subscribed {
                        self.subscriptionButton.setTitle("Subscribe", for: .normal)
                    }
                }
            }
        }
        profileView.layer.cornerRadius = 10
        
        themeSelector.selectedSegmentIndex = Theme.current.rawValue
    }
    
    @IBAction func applyTheme(_ sender: UIButton) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()
        }
        dismiss(animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//            if (user?.subscribed)! {
//                subscriptionButton.setTitle("Cancel", for: .normal)
//            } else if !(user?.subscribed)! {
//                subscriptionButton.setTitle("Subscribe", for: .normal)
//            }
//    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true)
        GIDSignIn.sharedInstance()?.signOut()
        APIController.shared.logout()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var subscriptionButton: UIButton!
    
    @IBAction func toggleSubscription(_ sender: UIButton) {
        if (user?.subscribed)! {
            StripeController.shared.cancelPremiumSubscription { (error) in
                DispatchQueue.main.async {
                    self.subscriptionButton.setTitle("Subscribe", for: .normal)
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
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
    
    var stripeToken: String?
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        addCardViewController.title = "Subscribe to Premium"
        stripeToken = token.tokenId
        StripeController.shared.subscribeToPremium(token: stripeToken!) { (error) in
            
            DispatchQueue.main.async {
                self.subscriptionButton.setTitle("Cancel", for: .normal)
                self.dismiss(animated: true)
            }
            self.user?.subscribed = true
        }
    }
    
//    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
////        guard let stripeToken = stripeToken else {
////            dismiss(animated: true)
////            return
////        }
//        StripeController.shared.subscribeToPremium(token: stripeToken!) { (error) in
//
//            DispatchQueue.main.async {
//                self.subscriptionButton.setTitle("Cancel", for: .normal)
//                self.navigationController?.popViewController(animated: true)
//            }
//            self.user?.subscribed = true
//        }
//    }
//
    var user: User?
    
    
}
