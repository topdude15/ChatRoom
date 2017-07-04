//
//  CreateMainVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/3/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class CreateMainVC: UIViewController {

    @IBOutlet weak var codeBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createGroup(_ sender: Any) {
        let userCode = codeBox.text
        
        Database.database().reference().child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userCode!) {
                print("Group already exists")
            } else {
                print("Group does not already exist")
            }
        })
    }
    
}
