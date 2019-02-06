//
//  UIButton+extension.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 2/5/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

extension UIButton {
    
    func applyDesign() {

        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.white, for: .normal)
        
        if Theme.current == .light {
            self.backgroundColor = .mainColorLight
        } else {
            self.backgroundColor = .mainColorDark
        }
    }
    
    func applyShadow() {

        self.backgroundColor = UIColor.darkGray
        self.layer.borderWidth = 2.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//         Put frame around button
//                userImageButton.layer.borderColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
    }
}

//private func createButton(named: String) -> UIButton {
//    let button = UIButton()
//    button.translatesAutoresizingMaskIntoConstraints = false
//    button.setTitle(named, for: .normal)
//    button.backgroundColor = .white
//    button.setTitleColor(.gray, for: .normal)
//    return button
//}
