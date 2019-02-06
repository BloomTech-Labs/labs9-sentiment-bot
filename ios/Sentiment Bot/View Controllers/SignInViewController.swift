//
//  SignInViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/17/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var switchLogin = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.25)
        //view.layer.cornerRadius = 20
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
        //googleButton.layer.cornerRadius = googleButton.frame.size.height / 2
        //googleButton.clipsToBounds = true
        setPlaceHolders()
        
        moinButton.backgroundColor = .clear
        scottButton.backgroundColor = .clear
    }
    
    func setPlaceHolders() {
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
            authenticationViewController.robotImageView.alpha = 1
            authenticationViewController.containerView.frame.origin.y += authenticationViewController.view.frame.height/8
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var moinButton: UIButton!
    @IBOutlet weak var scottButton: UIButton!
    
    
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                return
        }
        
        func clearFields() {
            DispatchQueue.main.async {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
           view.endEditing(true)
        }
        
        return false
    }
    

}

// Dismiss Keyboard
extension UIViewController
{
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

extension SignInViewController {

    @IBAction func moinLongin(_ sender: UIButton) {

       if switchLogin {
            switchLogin.toggle()
            emailTextField.setTextWithTypeAnimation(typedText: "moin@moin.com")
        } else {
            switchLogin.toggle()
            passwordTextField.setTextWithTypeAnimation(typedText: "123456")
        }
        
    }
    
    @IBAction func scottLogin(_ sender: UIButton) {
        
        if switchLogin {
            switchLogin.toggle()
            emailTextField.setTextWithTypeAnimation(typedText: "scott@scott.com")
        } else {
            switchLogin.toggle()
            passwordTextField.setTextWithTypeAnimation(typedText: "123456")
        }
    }
    
}

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


