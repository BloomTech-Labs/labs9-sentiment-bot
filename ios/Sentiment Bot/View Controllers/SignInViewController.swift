//
//  SignInViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/17/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
class SignInViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.25)

    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                return
        }
        
        APIController.shared.logIn(email: email, password: password) { (error) in
            
            if let error = error {
                //Better Error handling would be to show user error
                //becuase the error that is retreived here may say something like
                // "Password field cannot be empty", etc.
                NSLog("Error logging in \(error)")
            } else {
                DispatchQueue.main.async {
                    let authenticationViewController = self.parent?.parent?.parent as! GoogleSignInViewController
                    authenticationViewController.performSegue(withIdentifier: "ToHomeScreen", sender: self)
                }

            }
        }
    }
    
}
