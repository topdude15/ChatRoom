//
//  TopDownSegue.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/6/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class TopDownSegue: UIStoryboardSegue {
        override func perform()
        {
            let src = self.sourceViewController
            let dst = self.destinationViewController
            
            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
            dst.view.transform = CGAffineTransformMakeTranslation(-src.view.frame.size.width, 0)
            
            UIView.animateWithDuration(0.25,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations: {
                                        dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
            },
                                       completion: { finished in
                                        src.presentViewController(dst, animated: false, completion: nil)
            }
            )
        }
}
