//
//  ThongTinVC.swift
//  demo_Chat
//
//  Created by DUY on 7/4/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ThongTinVC: UIViewController {
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtfGioiTinh: UITextField!
    @IBOutlet weak var txtfPhone: UITextField!
    @IBOutlet weak var txtfNgaySinh: UITextField!
    @IBOutlet weak var lblName: UILabel!
    var user1:User?
    var picker:UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()

        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        self.imgProfile.layer.cornerRadius = 25
        self.imgProfile.layer.masksToBounds = true
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func GesterSelectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Messenger", message: "Select Image Please", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (Photo) in
            self.showImage(picker: self.picker, view: self, sourType: .photoLibrary, alowEditing: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDoiThongTin(_ sender: Any) {
        ProgressHUD.show("Waiting...")
        UploadToDaTa()
        
    }

    func LoadData(){
        ref.child("User").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { [weak self](snapshot) in
          
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user2 = User()
                let url = URL(string: (value["imgProfile"] as? String)!)
                let newurl = URL(string: (value["imgBackground"] as? String)!)
                
                user2.email = value["email"] as? String
                user2.imgBackground = value["imgBackground"] as? String
                user2.image = value["imgProfile"] as? String
                user2.name = value["name"] as? String
                user2.gioitinh = value["Gioitinh"] as? String ?? ""
                user2.ngaysinh = value["Ngaysinh"] as? String ?? ""
                user2.phone = value["Phone"] as? String ?? ""
                
                
                self?.user1 = user2
                
                DispatchQueue.main.async {
                    self?.imgProfile.kf.setImage(with: url)
                    self?.imgBackGround.kf.setImage(with: newurl)
                    self?.lblName.text = user2.name
                    self?.txtfGioiTinh.text = user2.gioitinh
                    self?.txtfNgaySinh.text = user2.ngaysinh
                    self?.txtfPhone.text = user2.phone
                }

            }
        }) { (error) in
            ProgressHUD.show(error.localizedDescription)
        }

    }

    func UploadToDaTa(){
        
        let updataThongTin = ref.child("User").child((auth.currentUser?.uid)!)
        var newUpdate:Dictionary<String,AnyObject> = Dictionary()
        newUpdate.updateValue(self.user1?.name as AnyObject, forKey: "name")
        newUpdate.updateValue(self.user1?.email as AnyObject, forKey: "email")
        newUpdate.updateValue(self.user1?.image as AnyObject, forKey: "imgProfile")
        newUpdate.updateValue(self.user1?.imgBackground as AnyObject, forKey: "imgBackground")
        newUpdate.updateValue(self.txtfGioiTinh.text as AnyObject, forKey: "Gioitinh")
        newUpdate.updateValue(self.txtfNgaySinh.text as AnyObject, forKey: "Ngaysinh")
        newUpdate.updateValue(self.txtfPhone.text as AnyObject, forKey: "Phone")
                
        
        updataThongTin.setValue(newUpdate) { [weak self](error, data) in
            if error != nil {
                
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                ProgressHUD.showSuccess("Success")
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showImage(picker:UIImagePickerController,view:UIViewController,sourType:UIImagePickerControllerSourceType,alowEditing:Bool){
        picker.allowsEditing = alowEditing
        picker.sourceType = sourType
        view.present(picker, animated: true, completion: nil)
    }
    
    
}
extension ThongTinVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true){
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let newimg = Uilities.ShareIntand.resizeImage(image: img, newWidth: 300)
            let chonimage = self.storyboard?.instantiateViewController(withIdentifier: "ImageProfile") as! ChonImage
            chonimage.imageProfile = newimg
            chonimage.user = self.user1
            self.present(chonimage, animated: true, completion: nil)
            
        }
    }
}

