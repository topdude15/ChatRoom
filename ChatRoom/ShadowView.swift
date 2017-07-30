//
//  ShadowView.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/27/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
}
