//
//  ManagerTimelineTableViewCell.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/29/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var feelzNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var feelzImageView: UIImageView!
    
    func setResponse(response: Response) {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: response.date)
        inputFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = inputFormatter.string(from: showDate!)
        
        dateLabel.text = dateString
        emojiLabel.text = response.emoji
        feelzNameLabel.text = response.mood.capitalized
        
        APIController.shared.getUser(userId: response.userId) { (user, error) in
            if let error = error {
                NSLog("Error getting user name \(error)")
            } else if let user = user {
                DispatchQueue.main.async {
                    self.userIdLabel.text = "\(user.firstName) \(user.lastName)"
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feelzImageView.image = UIImage(named: "missing-image-5")
    }

}
