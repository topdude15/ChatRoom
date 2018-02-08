//
//  GroupSettingsVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 9/5/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class GroupSettingsVC: UIViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rightViewRevealWidth = self.view.frame.size.width - 60
        let group = Util.ds.groupKey
        if (group == "q") {
            print("No Key")
        } else {
            Util.ds.GroupRef.child(group).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let groupName = dictionary["name"]
                    self.groupTitle.text = groupName as? String
                    if let profileImage = dictionary["image"] as? String {
                        let ref = Storage.storage().reference(forURL: profileImage)
                        ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                            if error != nil {
                                print("Image could not be download")
                            } else {
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.groupImage.image = img
                                    }
                                }
                            }
                        }
                    }

                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func shareButton(_ sender: Any) {
        let group = Util.ds.groupKey
        let textToShare = "Join my Lyon group, \(group), today!"
        let linkToShare = NSURL(string: "LyonChat://\(group)")
        let objectsToShare: Array = [textToShare, linkToShare ?? ""] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare , applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

}
