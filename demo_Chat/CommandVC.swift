//
//  CommandVC.swift
//  demo_Chat
//
//  Created by DUY on 6/28/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MobileCoreServices
import Kingfisher


class CommandVC: UIViewController {
    var arrComment:[Command] = []
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    var storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    var auth = Auth.auth()
    var uid:String?
    var user:User?
    @IBOutlet weak var txtfNhapMessger: UITextField!
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
    
    @IBAction func btnSelectImage(_ sender: Any) {
    }
    @IBAction func btnSend(_ sender: Any) {
        sendComment()
    }
    
    func LoadData(){
        ref.child("Comment").child(uid!).observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var comment = Command()
                comment.name = value["name"] as? String
                comment.imageprofile = value["imgProfile"] as? String
                comment.command = value["comment"] as? String
                
                self.arrComment.append(comment)
                
                DispatchQueue.main.async {
                    self.tbvHienthi.reloadData()
                }
            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }
    func sendComment(){
        if txtfNhapMessger.text == ""{
            ProgressHUD.show("Please input your comment ")
        }else{
            guard let commentString = txtfNhapMessger.text else { return }
            UploadDataToFireBase(commentString: commentString)
        }
    }

    func UploadDataToFireBase(commentString:String){
        let commentRef = ref.child("Comment").child(uid!).childByAutoId()
        var value:Dictionary<String,AnyObject> = Dictionary()
        value.updateValue(commentString as AnyObject, forKey: "comment")
        value.updateValue(user?.name as AnyObject, forKey: "name")
        value.updateValue(user?.image as AnyObject, forKey: "imgProfile")
        commentRef.setValue(value) { (error, data) in
            if error == nil {
                self.txtfNhapMessger.text = ""
                ProgressHUD.dismiss()
            }else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
}
extension CommandVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommandCell
        let url = URL(string: arrComment[indexPath.row].imageprofile!)
        cell.imgHinhProfile.kf.setImage(with: url)

        cell.lblName.text = arrComment[indexPath.row].name
        cell.lblCommand.text = arrComment[indexPath.row].command
        
        return cell
    }
}

