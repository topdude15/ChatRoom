//
//  GroupListVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/3/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class GroupListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var joinView: UIView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var groupCodeBox: UITextField!
    
    var effect:UIVisualEffect!
    var groups = [Group]()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = effectView.effect
        effectView.effect = nil
        
        joinView.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Util.ds.GroupRef.observe(.value, with: { (snapshot) in
            self.groups = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    
                    if snap.hasChild("users/\(self.uid!)") {
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let group = Group(postKey: key, postData: postDict)
                            self.groups.append(group)
                            self.tableView.reloadData()
                        }
                    } else {

                    }
                }
            }
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        Util.ds.groupKey = group.groupKey
        let reveal = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RevealVC")
        self.present(reveal, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? GroupCell {
            cell.configureCell(group: group)
            return cell
        } else {
            return GroupCell()
        }
    }
    @IBAction func profileSettings(_ sender: Any) {
        let profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profile, animated: true, completion: nil)
    }
    @IBAction func join(_ sender: Any) {
        animateIn()
    }
    @IBAction func joinGroup(_ sender: Any) {
        let key = groupCodeBox.text
        if (key == "") {
            let alert = UIAlertController(title: "Invalid Settings", message: "You did not input a group key.  Please input a valid group key and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Util.ds.GroupRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild(key!) {
                    let uid = Auth.auth().currentUser?.uid
                    let groupInfo: Dictionary<String, AnyObject> = [
                        uid!: true as AnyObject
                    ]
                    Util.ds.GroupRef.child(key!).child("users").updateChildValues(groupInfo)
                    
                    let userInfo: Dictionary<String, AnyObject> = [
                        key!: true as AnyObject
                    ]
                    Util.ds.UserRef.child(uid!).child("groups").updateChildValues(userInfo)
                    self.animateOut()
                } else {
                    let alert = UIAlertController(title: "Invalid Settings", message: "There's no group for this key.  Please input a valid group code.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func createGroup(_ sender: Any) {
        let create = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateMainVC")
        self.present(create, animated: true, completion: nil)
    }
    func animateIn() {
        self.view.addSubview(joinView)
        joinView.center = CGPoint(x: self.view.center.x - 30, y: self.view.center.y)
        
        joinView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        joinView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.effectView.effect = self.effect
            self.joinView.alpha = 1
            self.joinView.transform = CGAffineTransform.identity
        }
    }
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.joinView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.joinView.alpha = 0
            
            self.effectView.effect = nil
        }) { (success: Bool) in
            self.joinView.removeFromSuperview()
        }
    }
    
}
