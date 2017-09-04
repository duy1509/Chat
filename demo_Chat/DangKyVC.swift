//
//  DangKyVC.swift
//  demo_Chat
//
//  Created by DUY on 6/20/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Pastel
import Firebase

class DangKyVC: UIViewController {
    
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    var imgProfile:String = ""
    var imgBaclGround:String = ""
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnDangKy(_ sender: Any) {
        ProgressHUD.show("Waiting...!")
        dangkyUser(name: txtName.text!, email: txtEmail.text!, pass: txtPass.text!, imgprofile: imgProfile, imgbackground: imgBaclGround)
    }
    @IBAction func btnBackToDangNhap(_ sender: Any) {
        let main = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        self.present(main, animated: true, completion: nil)
    }
    func backGroundColor(){
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 138/255, green: 58/255, blue: 185/255, alpha: 1.0),
                              UIColor(red: 76/255, green: 104/255, blue: 215/255, alpha: 1.0),
                              UIColor(red: 205/255, green: 72/255, blue: 107/255, alpha: 1.0),
                              UIColor(red: 251/255, green: 173/255, blue: 80/255, alpha: 1.0),
                              UIColor(red: 252/255, green: 204/255, blue: 99/255, alpha: 1.0),
                              UIColor(red: 188/255, green: 42/255, blue: 141/255, alpha: 1.0),
                              UIColor(red: 233/255, green: 89/255, blue: 80/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        self.view.insertSubview(pastelView, at: 0)
        
    }
    
    
    func dangkyUser(name:String,email:String,pass:String,imgprofile:String,imgbackground:String){
        if let name:String = name, let email:String = email,let pass:String = pass,let imgprofile:String = imgprofile,let imgbackground:String = imgbackground {
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)}
                else{
                    let value = ["name":name,"email":email,"imgProfile":self.imgProfile,"imgBackground":self.imgBaclGround]
                    self.upLoadToData(uid: (user?.uid)!, value: value as [String : AnyObject])
                }
            })
        }
    }
    
    func upLoadToData(uid:String,value:[String:AnyObject]){
        let user = ref.child("User").child(uid)
        user.setValue(value) { (error, data) in
            if error != nil{
                ProgressHUD.show(error?.localizedDescription)
        }else{
                ProgressHUD.showSuccess()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}
