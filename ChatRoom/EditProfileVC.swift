//
//  EditProfileVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 8/27/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if let uid = Auth.auth().currentUser?.uid {
            Util.ds.UserRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    if let username = dictionary["username"] as? String {
                        self.usernameField.text = username
                    }
                    if let name = dictionary["name"] as? String {
                        self.nameField.text = name
                    }
                    if let date = dictionary["age"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM dd yyyy"
                        if let userDate = dateFormatter.date(from: date) {
                            self.datePicker.date = userDate
                        }
                        
                    }
                    if let profileImageIcon = dictionary["profileImage"] {
                        let ref = Storage.storage().reference(forURL: profileImageIcon as! String)
                        ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                            if error != nil {
                                print("Image could not be downloaded")
                            } else {
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.profileImage.image = img
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
        
    }
    @IBAction func saveButton(_ sender: Any) {
        let name = nameField.text
        let username = usernameField.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        let selectedDate = dateFormatter.string(from: self.datePicker.date)
        
        let image = profileImage.image
        if let imgData = UIImageJPEGRepresentation(image!, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            Util.ds.StorageRef.child("profilePics").child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Error uploading image")
                } else {
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let link = downloadUrl {
                        if let uid = Auth.auth().currentUser?.uid {
                            let info: Dictionary<String, AnyObject> = [
                                "profileImage": link as AnyObject,
                                "age": selectedDate as AnyObject,
                                "name": name as AnyObject,
                                "username": username as AnyObject
                                ]
                            Database.database().reference().child("users").child(uid).updateChildValues(info)
                        }
                    }
                }
            }
            
        }
        
        self.performSegue(withIdentifier: "saved", sender: nil)

    }
    @IBAction func changeImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
        } else {
            print("Invalid image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}