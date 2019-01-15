//
//  UserView.swift
//  SentimentBotTest1
//
//  Created by Scott Bennett on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

@IBDesignable class UserView: UIView {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var slackButton: UIButton!
    @IBOutlet weak var feelzNumberLabel: UILabel!
    @IBOutlet weak var lastInLabel: UILabel!
    
    var view: UIView!
    var users: [Response]? = []
    
    // Gives storyboard access to outlets
    @IBInspectable var userImageImage: UIImage? {
        get {
            return userImage.image
        }
        
        set(userImageImage) {
            userImage.image = userImageImage
        }
    }
    
    override func awakeFromNib() {
        APIController.shared.getUserResponses(userId: 44) { (response, error) in
            self.users = response
            
            DispatchQueue.main.async {
                self.feelzNumberLabel.text = "Feelz: \(self.users?.count ?? 0)"
                self.nameLabel.text = users.
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        testCode()
    }

    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil) [0] as! UIView
        
        return view
    }
    
    
    
    @IBAction func connectToSlack(_ sender: UIButton) {
        NSLog("Connecting to Slack....")
    }
    
    func testCode() {
//        feelzNumberLabel.text = "Feelz: 22"
        lastInLabel.text = "Last In: \(dateFormatter.string(from: Date()))"
        feelzNumberLabel.text = "Feelz: \(self.users?.count ?? 0)"
        
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

}
