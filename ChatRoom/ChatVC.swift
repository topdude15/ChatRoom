//
//  ChatVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/6/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var groupTitle: UILabel!
    
    let uid = Auth.auth().currentUser?.uid
    
    var chats = [Chat]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        let group = Util.ds.groupKey

        tableView.delegate = self
        tableView.dataSource = self
        
        Util.ds.GroupRef.child(group).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let groupTitle = dictionary["name"] as? String
                self.groupTitle.text = groupTitle
            }
        })
        
        Util.ds.GroupRef.child(group).child("messages").observe(.value, with: { (snapshot) in
            self.chats = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let chat = Chat(postKey: key, postData: postDict)
                        self.chats.insert(chat, at: 0)
                        self.tableView.reloadData()
                    }
                }
            }
        })

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //...
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ChatCell {
            cell.configureCell(chat: chat)
            return cell
        } else {
            return ChatCell()
        }
    }

    @IBAction func sendTapped(_ sender: Any) {
        let message = self.messageBox.text
        if (message == "") {
            print("No message entered")
        } else {
            Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let username = dictionary["username"]
                    let image = dictionary["profileImage"]
                    
                    let chat: Dictionary<String, AnyObject> = [
                        "username": username!,
                        "image": image!,
                        "message": message as AnyObject
                    ]
                    let postId = Util.ds.GroupRef.child(Util.ds.groupKey).child("messages").childByAutoId()
                    postId.setValue(chat)
                    
                    self.messageBox.text = ""
                    
                }
            })
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "list", sender: nil)
    }
}
