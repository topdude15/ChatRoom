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
    var groups = [Group]()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        print("Nope!")
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
        performSegue(withIdentifier: "chatSW", sender: nil)
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

    @IBAction func backTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "join", sender: nil)
    }
}
