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
            
        }
    }
    

    
    //Scott you can delete this comment, but I was debugging and kept deleting the app and debugging
    //realizing it didn't redirect to TimeLineVC so I had to implement this
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }
        performSegue(withIdentifier: "ToHomeScreen", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        signInButton.center = view.center
        //signInButton.addTarget(self, action: #selector(sign), for: .touchUpInside)
        
        view.addSubview(signInButton)
    }

}
