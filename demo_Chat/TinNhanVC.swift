//
//  TinNhanVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import MobileCoreServices
import AVKit

class TinNhanVC: UIViewController {
    
    
    var arrUser:[User] = []
    var auth = Auth.auth()
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    @IBOutlet weak var tbvHienthi: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 17.0/255.0, green: 155.0/255, blue: 226.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        loadData()
        tbvHienthi.delegate = self
        tbvHienthi.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSearch(_ sender: Any) {
        let search = storyboard?.instantiateViewController(withIdentifier: "Search") as! UINavigationController
        self.present(search, animated: true, completion: nil)
    }
    
    
    func loadData(){
        ref.child("User").observe(.childAdded, with: { [weak self](snapshot) in
            print(snapshot)
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user = User()
                user.name = value["name"] as? String ?? ""
                user.uid = snapshot.key
                user.image = value["imgProfile"] as? String ?? ""
                user.email = value["email"] as? String ?? ""
                user.pass = value["pass"] as? String ?? ""
                user.status = value["status"] as? String ?? ""
                user.imgLoadHinh = value["imgLoadHinh"] as? String ?? ""
                user.imgBackground = value["imgBackground"] as? String ?? ""
//                user.likeCount = value["likeCount"] as? String ?? ""
//                user.likes = value["likes"] as? String ?? ""
//                user.isLiked = value["isLiked"] as? String ?? ""
                user.gioitinh = value["gioitinh"] as? String ?? ""
                user.ngaysinh = value["ngaysinh"] as? String ?? ""
                user.phone = value["phone"] as? String ?? ""
//                user.imageProfile = value["imageProfile"] as? String ?? ""
                if self?.auth.currentUser?.uid != user.uid {
                    self?.arrUser.append(user)

                }

            } else {
                ProgressHUD.showError()
            }
            
            DispatchQueue.main.async {
                self?.tbvHienthi.reloadData()
                
            }
        })
        
        ref.child("User").child((Auth.auth().currentUser?.uid)!).observe(.childChanged, with: { [weak self](snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user = User()
                user.name = value["name"] as? String
                user.uid = snapshot.key
                user.image = value["imgProfile"] as? String
                self?.arrUser.append(user)
                DispatchQueue.main.async {
                    self?.tbvHienthi.reloadData()
                    
                }
            }
        }) { (error) in
            ProgressHUD.showError()
        }
    }
}
extension TinNhanVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TinNhanTBVCell
        cell.lblName.text = arrUser[indexPath.row].name
        let url = URL(string: arrUser[indexPath.row].image!)
//        cell.imgHinhProfile.kf.setImage(with: url)
        cell.imgHinhProfile.kf.setImage(with: url, placeholder: UIImage(named:"doctor"), options: nil, progressBlock: nil, completionHandler: nil)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hienra = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat
        hienra.uidMessage = arrUser[indexPath.row].uid
        hienra.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hienra, animated: true)
        

    }
    
}
