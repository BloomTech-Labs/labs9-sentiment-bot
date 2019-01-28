//
//  ManagmentViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/26/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import Stripe
class ManagementViewController: UIViewController, STPAddCardViewControllerDelegate, ManagerProtocol {
    var user: User?
    
    var teamResponses: [Response]?
    
    var team: Team?
    
    var survey: Survey?
    
    var teamMembers: [User]?
    
    private func setSchedule() {
        guard let survey = survey else {
            NSLog("Survey wasn't set on ManagementViewController")
            return
        }
        currentScheduleLabel.text = "Current Schedule: \(survey.schedule.capitalized)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSchedule()
    }
    
    
    //@IBOutlet weak var msgBox: UITextView!
    
    @IBOutlet weak var currentScheduleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Standard"
        //msgBox.text = ""
//        if (user?.subscribed)! {
//            subscribeButton.isHidden = true
//        } else {
//            cancelButton.isHidden = true
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (user?.subscribed)! {
            subscriptionButton.setTitle("Cancel", for: .normal)
        } else if !(user?.subscribed)! {
            subscriptionButton.setTitle("Subscribe", for: .normal)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func cancelSubscription(_ sender: Any) {
        StripeController.shared.cancelPremiumSubscription { (errorMessage) in
            
        }
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
        self.navigationController?.pushViewController(addCardViewController, animated: true)
        //present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        //dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    var stripeToken: String?
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        addCardViewController.title = "Subscribe to Premium"
        stripeToken = token.tokenId
        dismiss(animated: true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        StripeController.shared.subscribeToPremium(token: stripeToken!) { (error) in
            DispatchQueue.main.async {
                self.subscriptionButton.setTitle("Cancel", for: .normal)
                self.navigationController?.popViewController(animated: true)
            }
            self.user?.subscribed = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSendSurveyViewController" {
            let destination = segue.destination as! SendSurveyViewController
            destination.teamResponses = teamResponses
            destination.survey = survey
            destination.user = user
            destination.team = team
        }
     }


}
