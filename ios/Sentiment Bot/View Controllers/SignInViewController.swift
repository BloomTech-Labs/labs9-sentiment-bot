//
//  SignInViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/17/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
//                let GoogleSignInButton = createButton(named: "")
//                let googleimage = UIImage(named: "GoogleSignIn")
//                let googleSignUpImage = UIImage(named: "GoogleSignUp")
//                let GoogleSignUpButton = createButton(named: "")
//                GoogleSignUpButton.setBackgroundImage(googleSignUpImage, for: .normal)
//                GoogleSignUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
//                GoogleSignInButton.imageView?.contentMode = .scaleAspectFit
//                GoogleSignUpButton.imageView?.contentMode = .scaleAspectFit
//                let stackView = UIStackView(arrangedSubviews: [GoogleSignInButton, GoogleSignUpButton])
//                stackView.translatesAutoresizingMaskIntoConstraints = false
//                stackView.axis = .vertical
//                stackView.spacing = 20
//                stackView.distribution = .fillEqually
//                //GoogleSignInButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
//                //GoogleSignUpButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
//                view.addSubview(stackView)
//        
//                stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//                //stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.center.y + 25).isActive = true
//                stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//                stackView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
    }
    
    private func createButton(named: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(named, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        return button
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
