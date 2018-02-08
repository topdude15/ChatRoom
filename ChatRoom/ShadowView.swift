//
//  ShadowView.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/27/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
}
