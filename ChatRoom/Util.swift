//
//  Util.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/3/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase

class Util {
    static let ds = Util()
    
    let Ref = Database.database().reference()
    let UserRef = Database.database().reference().child("users")
    let GroupRef = Database.database().reference().child("groups")
    let StorageRef = Storage.storage().reference()
    
    var referralCode = ""
    
    var groupKey = "q"
    
    var createGroupKey = "key"
    
    var wentHome = false
}

