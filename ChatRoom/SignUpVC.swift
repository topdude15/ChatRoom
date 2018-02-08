//
//  SignUpVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/1/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    //Links to text boxes in storyboard
    @IBOutlet weak var backgroundView: ShadowView!
    @IBOutlet weak var lyonLogo: UIImageView!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var repeatPasswordBox: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpLabel.alpha = 0
        self.usernameBox.alpha = 0
        self.emailBox.alpha = 0
        self.passwordBox.alpha = 0
        self.repeatPasswordBox.alpha = 0
        self.continueButton.alpha = 0
        self.goBackButton.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2, animations: {
                self.signUpLabel.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, animations: {
                self.usernameBox.alpha = 1
                self.emailBox.alpha = 1
                self.passwordBox.alpha = 1
                self.repeatPasswordBox.alpha = 1
                self.continueButton.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 2, animations: {
                self.goBackButton.alpha = 1
            })
        }

        self.usernameBox.delegate = self
        self.emailBox.delegate = self
        self.passwordBox.delegate = self
        self.repeatPasswordBox.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func continueTapped(_ sender: Any) {
        //Makes sure that there is a username and that the email contains the correct characters for emails
        if (usernameBox.text == "") {
            let alertController = UIAlertController(title: "Invalid Settings", message: "Please check that you set a username!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        //Sets values for use in later functions from text boxes in storyboard
        let username = usernameBox.text!
        let email = emailBox.text
        let password = passwordBox.text
        let repeatPassword = repeatPasswordBox.text
        
        if (password != repeatPassword) {                //Checking to see if both password boxes are the same
            let alertController = UIAlertController(title: "Invalid Settings", message: "Your passwords are not the same!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {         //Prints error for sign up failure that does not include missed fields
                    let alertController = UIAlertController(title: "Signup Failed", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    if let user = user {   //Set the user to allow for accessing the data of the user
                        let usernameValue = ["username": username]
                        Util.ds.UserRef.child(user.uid).updateChildValues(usernameValue)
                        UIView.animate(withDuration: 2, animations: {
                            self.signUpLabel.alpha = 0
                            self.usernameBox.alpha = 0
                            self.emailBox.alpha = 0
                            self.passwordBox.alpha = 0
                            self.repeatPasswordBox.alpha = 0
                            self.continueButton.alpha = 0
                            self.goBackButton.alpha = 0
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            let create = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateProfileVC")
                            self.present(create, animated: false, completion: nil)
                        })
                      }
                }
            })
        }
    }
    @IBAction func returnTapped(_ sender: Any) {
        UIView.animate(withDuration: 2) {
            self.signUpLabel.alpha = 0
            self.usernameBox.alpha = 0
            self.emailBox.alpha = 0
            self.passwordBox.alpha = 0
            self.repeatPasswordBox.alpha = 0
            self.continueButton.alpha = 0
            self.goBackButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2, animations: {
                self.lyonLogo.frame = CGRect(x: (self.backgroundView.frame.width / 2) - (120), y: 18, width: 240, height: 240)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIView.animate(withDuration: 2, animations: {
                self.lyonLogo.alpha = 0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
            self.present(signInVC, animated: false, completion: nil)
        }
    }
}
