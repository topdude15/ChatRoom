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
    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var repeatPasswordBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameBox.delegate = self
        self.emailBox.delegate = self
        self.passwordBox.delegate = self
        self.repeatPasswordBox.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "join", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
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
                    let alertController = UIAlertController(title: "Signup Failed", message: "The sign up has failed.  Please contact us and try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    if let user = user {   //Set the user to allow for accessing the data of the user
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()  //Changes the displayName of the user for Firebase, which is shown in the authentication email
                        changeRequest?.displayName = username
                        changeRequest?.commitChanges(completion: { (error) in
                            Auth.auth().currentUser?.sendEmailVerification { (error) in    //Sends verification email
                                let usernameValue = ["username": username] //Setting up for username update
                                Database.database().reference().child("users").child(user.uid).updateChildValues(usernameValue)  //Sets the user's username in Firebase
                                let alertController = UIAlertController(title: "Signup Completed", message: "Please confirm your email to continue.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "Close", style: .default, handler: { action in
                                    self.performSegue(withIdentifier: "addImage", sender: nil)   //Go to next screen when user closes popup to confirm email
                                })
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)  //Present popup to tell user to validate email
                            }
                        })

                    }
                }
            })
        }
    }
}
