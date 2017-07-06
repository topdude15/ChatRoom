//
//  AddUserImage.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/2/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class AddUserImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var addUserImage: UITapGestureRecognizer!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var agePicker: UIDatePicker!
    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let uid = Auth.auth().currentUser?.uid
        Util.ds.UserRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let username = dictionary["username"]
                self.usernameBox.text = username as? String
            }
        })
    }
    
    @IBAction func addUserImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImage.image = image
            imageSelected = true
        } else {
            print("Invalid image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadUserImage(_ sender: Any) {
        
        guard let image = userImage.image, imageSelected == true else {
            print("An image must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            if let _ = Auth.auth().currentUser {
                Util.ds.StorageRef.child("profilePics").child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("You are a loser and your photo could not be uploaded")
                    } else {
                        print("Photo uploaded, you are not really a loser")
                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                        if let link = downloadUrl {
                             let uid = Auth.auth().currentUser?.uid
                            
                            //Get age from age picker, age is in selectedDate
                            self.agePicker.datePickerMode = UIDatePickerMode.date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM dd yyyy"
                            let selectedDate = dateFormatter.string(from: self.agePicker.date)
                            //Get real name
                            let name = self.nameBox.text
                            
                            let post: Dictionary<String, AnyObject> = [
                                "profileImage": link as AnyObject,
                                "age": selectedDate as AnyObject,
                                "name": name as AnyObject
                            ]
                            Util.ds.UserRef.child(uid!).updateChildValues(post)
                            self.performSegue(withIdentifier: "join", sender: nil)

                        }
                    }
                }
            }
        }
    }
    
}
