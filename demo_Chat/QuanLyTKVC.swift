//
//  QuanLyTKVC.swift
//  demo_Chat
//
//  Created by DUY on 7/5/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase

class QuanLyTKVC: UIViewController {
    @IBOutlet weak var tbvHienthi: UITableView!
    var arrNoiDung:Array = ["Danh sách máy tính đăng nhập","Đổi số điện thoại","Đổi mật khẩu","Xoá tài khoản","Đăng xuất tài khoản"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvHienthi.delegate = self
        tbvHienthi.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func logOut(){
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
extension QuanLyTKVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNoiDung.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrNoiDung[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            Uilities.ShareIntand.showAlerControler(title: "Thong Bao", message: "Log Out", alertStyle: .actionSheet, confirmButtonText: "OK", cancaleButtonText: "Cancel", atController: self, completion: { [weak self](bool) in
                if bool {
                    self?.logOut()
                } else {
                    print("cancel")
                }
            })
        }
    }
    
    
}
