//
//  TimeLineTableViewCell.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/13/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

protocol TimeLineTableViewCellDelegate: class {
    func selectImage(on cell: TimeLineTableViewCell)
}
class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var feelzNameLabel: UILabel!
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
        
        if response.place == "N/A" {
            locationLabel.text = ""
        } else {
           locationLabel.text = response.place
        }
        
 

    }
    
    @IBAction func selectImage(_ sender: Any) {
        delegate?.selectImage(on: self)
    }
    
    weak var delegate: TimeLineTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if Theme.current == .light {
            feelzImageView.image = UIImage(imageLiteralResourceName: "plus-grey")
        } else {
            feelzImageView.image = UIImage(imageLiteralResourceName: "plus-grey")
        }
    }
}
