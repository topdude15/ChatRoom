//
//  GroupCell.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/5/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class GroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupImage: CircleImage!
    
    var group: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(group: Group) {
        self.group = group
        self.nameLabel.text = group.name
        let ref = Storage.storage().reference(forURL: group.image)
        ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("Image could not be downloaded")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.groupImage.image = img
                        
                    }
                }
            }
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
