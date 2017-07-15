//
//  SignInVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/9/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self as? UITextFieldDelegate
        passwordField.delegate = self as? UITextFieldDelegate
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func continueTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("Error, could not log in")
                } else {
                    self.performSegue(withIdentifier: "join", sender: nil)
                }
            })
        }
    }
}
