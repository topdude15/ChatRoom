//
//  ProfileVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/16/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uid = Auth.auth().currentUser?.uid
        
        Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                if let username = dictionary["username"] as? String {
                    self.usernameLabel.text = username
                }
                if let name = dictionary["name"] as? String {
                    self.nameLabel.text = name
                }
                if let profileImage = dictionary["profileImage"] as? String {
                    let ref = Storage.storage().reference(forURL: profileImage)
                    ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                        if error != nil {
                            print("Image could not be download")
                        } else {
                            if let imgData = data {
                                if let img = UIImage(data: imgData) {
                                    self.profileImage.image = img
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    @IBAction func editProfile(_ sender: Any) {
        let edit = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC")
        self.present(edit, animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
        self.present(signIn, animated: true, completion: nil)
    }
}
