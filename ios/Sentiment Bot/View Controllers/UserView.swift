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
    
    
    @IBInspectable var userImageImage: UIImage? {
        get {
            return userImage.image
        }
        
        set(userImageImage) {
            userImage.image = userImageImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        testCode()
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
    
    func testCode() {
        lastInLabel.text = dateFormatter.string(from: Date())
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

}
