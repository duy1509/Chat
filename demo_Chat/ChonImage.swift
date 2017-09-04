//
//  ChonImage.swift
//  demo_Chat
//
//  Created by DUY on 6/22/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class ChonImage: UIViewController {
    var user:User?
    var imageProfile:UIImage? = nil
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()
    @IBOutlet weak var imgHinh: UIImageView!
    var isImgProfile:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgHinh.image = imageProfile!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnXong(_ sender: Any) {
        ProgressHUD.show("Waiting...")
        upLoadToData()
    }
    @IBAction func btnHuy(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func upLoadToData(){
        let data = UIImagePNGRepresentation(imgHinh.image!)
        let img = UUID().uuidString
        let storageRef = storage.child("Image\(img).png")
        storageRef.putData(data!, metadata: nil) { [weak self](metadata, error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                let ingString = metadata?.downloadURL()?.absoluteString
                var value:[String:AnyObject] = Dictionary()
                if (self?.isImgProfile)! {
                    value.updateValue(ingString as AnyObject, forKey: "imgProfile")
                    value.updateValue(self?.user?.imgBackground as AnyObject, forKey: "imgBackground")
                } else {
                    value.updateValue(ingString as AnyObject, forKey: "imgBackground")
                    value.updateValue(self?.user?.image as AnyObject, forKey: "imgProfile")
                }
                value.updateValue(self?.user?.email as AnyObject, forKey: "email")
                value.updateValue(self?.user?.name as AnyObject, forKey: "name")
                value.updateValue(self?.user?.pass as AnyObject, forKey: "pass")
                value.updateValue(self?.user?.gioitinh as AnyObject, forKey: "Gioitinh")
                value.updateValue(self?.user?.ngaysinh as AnyObject, forKey: "Ngaysinh")
                value.updateValue(self?.user?.phone as AnyObject, forKey: "Phone")

                let userImage = self?.ref.child("User").child((self?.auth.currentUser?.uid)!)

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
