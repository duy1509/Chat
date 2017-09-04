//
//  ViewController.swift
//  demo_Chat
//
//  Created by DUY on 6/15/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Pastel
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backGroundColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnDangNhap(_ sender: Any) {
        let dangnhap = storyboard?.instantiateViewController(withIdentifier: "DangNhapVC") as! DangNhapVC
        self.present(dangnhap, animated: true, completion: nil)
    }
    @IBAction func btnDangKy(_ sender: Any) {
        let dangky = storyboard?.instantiateViewController(withIdentifier: "DangKyVC") as! DangKyVC
        self.present(dangky, animated: true, completion: nil)
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



}

