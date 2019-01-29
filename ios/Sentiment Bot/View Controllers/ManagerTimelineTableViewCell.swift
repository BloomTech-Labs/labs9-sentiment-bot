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
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    func setResponse(response: Response) {
        dateLabel.text = response.date
        emojiLabel.text = response.emoji
        feelzNameLabel.text = response.mood
        placeLabel.text = response.place
        userIdLabel.text = "\(response.userId)"
        
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

}
