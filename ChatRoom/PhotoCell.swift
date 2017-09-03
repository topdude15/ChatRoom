//
//  PhotoCell.swift
//  ChatRoom
//
//  Created by Trevor Rose on 8/30/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class PhotoCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var messageField: UILabel!
    
    var photoChat: Chat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurePhotoCell(chat: Chat) {
        self.photoChat = chat
        self.usernameField.text = chat.username
        self.messageField.text = chat.message
        
        let imageRef = Storage.storage().reference(forURL: chat.postImage!)
        imageRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("Could not download post image")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.postImage.image = img
                    }
                }
            }
        }
        
        let ref = Storage.storage().reference(forURL: chat.image)
        ref.getData(maxSize: 2 * 1024 *  1024) { (data, error) in
            if error != nil {
                print("Could not download image")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.profileImage.image = img
                    }
                }
            }
        }

    }
}
