//
//  User.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import Firebase
import UIKit


struct User {
    var name:String!
    var email:String!
    var image:String!
    var pass:String!
    var uid:String!
    var status:String!
    var imgLoadHinh:String!
    var imgBackground:String!
    var likeCount: Int!
    var likes: Dictionary<String, Any>!
    var isLiked: Bool!
    var gioitinh:String!
    var ngaysinh:String!
    var phone:String!
    var imageProfile:UIImage!
}

