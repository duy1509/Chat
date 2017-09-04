//
//  TinNhanTBVCell.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class TinNhanTBVCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNoiDung: UILabel!
    @IBOutlet weak var imgHinhProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgHinhProfile.layer.cornerRadius = 25
        self.imgHinhProfile.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
