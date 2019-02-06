//
//  SignUpViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/17/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignUpViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.25)
        //view.layer.cornerRadius = 20
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        //googleButton.layer.cornerRadius = googleButton.frame.size.height / 2
        //googleButton.clipsToBounds = true
        setPlaceHolders()
    }
    
    
    func setPlaceHolders() {
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name:",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email:",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password:",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let authenticationViewController = self.parent?.parent?.parent as! GoogleSignInViewController
        UIView.animate(withDuration: 0.3) {
            authenticationViewController.robotImageView.alpha = 0
            authenticationViewController.containerView.frame.origin.y -= authenticationViewController.view.frame.height/8
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let authenticationViewController = self.parent?.parent?.parent as! GoogleSignInViewController
        UIView.animate(withDuration: 0.3) {
            authenticationViewController.containerView.frame.origin.y += authenticationViewController.view.frame.height/8
            authenticationViewController.robotImageView.alpha = 1
        }
    }
    
    @IBAction func googleSignUp(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        func clearFields() {
            DispatchQueue.main.async {
                self.firstNameTextField.text = ""
                self.lastNameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
        
        APIController.shared.signUp(firstName: firstName, lastName: lastName, email: email, password: password) { (errorMessage) in
            
            if let errorMessage = errorMessage {
                //Better Error handling would be to show user error
                //becuase the error that is retreived here may say something like
                // "Password field cannot be empty", etc.
                NSLog("Error signing up \(errorMessage)")
            } else {
                DispatchQueue.main.async {
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    let intialVC = mainStoryBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                    self.present(intialVC, animated: true) {
                        clearFields()
                    }
                }
                
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


