//
//  UserLikeCell.swift
//  demo_Chat
//
//  Created by DUY on 6/23/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class UserLikeCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgHInh: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgHInh.layer.cornerRadius = 25
        self.imgHInh.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
