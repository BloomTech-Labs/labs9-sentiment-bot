//
//  SignInUpViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 2/5/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var moinButton: UIButton!
    @IBOutlet weak var scottButton: UIButton!
    
    // MARK: - Properties
    
    var switchLogin = true

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.layer.cornerRadius = 5
        signInView.layer.cornerRadius = 5
        
        signInView.isHidden = false
        signUpView.isHidden = true

    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            signInView.isHidden = false
            signUpView.isHidden = true
        case 1:
            signInView.isHidden = true
            signUpView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let email = signInEmailTextField.text,
            let password = signInPasswordTextField.text else {
                return
        }
        
        func clearFields() {
            DispatchQueue.main.async {
                self.signInEmailTextField.text = ""
                self.signInPasswordTextField.text = ""
            }
        }
        
        APIController.shared.logIn(email: email, password: password) { (error) in
            
            if let error = error {
                //Better Error handling would be to show user error
                //becuase the error that is retreived here may say something like
                // "Password field cannot be empty", etc.
                NSLog("Error logging in \(error)")
            } else {
                
                APIController.shared.getUser(userId: UserDefaults.standard.userId) { (user, error) in
                    
                    if let error = error {
                        NSLog("There was error retreiving current User: \(error)")
                    } else if let user = user {
                        clearFields()
                        DispatchQueue.main.async {
                            let authenticationViewController = self.parent?.parent?.parent as! GoogleSignInViewController
                            if user.isAdmin {
                                authenticationViewController.performSegue(withIdentifier: "ToManagerScreen", sender: self)
                            } else if user.isTeamMember {
                                authenticationViewController.performSegue(withIdentifier: "ToTeamMemberScreen", sender: self)
                            } else {
                                let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                
                                let intialVC = mainStoryBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                                self.present(intialVC, animated: true) {
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = signUpEmailTextField.text,
            let password = signUpPasswordTextField.text else {
                return
        }
        
        func clearFields() {
            DispatchQueue.main.async {
                self.firstNameTextField.text = ""
                self.lastNameTextField.text = ""
                self.signUpEmailTextField.text = ""
                self.signUpPasswordTextField.text = ""
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

    
    @IBAction func googleSignUP(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signInEmailTextField {
            signInPasswordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return false
    }

}

// For testing, auto logins
extension SignInUpViewController {
    
    @IBAction func moinLongin(_ sender: UIButton) {
        if switchLogin {
            switchLogin.toggle()
            signInEmailTextField.setTextWithTypeAnimation(typedText: "moin@moin.com")
        } else {
            switchLogin.toggle()
            signInPasswordTextField.setTextWithTypeAnimation(typedText: "123456")
        }
    }
    
    @IBAction func scottLogin(_ sender: UIButton) {
        if switchLogin {
            switchLogin.toggle()
            signInEmailTextField.setTextWithTypeAnimation(typedText: "scott@scott.com")
        } else {
            switchLogin.toggle()
            signInPasswordTextField.setTextWithTypeAnimation(typedText: "123456")
        }
    }
}

// Typewriter Effect
extension UITextField {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
}
