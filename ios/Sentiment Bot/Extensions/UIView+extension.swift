//
//  UIView+extension.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 2/7/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView {
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
