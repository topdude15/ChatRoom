//
//  ChatVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/6/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupColor: UIView!
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var chats = [Chat]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        messageBox.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let group = Util.ds.groupKey
        
        Util.ds.GroupRef.child(group).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                if let groupTitle = dictionary["name"] as? String {
                    self.groupTitle.text = groupTitle
                }
                if let color = dictionary["color"] as? String {
                    let realColor = self.hexStringToUIColor(hex: color)
                    self.groupColor.backgroundColor = realColor
                }
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
    
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        let color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
