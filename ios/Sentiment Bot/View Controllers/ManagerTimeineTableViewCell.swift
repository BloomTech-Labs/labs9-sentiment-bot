//
//  ManagerTimeineTableViewCell.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/27/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class ManagerTimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var feelzNameLabel: UILabel!
    @IBOutlet weak var feelzImageView: UIImageView!
    @IBOutlet weak var responseID: UILabel!
    
    func setResponse(response: Response) {
        dateLabel.text = response.date
        emojiLabel.text = response.emoji
        feelzNameLabel.text = response.mood
        
    }
    
}
