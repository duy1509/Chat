//
//  DanhBaVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class DanhBaVC: UIViewController {
    
    var arrUser:[User] = []
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    let auth = Auth.auth()
    @IBOutlet weak var tbvHienthi: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 17.0/255.0, green: 155.0/255, blue: 226.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        loadData()
        tbvHienthi.dataSource = self
        tbvHienthi.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSearch(_ sender: UIBarButtonItem) {
        let searchVc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchTBVC
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    func loadData(){
        ref.child("User").observe(.childAdded, with: {[weak self] (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject> {
                var userProfile = User()
                userProfile.uid = snapshot.key
                userProfile.name = value["name"] as? String
                userProfile.image = value["imgProfile"] as? String ?? ""
                if self?.auth.currentUser?.uid != userProfile.uid {
                    self?.arrUser.append(userProfile)
                    
                }

                DispatchQueue.main.async {
                    self?.tbvHienthi.reloadData()
                }

            }
        }) { (error) in
            ProgressHUD.show(error.localizedDescription)
        }

    }
    

}
extension DanhBaVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! danhbaTBVC
        cell.lblName.text = arrUser[indexPath.row].name
        
        let url = URL(string: arrUser[indexPath.row].image!)
        cell.imgHinhprofile.kf.setImage(with: url, placeholder: UIImage(named:"doctor"), options: nil, progressBlock: nil, completionHandler: nil)

        return cell
    }
}
