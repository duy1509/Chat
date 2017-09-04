//
//  ThemVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class ThemVC: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgHinhprofile: UIImageView!
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 17.0/255.0, green: 155.0/255, blue: 226.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        loadData()
        self.imgHinhprofile.layer.cornerRadius = 25
        self.imgHinhprofile.layer.masksToBounds = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func GestureHome(_ sender: Any) {
        let home = storyboard?.instantiateViewController(withIdentifier: "home") as! HomeProfile
        self.navigationController?.pushViewController(home, animated: true)

    }
    
    func loadData(){
        ref.child("User").child((auth.currentUser?.uid)!).observe(.value, with: {[weak self] (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                self?.lblName.text = value["name"] as? String
                let url = URL(string: (value["imgProfile"] as? String ?? "" )!)
//                self?.imgHinhprofile.kf.setImage(with: url)
                self?.imgHinhprofile.kf.setImage(with: url, placeholder: UIImage(named:"doctor"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }
        }) { (error) in
            ProgressHUD.showError(error.localizedDescription)
        }
    }
    @IBAction func btnLogOut(_ sender: Any) {
        let logout = Auth.auth()
        do{
            try logout.signOut()
            let comeback = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            self.present(comeback, animated: true, completion: nil)
        }catch let signerror as NSError{
            print("Error sign out :",signerror)
        }

    }

}
