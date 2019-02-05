//
//  TabBarViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/16/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .white
//        setupButton()
        
        getUserData()
        guard let deviceToken = UserDefaults.standard.deviceToken else {
            NSLog("Device Token wasn't set to User's Defaults")
            return
        }
        locationHelper.saveLocation()
        APIController.shared.saveDeviceToken(userId: UserDefaults.standard.userId, deviceToken: deviceToken) { (errorMessage) in
            
        }
    }
    
    func passToVCs() {
        for childVC in children {
            guard let userResponses = userResponses
                else { return }
            
            if var childVC = childVC as? UserProtocol {
                childVC.user = user
                childVC.userResponses = userResponses
            }
        }
    }
    
    func getUserData() {
        APIController.shared.getUserResponses(userId: UserDefaults.standard.userId, completion: { (responses, error) in
            if let error = error {
                NSLog("There was error retreiving current User Responses: \(error)")
            } else if let responses = responses {
                self.userResponses = responses
            }
        })        
    }
    
    // Manually selects the center button of tabbar
//    @IBAction func popup(sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true, completion: nil)
//        selectedIndex = 1
//    }
    
//    func setupButton() {
//        // Custom Button for center tab
//        let window = UIApplication.shared.keyWindow
//        let bottomPadding = window?.safeAreaInsets.bottom
//        let itemWidth = view.frame.size.width / 5
//        let itemHeight = tabBar.frame.size.height
//        let button = UIButton(frame: CGRect(origin: CGPoint(x: itemWidth * 2, y: view.frame.size.height - itemHeight - bottomPadding! - 10), size: CGSize(width: itemWidth, height: itemHeight)))
//        button.setBackgroundImage(#imageLiteral(resourceName: "plus-1"), for: .normal)
//        button.adjustsImageWhenHighlighted = false
//        button.sizeToFit()
//        button.addTarget(self, action: #selector(popup(sender:)), for: .touchUpInside)
//        view.addSubview(button)
//    }
    
    var user: User?
    let locationHelper = LocationHelper()
    var userResponses: [Response]? {
        didSet {
            passToVCs()
        }
    }

}
