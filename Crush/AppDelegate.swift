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
        
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        if UserDefaults.standard.isLoggedIn() == true {
            ref.child("Users").child((user?.phoneNumber)!).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild("Status"){
                    // we have user
                    let status = ref.child("Users").child((user?.phoneNumber)!).child("Status")
                    status.observe(.value, with: { (snapshot) in
                        let statusValue = snapshot.value as? String
                        print(status)
                        print(statusValue)
                        if statusValue == "Matched"{
                            self.setRootVC(identifier: "Matched", vc: MatchedViewController.self)
                        } else if statusValue == "Not Matched" {
                            self.setRootVC(identifier: "notMatched", vc: NotMatchedViewController.self)
                        } else if statusValue == "Wait" {
                            self.setRootVC(identifier: "WaitForResponse", vc: WaitForResponse.self)
                        } else {
                            self.setRootVC(identifier: "mainVC", vc: UserViewController.self)
                        }
                    })
                } else {
                    self.setRootVC(identifier: "mainVC", vc: UserViewController.self)
                }
            })
        } else {
            // we don't have user, show the first page
            setRootVC(identifier: "loginVC", vc: ViewController.self)
        }


        return true
   }

    func setRootVC<T: UIViewController>(identifier: String, vc: T.Type) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? T {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: false, completion: nil)
            }
        }
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

