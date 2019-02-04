//
//  GoogleSignInViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/15/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

//This needs to be renamed to AuthenticationViewController
//because now we can log in through google or regular sign in sign up
//We'll do it together to avoid merge conflicts
class GoogleSignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {

            guard let email = user.profile.email,
                let fullName = user.profile.name,
//                let idToken = user.authentication.idToken,
                let profileImageUrl = user.profile.imageURL(withDimension: 400) else {
                    NSLog("Email and Full Name wasn't returned from GoogleSignIn")
                    return
            }

            
            APIController.shared.googleSignIn(email: email, fullName: fullName, imageUrl: profileImageUrl) { (errorMessage) in
                if let errorMessage = errorMessage {
                    NSLog("Error: \(errorMessage)")
                } else {
                    APIController.shared.getUser(userId: UserDefaults.standard.userId) { (user, error) in
                        
                        if let error = error {
                            NSLog("There was error retreiving current User: \(error)")
                        } else if let user = user {
                            self.user = user
                            self.viewDidAppear(true)
                        }
                    }
                }
            }
        }
    }
    
    //Once the backend is implemented we can pass the current user to
    //TabBarViewController and further refactor only doing one api call
    //there instead of two as we're doing right now. 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToHomeScreen" {
            guard let destination = segue.destination as? TabBarViewController else { return }
            destination.user = user
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }
        
        if UserDefaults.standard.userId != 0 {
            guard let user = user else { return }
            DispatchQueue.main.async {
                if user.isAdmin {
                    self.performSegue(withIdentifier: "ToManagerScreen", sender: self)
                } else if user.isTeamMember {
                    self.performSegue(withIdentifier: "ToTeamMemberScreen", sender: self)
                } else {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    let intialVC = mainStoryBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                    self.present(intialVC, animated: true) {
                        
                    }
                }
            }
        }

    }
    
    @objc func handleGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (user, errorMessage) in
            if let errorMessage = errorMessage {
                NSLog(errorMessage.message.joined())
            } else if let user = user {
                DispatchQueue.main.async {
                    if user.isAdmin {
                        self.performSegue(withIdentifier: "ToManagerScreen", sender: self)
                    } else if user.isTeamMember {
                        self.performSegue(withIdentifier: "ToTeamMemberScreen", sender: self)
                    } else {
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)

                        let intialVC = mainStoryBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                        self.present(intialVC, animated: true) {

                        }
                    }
                }
            }
        }
        
        locationHelper.requestLocationAuthorization()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        containerView.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
    }
    
    private func createButton(named: String) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(named, for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.gray, for: .normal)
            return button
    }
    

    var user: User?
    let locationHelper = LocationHelper()
    
    @IBOutlet weak var containerView: UIView!
    
}
