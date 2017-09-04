//
//  Conversations.swift
//  demo_Chat
//
//  Created by DUY on 7/22/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class Conversations: UITableViewCell {

    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
        self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.borderWidth = 2
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
    }

}
    class ContactsCVCell: UICollectionViewCell {
        
        @IBOutlet weak var profilePic: RoundedImageView!
        @IBOutlet weak var nameLabel: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
}
