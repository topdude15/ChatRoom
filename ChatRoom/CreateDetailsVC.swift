//
//  CreateDetailsVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/13/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import ChromaColorPicker

class CreateDetailsVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChromaColorPickerDelegate {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameBox: UITextField!
    @IBOutlet weak var groupKeyBox: UITextField!
    @IBOutlet weak var groupPasswordBox: UITextField!

    var groupCode = "key"
    var imageSelected = false
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: ((self.view.frame.width / 2) - 75), y: ((self.view.frame.height / 2) + 25), width: 150, height: 150))
        neatColorPicker.delegate = self //ChromaColorPickerDelegate
        neatColorPicker.padding = 0
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        self.view.addSubview(neatColorPicker)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        groupCode = Util.ds.createGroupKey
        self.groupKeyBox.text = groupCode
        
        Util.ds.GroupRef.child(groupCode).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                if let groupKey = dictionary["groupKey"] as? String {
                    self.groupKeyBox.text = groupKey
                }
            }
        })
    }

    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        let color: Dictionary<String, AnyObject> = [
            "color": colorPicker.hexLabel.text as AnyObject
        ]
        Util.ds.GroupRef.child(groupCode).updateChildValues(color)
    }
    
    
    @IBAction func addGroupImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            groupImage.image = image
            imageSelected = true
        } else {
            print("Invalid image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func createTapped(_ sender: Any) {
        guard let image = groupImage.image, imageSelected == true else {
            print("An image must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            if let _ = Auth.auth().currentUser {
                Util.ds.StorageRef.child("groupPics").child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("Could not upload image")
                    } else {
                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                        if let link = downloadUrl {
                            
                            if (self.groupPasswordBox.text != "") {
                                let groupPassword = self.groupPasswordBox.text
                                let group: Dictionary<String, AnyObject> = [
                                    "name": self.groupNameBox.text as AnyObject,
                                    "image": link as AnyObject,
                                    "password": groupPassword as AnyObject,
                                    "groupKey": self.groupKeyBox.text as AnyObject
                                ]
                                Util.ds.GroupRef.child(self.groupCode).updateChildValues(group)
                                self.performSegue(withIdentifier: "groupsShow", sender: nil)
                                
                            } else {
                                let uid = Auth.auth().currentUser?.uid
                                
                                //Add user to group
                                let user: Dictionary<String, AnyObject> = [
                                    uid!: true as AnyObject
                                ]
                                Util.ds.GroupRef.child(self.groupCode).child("users").updateChildValues(user)
                                
                                //Add group to user profile
                                let groupRef: Dictionary<String, AnyObject> = [
                                    self.groupCode: true as AnyObject
                                ]
                                
                                Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupRef)
                                
                                let groupKey: Dictionary<String, AnyObject> = [
                                    "groupKey": self.groupCode as AnyObject
                                ]
                                
                                Util.ds.GroupRef.child(self.groupCode).updateChildValues(groupKey)

                                let group: Dictionary<String, AnyObject> = [
                                    "name": self.groupNameBox.text as AnyObject,
                                    "image": link as AnyObject,
                                    "groupKey": self.groupKeyBox.text as AnyObject
                                ]
                                    Util.ds.GroupRef.child(self.groupCode).updateChildValues(group)
                                self.performSegue(withIdentifier: "groupsShow", sender: nil)
                            }
                            

                        }
                    }
                }
            }
        }
    }
    
}
