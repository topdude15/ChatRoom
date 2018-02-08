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
    
    @IBOutlet weak var lyonLogo: UIImageView!
    @IBOutlet weak var lyonTitle: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var dontHaveAcctLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backgroundView: ShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyonLogo.alpha = 0
        lyonTitle.alpha = 0
        emailField.alpha = 0
        passwordField.alpha = 0
        signInButton.alpha = 0
        dontHaveAcctLabel.alpha = 0
        signUpButton.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2) {
                self.lyonLogo.alpha = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, animations: {
                self.lyonTitle.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 2, animations: {
                self.emailField.alpha = 1
                self.passwordField.alpha = 1
                self.signInButton.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            UIView.animate(withDuration: 2, animations: {
                self.dontHaveAcctLabel.alpha = 1
                self.signUpButton.alpha = 1
            })
        }
        emailField.delegate = self as? UITextFieldDelegate
        passwordField.delegate = self as? UITextFieldDelegate
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func signIn(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error Signing In", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let revealVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RevealVC")
                    self.present(revealVC, animated: true, completion: nil)
                }
            })
        } else {
            let alert = UIAlertController(title: "Incorrect Email/Password", message: "You have not entered a valid email/password.  Please enter your information and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func signUp(_ sender: Any) {
        UIView.animate(withDuration: 2) {
            self.lyonLogo.frame = CGRect(x: (self.backgroundView.frame.width / 2) - (128 / 2), y: 8, width: 128, height: 128)
            self.lyonTitle.alpha = 0
            self.emailField.alpha = 0
            self.passwordField.alpha = 0
            self.signInButton.alpha = 0
            self.dontHaveAcctLabel.alpha = 0
            self.signUpButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
            self.present(signUpVC, animated: false, completion: nil)
        }
    }
}
