//
//  AppDelegate.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/23/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in })
            application.registerForRemoteNotifications()
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    
        let user = Auth.auth().currentUser

        if user != nil{
            
            //Here we want to loop through all the matches entry in our database and see if our number is inside that database
            let number = user!.phoneNumber
            let ref = Database.database().reference().child("Matched")
            
            let currentUserRef = Database.database().reference().child("Users").child(user!.uid)

            
            let currentUserSnap = currentUserRef.observe(.value) { (snapshot) in
                let currentUser = snapshot.value as! [String: String]
                //if the currentUser has a crushNumber inputed
                if currentUser["CrushNumber"] != nil {
                    
                    
                    let matchTree = ref.observe(.value) { (snapshot) in
            
            
                            //first we want to check if we have a crush number
            
            
                            let matches = snapshot.children.allObjects as! [DataSnapshot]
            
                            for match in matches {
                                let object = match.value as! [String: String]
                                if object["A"] == number || object["B"] == number {
                                    // in here we will move to a specific viewController
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let mainVC = storyboard.instantiateViewController(withIdentifier: "Matched")
                                    self.window?.rootViewController = mainVC
                                    self.window?.makeKeyAndVisible()
            
            
                                    print("We have matches! Omg!")
                                }
                            }
                    
                    }
                        //after we check if the current User has a match, check if the current User's crushNumber is in the love database, checking if they sent a text message
                        let crushNumber = currentUser["CrushNumber"]
                        
                        let loveRef = Database.database().reference().child("Loved")
                        
                        
                        let loveTree = loveRef.observe(.value, with: { (snapshot) in
                            //if the crush number key exists in the love database
                            if snapshot.hasChild(crushNumber!) {
                                print("my crush number is in the love database")
                                
                                let crushRef = loveRef.child(crushNumber!).child("Followers")
                                crushRef.observe(.value, with: { (snapshot) in
                                    let crushObject = snapshot.value as! [String: Bool]
                                    if crushObject[number!] == true {
                                        //here, display the waiting VC
                                        print("should wait")
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let mainVC = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
                                        self.window?.rootViewController = mainVC
                                        self.window?.makeKeyAndVisible()
                                    } else {
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let mainVC = storyboard.instantiateViewController(withIdentifier: "notMatched")
                                    self.window?.rootViewController = mainVC
                                    self.window?.makeKeyAndVisible()
                                    
                                    print("crushObject")
                                        }
                                })
                                
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainVC = storyboard.instantiateViewController(withIdentifier: "notMatched")
                                self.window?.rootViewController = mainVC
                                self.window?.makeKeyAndVisible()
                                print("go to not match")
                            }
                            
                        })
                        
            
                        
        
                    //if the currentUser doesn't have a crushNumber
                } else {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
                    self.window?.rootViewController = mainVC
                    self.window?.makeKeyAndVisible()
                    
                    
                }
                
            }
            
            
//
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = loginVC
            window?.makeKeyAndVisible()
        }
        
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

