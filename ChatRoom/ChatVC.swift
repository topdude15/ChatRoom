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

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupColor: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    //UID for references to the current user
    let uid = Auth.auth().currentUser?.uid
    
    //Setup image cache and array for chat cells
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var chats = [Chat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup SWRevealViewController for menuButton
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        print("Added!")
        //Add swipe to access menu and tap to close menu to view
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //Set the estimated row height of cells to allow cells to expand
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        //Set up message box to be closable
        messageBox.delegate = self
        
        //Set up tableView to allow input of data
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Get group key from  Util file, will be set in list
        let group = Util.ds.groupKey
        
        //Get the group name and color and set accordingly
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
        
        //Get the messages from the database and insert as cells
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
    //Close keyboard on Return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //Setup table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Go from the chat into a profile page for the user who made the chat
    }
    
    //Configure cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ChatCell {
            cell.configureCell(chat: chat)
            return cell
        } else {
            return ChatCell()
        }
    }

    //Runs when the user presses 'Send' on the chat button
    @IBAction func sendTapped(_ sender: Any) {
        let message = self.messageBox.text
        if (message == "") {
            //Message box is empty
            print("No message entered")
        } else {
            //Get user information
            Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let username = dictionary["username"]
                    let image = dictionary["profileImage"]
                    
                    let chat: Dictionary<String, AnyObject> = [
                        "username": username!,
                        "image": image!,
                        "message": message as AnyObject
                    ]
                    
                    //Upload chat to database
                    let postId = Util.ds.GroupRef.child(Util.ds.groupKey).child("messages").childByAutoId()
                    postId.setValue(chat)
                    
                    //Clear chat box
                    self.messageBox.text = ""
                    
                }
            })
        }
    }
    
    //Turn string into UIColor
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
