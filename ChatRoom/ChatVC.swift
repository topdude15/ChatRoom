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

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupColor: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var postImage: RoundedPostImage!
    @IBOutlet weak var settingsButton: UIButton!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    //UID for references to the current user
    let uid = Auth.auth().currentUser?.uid
    
    //Setup image cache and array for chat cells
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var chats = [Chat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Setup SWRevealViewController for menuButton
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        settingsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
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
        
        if Util.ds.groupKey == "q" {
            settingsButton.isHidden = true
        }
        
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
        let referralCode = Util.ds.referralCode
        
        if (referralCode != "") {
            let alertController = UIAlertController(title: "Invalid Settings", message: "Please check that you set a username!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            Util.ds.referralCode = ""
        }

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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chat = chats[indexPath.row]
//    }
    
    //Configure cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        
        if chat.postImage != nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell {
                cell.configurePhotoCell(chat: chat)
                return cell
            } 
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ChatCell {
            cell.configureCell(chat: chat)
            return cell
        } else {
            return ChatCell()
        }
    }

    //Runs when the user presses 'Send' on the chat button
    @IBAction func sendTapped(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let message = self.messageBox.text
        if (message == "") {
            //Message box is empty
            let alert = UIAlertController(title: "Invalid Settings", message: "You haven't entered a message.  Please enter a message and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //Get user information
            if Util.ds.groupKey == "q" {
                let alertController = UIAlertController(title: "No Group", message: "You haven't selected a group.  Go the menu and select a group", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            } else {
                Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                        let username = dictionary["username"]
                        let image = dictionary["profileImage"]
                        
                        var chat: Dictionary<String, AnyObject>? = nil
                        
                        if (self.imageSelected == true) {
                            let image = self.postImage.image
                            if let imgData = UIImageJPEGRepresentation(image!, 0.2) {
                                let imgUid = NSUUID().uuidString
                                let metadata = StorageMetadata()
                                metadata.contentType = "image/jpeg"
                                
                                    Util.ds.StorageRef.child("postPics").child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                                        if error != nil {
                                            let alert = UIAlertController(title: "Unknown Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        } else {
                                            let downloadUrl = metadata?.downloadURL()?.absoluteString
                                            if let link = downloadUrl {
                                                chat = [
                                                    "poster": uid as AnyObject,
                                                    "username": username!,
                                                    "image": link as AnyObject,
                                                    "message": message as AnyObject,
                                                    "postImage": link as AnyObject
                                                ]
                                                //Upload chat to database
                                                let postId = Util.ds.GroupRef.child(Util.ds.groupKey).child("messages").childByAutoId()
                                                postId.setValue(chat)
                                            }
                                        }
                                    }
                            }
                        } else {
                            chat = [
                                "poster": uid as AnyObject,
                                "username": username!,
                                "image": image!,
                                "message": message as AnyObject,
                            ]
                            //Upload chat to database
                            let postId = Util.ds.GroupRef.child(Util.ds.groupKey).child("messages").childByAutoId()
                            postId.setValue(chat)
                        }

                        //Clear chat box
                        self.messageBox.text = ""
                        self.postImage.image = #imageLiteral(resourceName: "plus")
                    
                    }
                })
            }
        }
    }
    
    //Turn string into UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
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
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImage.image = image
            imageSelected = true
        } else {
            let alert = UIAlertController(title: "Invalid Image", message: "This image is invalid.  Please select a valid image and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
