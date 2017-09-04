//
//  NhatKyCell.swift
//  demo_Chat
//
//  Created by DUY on 6/23/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import MobileCoreServices
import AVKit
import AVFoundation

class NhatKyCell: UITableViewCell {

    @IBOutlet weak var btnUserLike: UIButton!
    @IBOutlet weak var btnCommand: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    var acctionButtonLike:(()->(Void))? = nil
    var acctionButtonCommand:(()->(Void))? = nil
    var acctionbuttonUserLike:(()->(Void))? = nil
    var auth = Auth.auth()
    var user = User()
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    var storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.imgProfile.layer.cornerRadius = 25
        self.imgProfile.layer.masksToBounds = true
        loadData()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnUserLike(_ sender: UIButton) {
        guard let acctionUserLike = self.acctionbuttonUserLike else {return}
        acctionUserLike()

    }

    @IBAction func btnLike(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let actionLike = self.acctionButtonLike else {return}
        actionLike()
        handleLikeTap()
    }
    @IBAction func btnCommand(_ sender: UIButton) {
        guard let actionCommand = self.acctionButtonCommand else{return}
        actionCommand()
    }
    func handleLikeTap() {
        let postReference = ref.child("Table").child((user.uid!))
        showLike(forReference: postReference)
    }

    
    
    
    func showLike(forReference refLike: DatabaseReference){
        refLike.runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = self.auth.currentUser?.uid{
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                    
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let value = snapshot?.value as? Dictionary<String,AnyObject> {
                var post = User()
                post.uid = snapshot?.key
                post.name = value["name"] as? String
                post.status = value["Status"] as? String
                post.imgLoadHinh = value["ImageLoad"] as? String
                post.image = value["imgProfile"] as? String
                post.likeCount = value["likeCount"] as? Int
                post.likes = value["likes"] as? Dictionary<String,Any>
                if let currentUserID = self.auth.currentUser?.uid{
                    if post.likes != nil {
                        post.isLiked = post.likes![currentUserID] != nil
                    }
                }
                self.upDataLike(post: post)
            }
        }
        
    }
    
    func upDataLike(post: User){
        let btnname = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        if post.isLiked == nil {
            self.btnLike.setImage(UIImage(named:"like"), for: .normal)
        } else {
            if post.isLiked! {
                self.btnLike.setImage(UIImage(named:btnname), for: .normal)
                self.loadDataUserLike()
            } else{
                self.btnLike.setImage(UIImage(named:btnname), for: .selected)
                
            }
        }
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            btnUserLike.setTitle("\(count) Likes", for: .normal)
        } else if post.likeCount == 0 {
            btnUserLike.setTitle("", for: .normal)
        }
    }
    
    func loadData(){
        ref.child("User").child((auth.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject> {
                
                self.user.name = value["name"] as? String
                self.user.image = value["imgProfile"] as? String
                
            }
        })
    }
    
    
    func loadDataUserLike(){
        let table = ref.child("TableUserLike")
        var tableUserLike:Dictionary<String,AnyObject> = Dictionary()
        tableUserLike.updateValue(self.user.image as AnyObject, forKey: "imgProfile")
        tableUserLike.updateValue(self.user.name as AnyObject, forKey: "name")
        
        let newtable = table.child((user.uid)!).child((auth.currentUser?.uid)!)
        newtable.setValue(tableUserLike) { (error, data) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                ProgressHUD.showSuccess()
            }
        }
    }
    



}
