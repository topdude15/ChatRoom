//
//  Group.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/3/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase

class Group {
    
    private var _name: String!
    private var _image: String!
   // private var _groupCode: String!
    
    var name: String {
        return _name
    }
    
    var image: String {
        return _image
    }
//    var groupCode: String {
//        return _groupCode
//    }

    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        if let name = postData["name"] as? String, let image = postData["image"] as? String {
            print(name)
            
            self._name = name
            self._image = image
//            self._groupCode = groupCode
        }
        
    }

}
