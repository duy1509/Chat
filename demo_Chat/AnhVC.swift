//
//  AnhVC.swift
//  demo_Chat
//
//  Created by DUY on 6/24/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


class AnhVC: UIViewController {
    var arrImage:Array<String> = []
    @IBOutlet weak var CoHienthi: UICollectionView!
    let auth = Auth.auth()
    let ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        CoHienthi.delegate = self
        CoHienthi.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage(){
        ref.child("ImageLoad").child((auth.currentUser?.uid)!).observe(.childAdded, with: { [weak self] (snapshot) in
            if let value = snapshot.value as? Dictionary<String,AnyObject>{
            
                let imgHinh = value["ImgURl"] as? String
                
                self?.arrImage.append(imgHinh!)
                
                DispatchQueue.main.async {
                    self?.CoHienthi.reloadData()
                }
            }
        })
    }
    
    
    

}
extension AnhVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AnhCell
        let url = URL(string: arrImage[indexPath.row])
        cell.imgHinhLoad.kf.setImage(with: url)

        return cell
    }
}
