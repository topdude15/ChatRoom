//
//  CreateDetailsVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/13/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class CreateDetailsVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameBox: UITextField!
    @IBOutlet weak var groupKeyBox: UITextField!
    @IBOutlet weak var groupPasswordBox: UITextField!

    var groupCode = "key"
    var imageSelected = false
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        groupCode = Util.ds.createGroupKey
        
        Util.ds.GroupRef.child(groupCode).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                if let groupKey = dictionary["groupKey"] as? String {
                    self.groupKeyBox.text = groupKey
                }
            }
        })
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
                                    "password": groupPassword as AnyObject
                                ]
                                Util.ds.GroupRef.child(self.groupCode).updateChildValues(group)
                                self.performSegue(withIdentifier: "list", sender: nil)
                                
                            } else {
                                let group: Dictionary<String, AnyObject> = [
                                    "name": self.groupNameBox.text as AnyObject,
                                    "image": link as AnyObject
                                ]
                                    Util.ds.GroupRef.child(self.groupCode).updateChildValues(group)
                                self.performSegue(withIdentifier: "list", sender: nil)
                            }
                            

                        }
                    }
                }
            }
        }
    }
    
}
