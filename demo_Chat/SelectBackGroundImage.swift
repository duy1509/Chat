//
//  SelectBackGroundImage.swift
//  demo_Chat
//
//  Created by DUY on 6/22/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MobileCoreServices
import Kingfisher

class SelectBackGroundImage: UIViewController {
    var imageBackGround:UIImage? = nil
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()


    @IBOutlet weak var imgHInh: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgHInh.image = imageBackGround!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnXong(_ sender: Any) {
        ProgressHUD.show("Waiting")
        upLoadToData()
    }

    @IBAction func btnHuy(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func upLoadToData(){
        let data = UIImagePNGRepresentation(imgHInh.image!)
        let img = UUID().uuidString
        let storageRef = storage.child("Image\(img).png")
        storageRef.putData(data!, metadata: nil) { [weak self](metadata, error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                let ingString = metadata?.downloadURL()?.absoluteString
                var value:[String:AnyObject] = Dictionary()
                value.updateValue(ingString as AnyObject, forKey: "imgBackGround")
                let userImage = self?.ref.child("UserImageBackGround").child((self?.auth.currentUser?.uid)!)
                userImage?.setValue(value, withCompletionBlock: { (error, data) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        ProgressHUD.showSuccess("Success")
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    

}
