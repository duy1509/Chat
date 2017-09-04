//
//  QuyenRiengTuVC.swift
//  demo_Chat
//
//  Created by DUY on 7/5/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class QuyenRiengTuVC: UIViewController {
    var arrthongtin:Array = ["Tin nhắn","Nhật Ký","Khoảnh khắc","Thông tin cá nhân","Quản lý ứng dụng","Bảo mật"]
    var arrNoiDung:Array<Array<String>> = [["Nhận tin từ người lạ","Chặn bạn gửi tin nhắn","Ẩn trò chuyện"],["Cho người lạ bình luận","Cho người lạ xem ảnh","Chặn bạn xem nhật ký","Ẩn nhật ký bạn bè"],["Chặn bạn xem khoảnh khắc"],["Hiển thị ngày sinh"],["Ứng dụng đã cấp quyền"],["Khoá Zalo"]]

    @IBOutlet weak var tbvHienthi: UITableView!
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
    


}
extension QuyenRiengTuVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrNoiDung.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNoiDung[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrNoiDung[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrthongtin[section]
    }
}
