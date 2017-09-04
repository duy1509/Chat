//
//  danhbaTBVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class danhbaTBVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgHinhprofile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgHinhprofile.layer.cornerRadius = 25
        self.imgHinhprofile.layer.masksToBounds = true
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
