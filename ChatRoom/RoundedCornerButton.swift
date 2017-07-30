//
//  RoundedCornerButton.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/28/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class RoundedCornerButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        
    }

}
