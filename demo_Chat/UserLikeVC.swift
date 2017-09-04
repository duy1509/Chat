//
//  UserLikeVC.swift
//  demo_Chat
//
//  Created by DUY on 6/23/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UserLikeVC: UIViewController {
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    var auth = Auth.auth()
    var uid:String?
    var user = User()
    var arrUserLike:[User] = []
    @IBOutlet weak var tbvHienthi: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
        tbvHienthi.dataSource = self
        tbvHienthi.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func LoadData(){
        ref.child("TableUserLike").child(uid!).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var userlike = User()
                userlike.uid = snapshot.key
                userlike.image = value["imgProfile"] as? String
                userlike.name = value["name"] as? String
                
                self.arrUserLike.append(userlike)
                
                DispatchQueue.main.async {
                    self.tbvHienthi.reloadData()
                }
            }
            
        })
        
    }


}
extension UserLikeVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserLike.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserLikeCell
        cell.lblName.text = arrUserLike[indexPath.row].name
        let url = URL(string: arrUserLike[indexPath.row].image!)
        cell.imgHInh.kf.setImage(with: url)
        
        return cell
    }
    
}

