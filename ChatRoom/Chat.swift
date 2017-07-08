//
//  Chat.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/6/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase

class Chat {
    private var _username: String!
    private var _message: String!
    private var _image: String!
    
    var username: String {
        return _username
    }
    var image: String {
        return _image
    }
    var message: String {
        return _message
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        if let username = postData["username"] as? String, let image = postData["image"] as? String, let message = postData["message"] as? String {
            self._username = username
            self._image = image
            self._message = message
        }
    }
}
