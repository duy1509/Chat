//
//  ChiaSeVc.swift
//  demo_Chat
//
//  Created by DUY on 6/23/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChiaSeVc: UIViewController {
    
    @IBOutlet weak var imgHinhUp: UIImageView!
    @IBOutlet weak var txtfHienthi: UITextView!
    let picker = UIImagePickerController()
    var auth = Auth.auth()
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    var storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 17.0/255.0, green: 155.0/255, blue: 226.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        loadData()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GestureSelectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Messenger", message: "Select Image Please", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (Photo) in
            self.showCamera(picker: self.picker, view: self, soureType: .photoLibrary, alowEdting: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showCamera(picker:UIImagePickerController,view:UIViewController,soureType:UIImagePickerControllerSourceType,alowEdting:Bool){
        picker.allowsEditing = alowEdting
        picker.sourceType = soureType
        view.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnUpStatus(_ sender: Any) {
        ProgressHUD.show("Waiting..")
        uploadDataAndImage()
    }
    
    func loadData(){
        ref.child("User").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                self.user.email = value["email"] as? String
                self.user.name = value["name"] as? String
                self.user.image = value["imgProfile"] as? String
                
            }
        })
    }
    
    func uploadDataAndImage(){
        let table = ref.child("Table")
        let tableImge = ref.child("ImageLoad")
        var tablevalue:Dictionary<String,AnyObject> = Dictionary()
        var newtablevalue:Dictionary<String,AnyObject> = Dictionary()
        let data = UIImagePNGRepresentation(imgHinhUp.image!)
        let img = UUID().uuidString
        let storageRef = storage.child("Image\(img).png")
        storageRef.putData(data!, metadata: nil) { [weak self](metadata, error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                let imgString = metadata?.downloadURL()?.absoluteString
                tablevalue.updateValue(imgString  as AnyObject, forKey: "ImageLoad")
                tablevalue.updateValue(self?.user.name as AnyObject, forKey: "name")
                tablevalue.updateValue(self?.user.email as AnyObject, forKey: "email")
                tablevalue.updateValue(self?.user.image as AnyObject, forKey: "imgProfile")
                tablevalue.updateValue(self?.txtfHienthi.text as AnyObject, forKey: "Status")
                newtablevalue.updateValue(imgString as AnyObject, forKey: "ImgURl")
                let tableUser = table.child(img)
                tableUser.setValue(tablevalue, withCompletionBlock: { (error, data) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        let imgNew = tableImge.child((self?.auth.currentUser?.uid)!)
                        let imgname = imgNew.child(img)
                        imgname.setValue(newtablevalue, withCompletionBlock: { (error, data) in
                            if error != nil {
                                ProgressHUD.showError(error?.localizedDescription)
                            }else{
                                ProgressHUD.showSuccess("Success")
                                self?.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }


}
extension ChiaSeVc:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true){
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let newimg = Uilities.ShareIntand.resizeImage(image: img, newWidth: 300)
            self.imgHinhUp.image = newimg
        }
    }
}
