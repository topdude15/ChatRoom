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
        
        Util.ds.GroupRef.observe(.value, with: { (snapshot) in
            self.groups = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    
                    if snap.hasChild("users/\(self.uid!)") {
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            print(snap.children)
                            let group = Group(postKey: key, postData: postDict)
                            print(snap.value!)
                            print(postDict)
                            self.groups.append(group)
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Nope!")
                    }
                }
            }

        })

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //...
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
    private func addGestures() {
        let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swiftDown.direction = .right
        self.view.addGestureRecognizer(swiftDown)
    }
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "join", sender: nil)
        }
    }

}
