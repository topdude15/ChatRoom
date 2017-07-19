//
//  CreateMainVC.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/3/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class CreateMainVC: UIViewController {

    @IBOutlet weak var codeBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createGroup(_ sender: Any) {
        
        let userCode = codeBox.text
        
        Util.ds.GroupRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userCode!) {
                let alertController = UIAlertController(title: "Group already exists", message: "A group for this code already exists.  Please use a different code.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                
                
                Util.ds.createGroupKey = userCode!
                
                self.performSegue(withIdentifier: "create", sender: nil)
                
            }
        })
    }
    
}
