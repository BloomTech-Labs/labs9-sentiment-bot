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

    func setResponse(response: Response) {
//        nameLabel.text = "\(response.firstName) \(response.lastName)"
//        cell?.imageView?.layer.cornerRadius = 45 //(cell?.imageView?.frame.size.width)! / 2
//        cell?.imageView?.clipsToBounds = true
//        cell?.imageView?.image = #imageLiteral(resourceName: "missing-image-5")
    }

}
