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
        if let uid = Auth.auth().currentUser?.uid {
            print("Already logged in")

            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("groups") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.performSegue(withIdentifier: "join", sender: nil)
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.performSegue(withIdentifier: "join", sender: nil)
                    })
                }
            })
            } else {
            print("Not logged in")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.performSegue(withIdentifier: "signInScreen", sender: nil)
            })
        }

    }
}
