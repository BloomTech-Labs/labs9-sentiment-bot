//
//  TimeLineTableViewCell.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/13/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var feelzNameLabel: UILabel!
    @IBOutlet weak var feelzImageView: UIImageView!
    
    func setResponse(response: Response) {
        //dateLabel.text = formatter.string(from: response.date)
        dateLabel.text = response.date
        emojiLabel.text = response.emoji
        feelzNameLabel.text = response.mood
        feelzImageView.image = #imageLiteral(resourceName: "stevejobs.jpeg")
        locationLabel.text = "New York, NY"
    }
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
