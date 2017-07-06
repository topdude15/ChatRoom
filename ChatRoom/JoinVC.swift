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

        // Do any additional setup after loading the view.
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
    @IBAction func test(_ sender: Any) {
        performSegue(withIdentifier: "list", sender: nil)
    }
}
