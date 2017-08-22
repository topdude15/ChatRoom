//
//  JoinVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/2/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class JoinVC: UIViewController {

    @IBOutlet weak var groupCodeBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser?.uid
        if (Util.ds.wentHome == false) {
            Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("groups") {
                    print("Yup")
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        print("Ye")
                        self.performSegue(withIdentifier: "reveal", sender: nil)
                        Util.ds.wentHome = true
                    })
                }
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //TODO: Check if the user is in any groups and go to the group list if so
    }

    @IBAction func joinTapped(_ sender: Any) {
        let group = groupCodeBox.text
        let uid = Auth.auth().currentUser?.uid
        
       Util.ds.GroupRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(group!) {
                print("Group exists")
            
                Util.ds.GroupRef.child(group!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                        if let password = dictionary["password"] as? String {
                            let alert = UIAlertController(title: "Enter group password", message: "This group has a password.  Enter the password, or contact the group creator for the password.", preferredStyle: .alert)
                            
                            alert.addTextField { (textField) in
                                textField.placeholder = "Group password..."
                            }
                            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak alert] (_) in
                                let textField = alert?.textFields![0]
                                if (textField!.text == password) {
                                    //Add user to the group
                                    let user: Dictionary<String, AnyObject> = [
                                        uid!: group as AnyObject
                                    ]
                                    Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                                    
                                    //Add group to user profile
                                    let groupId: Dictionary<String, AnyObject> = [
                                        group!: true as AnyObject
                                    ]
                                    Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                                    
                                    self.performSegue(withIdentifier: "reveal", sender: nil)
                                } else {
                                    let alertController = UIAlertController(title: "Incorrect password", message: "This password is incorrect.  Please input the correct password and try again.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)

                                }
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            //Add user to the group
                            let user: Dictionary<String, AnyObject> = [
                                uid!: group as AnyObject
                            ]
                            Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                            
                            //Add group to user profile
                            let groupId: Dictionary<String, AnyObject> = [
                                group!: true as AnyObject
                            ]
                            Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                            self.performSegue(withIdentifier: "reveal", sender: nil)
                        }
                    }
                })
                
                //Add user to the group
                let user: Dictionary<String, AnyObject> = [
                    uid!: group as AnyObject
                ]
                Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                
                //Add group to user profile
                let groupId: Dictionary<String, AnyObject> = [
                    group!: true as AnyObject
                ]
                Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                
            } else {
                let alertController = UIAlertController(title: "Group does not exist", message: "This group does not exist!  Please use a valid group code.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    @IBAction func createGroup(_ sender: Any) {
        performSegue(withIdentifier: "create", sender: nil) 
    }
    @IBAction func signOut(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: nil)
    }
}
