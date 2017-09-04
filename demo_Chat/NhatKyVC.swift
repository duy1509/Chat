//
//  NhatKyVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NhatKyVC: UIViewController {
    var arrUser:[User] = []

    @IBOutlet weak var tbvHienthi: UITableView!
    @IBOutlet weak var imgHinhProfile: UIImageView!
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.showSuccess("Waiting..!")
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 17.0/255.0, green: 155.0/255, blue: 226.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        loadData()
        loadDataAndImage()
        tbvHienthi.dataSource = self
        tbvHienthi.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
//        self.imgHinhProfile.image = UIImage(named: "doctor")
        self.imgHinhProfile.layer.cornerRadius = 25
        self.imgHinhProfile.layer.masksToBounds = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnStatus(_ sender: Any) {
        let status = storyboard?.instantiateViewController(withIdentifier: "NaVi") as! UINavigationController
        self.present(status, animated: true, completion: nil)
    }
    
    @IBAction func GestureStatus(_ sender: Any) {
        let hienra = storyboard?.instantiateViewController(withIdentifier: "NaVi") as! UINavigationController
        self.present(hienra, animated: true, completion: nil)
    }
    
    func loadData(){
        ref.child("User").observe(.childAdded, with: { [weak self](snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                let url = URL(string: value["imgProfile"] as! String)
                self?.imgHinhProfile.kf.setImage(with: url)
            }
        })
    }
    func loadDataAndImage(){
        ref.child("Table").observe(.childAdded, with: { [weak self](snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user = User()
                user.uid = snapshot.key
                user.name = value["name"] as? String
                user.image = value["imgProfile"] as? String
                user.status = value["Status"] as? String
                user.imgLoadHinh = value["ImageLoad"] as? String
                user.likes = value["likes"] as? Dictionary<String,AnyObject>
                user.likeCount = value["likeCount"] as? Int
                if let currentUserID = Auth.auth().currentUser?.uid {
                    if user.likes != nil {
                        user.isLiked = user.likes![currentUserID] != nil
                    }
                }
                self?.arrUser.append(user)
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess()
                    self?.tbvHienthi.reloadData()
                }
            }

        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }


}
extension NhatKyVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NhatKyCell
        let user = arrUser[indexPath.row]
        cell.user = user
        cell.lblName.text = arrUser[indexPath.row].name
        cell.lblStatus.text = arrUser[indexPath.row].status
        let url = URL(string: arrUser[indexPath.row].image!)
//        cell.imgProfile.kf.setImage(with: url)
        cell.imgProfile.kf.setImage(with: url, placeholder: UIImage(named:"doctor"), options: nil, progressBlock: nil, completionHandler: nil)
        let urlString = URL(string: arrUser[indexPath.row].imgLoadHinh!)
        cell.imgStatus.kf.setImage(with: urlString)
        let imageName = arrUser[indexPath.row].likes == nil || !arrUser[indexPath.row].isLiked! ? "like" : "likeSelected"
        cell.btnLike.setImage(UIImage(named:imageName), for: .normal)
        if let count = arrUser[indexPath.row].likeCount {
            if count != 0 {
                cell.btnUserLike.setTitle("\(count) Likes", for: .normal)
            } else if arrUser[indexPath.row].likeCount == 0 {
                cell.btnUserLike.setTitle("Be the first to Like this", for: .normal)
            }
        }
        
        cell.acctionButtonLike = { [weak self] sender in
            guard let strongSelf = self else { return }
        }
        
        
        cell.acctionbuttonUserLike = { [weak self] in
            guard let strongSelf = self else { return }
            
            let tableUser = strongSelf.storyboard?.instantiateViewController(withIdentifier: "UserLike") as! UserLikeVC
            tableUser.uid = strongSelf.arrUser[indexPath.row].uid
            strongSelf.navigationController?.pushViewController(tableUser, animated: true)
        }
        cell.acctionButtonCommand = { [weak self] sender in
            guard let strongSelf = self else { return }
            let comment = self?.storyboard?.instantiateViewController(withIdentifier: "command") as! CommandVC
            comment.user = strongSelf.user
            comment.uid = strongSelf.arrUser[indexPath.row].uid
            strongSelf.navigationController?.pushViewController(comment, animated: true)
            
        }
        cell.selectionStyle = .none

        return cell
    }
}
