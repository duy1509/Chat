//
//  DangKyTBV.swift
//  demo_Chat
//
//  Created by DUY on 6/20/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class DangKyTBV: UITableViewController {
    
    @IBOutlet var tbvHienthi: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tbvHienthi.dataSource = self
        tbvHienthi.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DangKyTBVC
        return cell
    }


}
