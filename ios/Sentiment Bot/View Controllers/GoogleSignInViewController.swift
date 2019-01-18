//
//  GoogleSignInViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/15/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
class GoogleSignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {

            guard let email = user.profile.email,
                let fullName = user.profile.name else {
                    NSLog("Email and Full Name wasn't returned from GoogleSignIn")
                    return
            }
            
            performSegue(withIdentifier: "ToHomeScreen", sender: self)
        
            // TODO: - This will be implemented once the back-end is finished.
            APIController.shared.googleSignIn(email: email, fullName: fullName) { (user, error) in
                if let error = error {
                    NSLog("Error: \(error)")
                } else if let user = user {
                    NSLog("User: \(user)")
                }
            }
            //This will deleted once backend is complete
            //This is only for test
            APIController.shared.getUser(userId: TestUser.userID) { (user, error) in
                if let error = error {
                    NSLog("There was error retreiving current User: \(error)")
                } else if let user = user {
                    self.user = user
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
        performSegue(withIdentifier: "ToHomeScreen", sender: self)
    }
    
    @objc func handleGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        let GoogleSignInButton = createButton(named: "")
        let googleimage = UIImage(named: "GoogleSignIn")
        let googleSignUpImage = UIImage(named: "GoogleSignUp")
        let GoogleSignUpButton = createButton(named: "")
        GoogleSignUpButton.setBackgroundImage(googleSignUpImage, for: .normal)
        GoogleSignInButton.setBackgroundImage(googleimage, for: .normal)
        GoogleSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        GoogleSignUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        let stackView = UIStackView(arrangedSubviews: [GoogleSignInButton, GoogleSignUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        GoogleSignInButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
        GoogleSignUpButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
        view.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
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

}
