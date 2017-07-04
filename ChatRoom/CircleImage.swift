//
//  CircleImage.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/2/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
