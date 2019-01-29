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
        dateLabel.text = response.date
        emojiLabel.text = response.emoji
        feelzNameLabel.text = response.mood.capitalized
        locationLabel.text = response.place
 
        if let imageUrl = response.imageUrl {
            APIController.shared.getImage(url: imageUrl) { (image, error) in
                if let error = error {
                    NSLog("Error getting image \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        self.feelzImageView.image = image
                    }
                }
            }
        }
    }

}
