//
//  RoundedPostImage.swift
//  ChatRoom
//
//  Created by Trevor Rose on 8/30/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class RoundedPostImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    

}
