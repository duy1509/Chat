//
//  CommandCell.swift
//  demo_Chat
//
//  Created by DUY on 6/28/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class CommandCell: UITableViewCell {
    @IBOutlet weak var imgHinhProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCommand: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgHinhProfile.layer.cornerRadius = 25
        self.imgHinhProfile.layer.masksToBounds = true

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
