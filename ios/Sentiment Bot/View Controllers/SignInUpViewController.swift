//
//  SignInUpViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 2/5/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
import AVFoundation

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
    
    var user: User?
    let locationHelper = LocationHelper()
    

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        signUpView.layer.cornerRadius = 10
        signInView.layer.cornerRadius = 10
        googleSignInButton.applyDesign()
        googleSignUpButton.applyDesign()
        signInButton.applyDesign()
        signUpButton.applyDesign()
        
        moinButton.backgroundColor = .clear
        scottButton.backgroundColor = .clear
        
        getUser()
        
        locationHelper.requestLocationAuthorization()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        signInView.center.x -= view.bounds.width
        signUpView.center.x -= view.bounds.width
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        signInView.center.x -= view.bounds.width
        signUpView.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showSignIn()
        
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
    
    private func getUser() {
        
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
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        signInView.center.x -= view.bounds.width
        signUpView.center.x -= view.bounds.width

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
                            let authenticationViewController = self
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

extension SignInUpViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
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
    
    @objc func handleGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func createButton(named: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(named, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        return button
    }
    
}

extension SignInUpViewController {
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            hideSignOut()
            showSignIn()
        case 1:
            hideSignIn()
            showSignOut()
        default:
            break
        }
    }
    
    func showSignIn() {
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
            self.signInView.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func hideSignIn() {
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
            self.signInView.center.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func showSignOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
            self.signUpView.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func hideSignOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
            self.signUpView.center.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
 
}
