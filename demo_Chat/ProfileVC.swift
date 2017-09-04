//
//  ProfileVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    var user3:User?
    var isImgProfile = true
    let auth = Auth.auth()
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    let Name:Array = ["Thông tin","Cài đặt"]
    var thuoctinh:Array<Array<String>> = [["Thông tin","Cập nhật hình đại diện","Cập nhật ảnh bìa", "Xoá cảm nghĩ"],["Mã QR của tôi","Thiết lập riêng tư","Quản lý tài khoản"]]
    var picker = UIImagePickerController()
    @IBOutlet weak var tbvHienthi: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        LoadData()
        tbvHienthi.delegate = self
        tbvHienthi.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return thuoctinh.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thuoctinh[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = thuoctinh[indexPath.section][indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Name[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let newView = storyboard?.instantiateViewController(withIdentifier: "thongtin") as! ThongTinVC
            self.navigationController?.pushViewController(newView, animated: true)
        }else {
            
        }
        if thuoctinh[indexPath.section][indexPath.row] == "Thiết lập riêng tư" {
            let newView = storyboard?.instantiateViewController(withIdentifier: "riengtu") as! QuyenRiengTuVC
            self.navigationController?.pushViewController(newView, animated: true)
        }else {
            
        }
        if thuoctinh[indexPath.section][indexPath.row] == "Quản lý tài khoản" {
            let newView = storyboard?.instantiateViewController(withIdentifier: "quanly") as! QuanLyTKVC
            self.navigationController?.pushViewController(newView, animated: true)
        }else {
            
        }
        if thuoctinh[indexPath.section][indexPath.row] == "Cập nhật hình đại diện"{
            Uilities.ShareIntand.showAlerControler(title: "Ảnh đại diện", message: "Cập nhật ảnh đại diện", alertStyle: .actionSheet, confirmButtonText: "Chọn ảnh có sẵn", cancaleButtonText: "Huỷ", atController: self, completion: { [weak self](bool) in
                if bool {
                    self?.isImgProfile = true
                    self?.showLibraryAndCamera(picker: (self?.picker)!, view: (self)!, sourType: .photoLibrary, alowEditing: false)
                }else{
                    print("huỷ")
                }
            })

        }
        if thuoctinh[indexPath.section][indexPath.row] == "Cập nhật ảnh bìa"{
            Uilities.ShareIntand.showAlerControler(title: "Ảnh bìa", message: "Cập nhật ảnh bìa", alertStyle: .actionSheet, confirmButtonText: "Chọn ảnh có sẵn", cancaleButtonText: "Huỷ", atController: self, completion: { [weak self](bool) in
                if bool {
                    self?.isImgProfile = false
                    self?.showLibraryAndCamera(picker: (self?.picker)!, view: (self)!, sourType: .photoLibrary, alowEditing: false)
                }else{
                    print("huỷ")
                }
            })
            
        }

    }
    func LoadData(){
        ref.child("User").child((auth.currentUser?.uid)!).observe(.childAdded, with: { [weak self](snapshot) in
            
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
                var user = User()
                
                user.email = value["email"] as? String
                user.imgBackground = value["imgBackground"] as? String
                user.image = value["imgProfile"] as? String
                user.name = value["name"] as? String
                user.gioitinh = value["Gioitinh"] as? String ?? ""
                user.ngaysinh = value["Ngaysinh"] as? String ?? ""
                user.phone = value["Phone"] as? String ?? ""
                
                
                self?.user3 = user
                
                
            }
        }) { (error) in
            ProgressHUD.show(error.localizedDescription)
        }
        
    }
    
    func showLibraryAndCamera(picker:UIImagePickerController,view:UIViewController,sourType:UIImagePickerControllerSourceType,alowEditing:Bool){
        picker.allowsEditing = alowEditing
        picker.sourceType = sourType
        view.present(picker, animated: true, completion: nil)
    }

}
extension ProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true){
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let newimg = Uilities.ShareIntand.resizeImage(image: img, newWidth: 300)
            let chonimage = self.storyboard?.instantiateViewController(withIdentifier: "ImageProfile") as! ChonImage
            chonimage.isImgProfile = self.isImgProfile
            chonimage.imageProfile = newimg
            chonimage.user = self.user3
            self.present(chonimage, animated: true, completion: nil)
        }
    }
}

