//
//  MembersTableViewCell.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/29/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastInLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberImageView.image = UIImage(named: "missing-image-5")
    }
}
