//
//  ChatCell.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/6/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var chat: Chat!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func configureCell(chat: Chat) {
        self.chat = chat
        self.usernameLabel.text = chat.username
        self.messageLabel.text = chat.message
        
            let ref = Storage.storage().reference(forURL: chat.image)
            ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if error != nil {
                    print("Image could not be downloaded")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.userImage.image = img
                            ChatVC.imageCache.setObject(img, forKey: chat.image as NSString)
                        }
                    }
                }
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
