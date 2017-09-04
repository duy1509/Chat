//
//  HomeProfile.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation
import Firebase
import Kingfisher

class HomeProfile: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let picker:UIImagePickerController = UIImagePickerController()
    let auth = Auth.auth()
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    var user = User()
    var isImgProfile = true
    var container:ContandViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.image = UIImage(named: "doctor")
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        self.imgProfile.layer.cornerRadius = 25
        self.imgProfile.layer.masksToBounds = true
        
        loadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func GestureImageProfile(_ sender: Any) {
        self.isImgProfile = true
        let alert = UIAlertController(title: "Messenges", message: "Please Select", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xem ảnh đại diện", style: .default, handler: { (photo) in
            self.showCamera(picker: self.picker, view: self, sourType: .photoLibrary, alowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Chụp ảnh mới", style: .default, handler: { (Camera) in
            self.showCamera(picker: self.picker, view: self, sourType: .camera, alowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Chọn ảnh có sẵn", style: .default, handler: { (Image) in
            self.showCamera(picker: self.picker, view: self, sourType: .photoLibrary, alowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func GestureImageBackGround(_ sender: Any) {
        self.isImgProfile = false
        let alert = UIAlertController(title: "Messenges", message: "Please Select", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Chụp ảnh mới", style: .default, handler: { (Camera) in
            self.showCamera(picker: self.picker, view: self, sourType: .camera, alowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Chọn ảnh có sẵn", style: .default, handler: { (Image) in
            self.showCamera(picker: self.picker, view: self, sourType: .photoLibrary, alowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func segmenSelectImage(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
                container!.segueIdentifierReceivedFromParent("Note")
                
            }
            else{
                
                container!.segueIdentifierReceivedFromParent("Anh")
                
            }

        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contand"{
            
            container = segue.destination as! ContandViewController
            
            
        }
    }
    
    @IBAction func btnCaiDat(_ sender: Any) {
        let caidat = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileVC
        self.navigationController?.pushViewController(caidat, animated: true)
    }
    
    func showCamera(picker:UIImagePickerController,view:UIViewController,sourType:UIImagePickerControllerSourceType,alowEditing:Bool){
        picker.sourceType = sourType
        picker.allowsEditing = alowEditing
        view.present(picker, animated: true, completion: nil)
    }
    func loadData(){
        ref.child("User").child((auth.currentUser?.uid)!).observe(.value, with: {[weak self] (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user = User()
                let url = URL(string: (value["imgProfile"] as? String ?? "")!)

                
                user.email = value["email"] as? String
                user.name = value["name"] as? String
                user.pass = value["pass"] as? String
                user.image = value["imgProfile"] as? String ?? ""
                user.imgBackground = value["imgBackground"] as? String ?? ""
                let imgBackgroundUrl = URL(string: user.imgBackground!)
                self?.user = user
                DispatchQueue.main.async {
                    self?.imgProfile.kf.setImage(with: url)
                    self?.imgBackGround.kf.setImage(with: imgBackgroundUrl)
                    self?.lblName.text = user.name
                }

            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
            // not touch
            
//            self.imgProfile.isUserInteractionEnabled = false
        }
    }
    


}
extension HomeProfile:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true){
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let newimg = Uilities.ShareIntand.resizeImage(image: img, newWidth: 300)
            let chonimage = self.storyboard?.instantiateViewController(withIdentifier: "ImageProfile") as! ChonImage
            chonimage.isImgProfile = self.isImgProfile
            chonimage.imageProfile = newimg
            chonimage.user = self.user
            self.present(chonimage, animated: true, completion: nil)

        }
    }
}

