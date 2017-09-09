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
    private var _postImage:String?
    private var _poster:String!
    
    var username: String {
        return _username
    }
    var image: String {
        return _image
    }
    var message: String {
        return _message
    }
    var postImage: String? {
        return _postImage
    }
    var poster: String {
        return _poster
    }
    
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        if let username = postData["username"] as? String, let image = postData["image"] as? String, let message = postData["message"] as? String {
            self._username = username
            self._image = image
            self._message = message
            if let pImage = postData["postImage"] as? String {
                self._postImage = pImage
            } else {
                print("Does not have image")
            }
            if let poster = postData["poster"] as? String {
                self._poster = poster
            } else {
                self._poster = "nan"
            }
        }
    }
}
