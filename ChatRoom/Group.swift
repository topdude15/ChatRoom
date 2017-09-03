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
    private var _groupKey: String!
    
    var name: String {
        return _name
    } 
    
    var image: String {
        return _image
    }
    var groupKey: String {
        return _groupKey
    }

    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        if let name = postData["name"] as? String, let image = postData["image"] as? String, let groupKey = postData["groupKey"] as? String {
            self._name = name
            self._image = image
            self._groupKey = groupKey
        }
    }
}
