//
//  ViewController.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/1/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginVC: UIViewController {

    //Link input boxes on login screen
    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var repeatPasswordBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(_ sender: Any) {
        let username = usernameBox.text
        let email = emailBox.text
        let password = passwordBox.text
        let repeatPassword = repeatPasswordBox.text
        
        if (password == repeatPassword) {
            
        } else {
            print("Passwords are not the same!")
        }
    }

}

