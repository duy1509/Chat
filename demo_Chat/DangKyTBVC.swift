//
//  DangKyTBVC.swift
//  demo_Chat
//
//  Created by DUY on 6/20/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class DangKyTBVC: UITableViewCell {

    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnDangKy(_ sender: Any) {
    }
}
