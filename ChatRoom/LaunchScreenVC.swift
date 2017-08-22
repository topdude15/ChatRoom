//
//  LaunchScreenVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/9/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LaunchScreenVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            print("Already logged in")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                print("Going...")
                self.performSegue(withIdentifier: "join", sender: nil)
                print("Done!")
            })
        } else {
            print("Not logged in")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.performSegue(withIdentifier: "signInScreen", sender: nil)
            })
        }

    }
}
