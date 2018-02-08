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

    @IBOutlet weak var lyonLogo: UIImageView!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var usernameBox: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Set alpha of everything to 0 so everything is invisible when the page loads
        self.createLabel.alpha = 0
        self.userImage.alpha = 0
        self.nameBox.alpha = 0
        self.usernameBox.alpha = 0
        self.finishButton.alpha = 0
        self.backButton.alpha = 0
        
        //This set of animations is to slowly bring in each UI element when the page loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2) {
                self.createLabel.alpha = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, animations: {
                self.userImage.alpha = 1
                self.nameBox.alpha = 1
                self.usernameBox.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 2, animations: {
                self.finishButton.alpha = 1
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            UIView.animate(withDuration: 2, animations: {
                self.backButton.alpha = 1
            })
        }
        
        //Gets the user's username from the last page and automatically puts it into the username box
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
    @IBAction func finishProfile(_ sender: Any) {
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
                        let alert = UIAlertController(title: "Unknown Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                        if let link = downloadUrl {
                            let uid = Auth.auth().currentUser?.uid
                            //Get real name
                            let name = self.nameBox.text
                            
                            let post: Dictionary<String, AnyObject> = [
                                "profileImage": link as AnyObject,
                                "name": name as AnyObject
                            ]
                            Util.ds.UserRef.child(uid!).updateChildValues(post)
                            let reveal = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RevealVC")
                            self.present(reveal, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 2) {
            self.createLabel.alpha = 0
            self.userImage.alpha = 0
            self.nameBox.alpha = 0
            self.usernameBox.alpha = 0
            self.finishButton.alpha = 0
            self.backButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let signUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
            self.present(signUp, animated: false, completion: nil)
        }
    }
}
