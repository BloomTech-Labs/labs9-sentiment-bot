//
//  FeelingTableViewCell.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/26/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class FeelingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setFeeling(feeling: Feeling?) {
        guard let feeling = feeling else {
                NSLog("Feeling wasn't set on FeelingTableViewCell")
                return
        }
        
        emojiLabel.text = feeling.emoji
        feelingLabel.text = feeling.mood.capitalized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!

}
