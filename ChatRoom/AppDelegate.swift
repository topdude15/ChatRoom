//
//  AppDelegate.swift
//  ChatRoom
//
//  Created by Trevor Rose on 7/1/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let alertController = UIAlertController(title: "\(url.host ?? "")", message: "Would you like to join the group \(url.host ?? "")?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Join", style: .default) { (action) in
            let uid = Auth.auth().currentUser?.uid
            let group = url.host
            Util.ds.GroupRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(group!) {
                    print("Group exists")
                    
                    Util.ds.GroupRef.child(group!).observeSingleEvent(of: .value, with: { (snapshot) in
                        print("Here")
                        if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                            if let password = dictionary["password"] as? String {
                                print("That's a thing")
                                let alert = UIAlertController(title: "Enter group password", message: "This group has a password.  Enter the password, or contact the group creator for the password.", preferredStyle: .alert)
                                
                                alert.addTextField { (textField) in
                                    textField.placeholder = "Group password..."
                                }
                                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak alert] (_) in
                                    let textField = alert?.textFields![0]
                                    if (textField!.text == password) {
                                        //Add user to the group
                                        let user: Dictionary<String, AnyObject> = [
                                            uid!: group as AnyObject
                                        ]
                                        Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                                        
                                        //Add group to user profile
                                        let groupId: Dictionary<String, AnyObject> = [
                                            group!: true as AnyObject
                                        ]
                                        Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                                        
                                        //TODO: Close popup
                                    } else {
                                        let alertController = UIAlertController(title: "Incorrect password", message: "This password is incorrect.  Please input the correct password and try again.", preferredStyle: .alert)
                                        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                                        alertController.addAction(defaultAction)
                                        self.window?.currentViewController()?.present(alertController, animated: true, completion: nil)
                                        
                                    }
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                
                                self.window?.currentViewController()?.present(alert, animated: true, completion: nil)
                            } else {
                                //Add user to the group
                                let user: Dictionary<String, AnyObject> = [
                                    uid!: group as AnyObject
                                ]
                                Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                                print("Yeet")
                                
                                //Add group to user profile
                                let groupId: Dictionary<String, AnyObject> = [
                                    group!: true as AnyObject
                                ]
                                Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                                //TODO: Close popup
                            }
                        }
                    })
                    
                    //Add user to the group
                    let user: Dictionary<String, AnyObject> = [
                        uid!: group as AnyObject
                    ]
                    Util.ds.GroupRef.child(group!).child("users").updateChildValues(user)
                    
                    //Add group to user profile
                    let groupId: Dictionary<String, AnyObject> = [
                        group!: true as AnyObject
                    ]
                    Util.ds.UserRef.child(uid!).child("groups").updateChildValues(groupId)
                    
                } else {
                    let alertController = UIAlertController(title: "Group does not exist", message: "This group does not exist!  Please use a valid group code.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.window?.currentViewController()?.present(alertController, animated: true, completion: nil)
                }
            })

        }
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(defaultAction)
        self.window?.currentViewController()?.present(alertController, animated: true, completion: nil)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

