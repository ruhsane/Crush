//
//  MatchedViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 8/9/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

class MatchedViewController: UIViewController {

    var oldCrush: String = ""
    
    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func unmatchBtn(_ sender: Any) {
        // alert
        unmatchAlert()
    }
    
    func unmatchAlert() {
        // Create the subview
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("I am sure") {
            
            self.thisNeedsToFinishBeforeWeCanDoTheNextStep(completion: { oldCrush in
                self.thisFunctionNeedsToExecuteSecond {
                    self.ExecuteThird()
                }
            })
            
            presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
        }
        
        alert.showInfo("Are you sure you want to un-match?", subTitle: "It will change the status on both of your app, and you cannot undo this step.", closeButtonTitle: "Cancel",  colorStyle: 0xe82727)
        
    }
    
    func thisNeedsToFinishBeforeWeCanDoTheNextStep(completion: @escaping (String) -> Void) {
        let user = Auth.auth().currentUser
        
        // get old Crush num
        let currentUserRef = Database.database().reference().child("Users").child(user!.phoneNumber!)
        currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            self.oldCrush = currentUser["CrushNumber"]!
            completion(self.oldCrush)

        }
    }
    
    func thisFunctionNeedsToExecuteSecond(completion: () -> ()) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        // go into old receiver in loved, delete user under other's followers
        ref.child("Loved").child(self.oldCrush).child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
            print("old crush followers count", snapshot.childrenCount)
            if snapshot.childrenCount == 1 && snapshot.hasChild((user?.phoneNumber)!) {
                // if oldcrush only had current user as followers
                // delete the whole oldcrush object in loved
                Database.database().reference(withPath: "Loved").child(self.oldCrush).removeValue()
            } else if snapshot.hasChild((user?.phoneNumber)!) {
                // if oldcrush had multiple followers
                // only delete current user's number from followers list
                Database.database().reference(withPath: "Loved").child(self.oldCrush).child("Followers").child((user?.phoneNumber)!).removeValue()
            }
        })
        
        // delete the oldCrush under user's followers
        ref.child("Loved").child((user?.phoneNumber)!).child("Followers").child(self.oldCrush).removeValue()
        
        completion()
    }
    
    func ExecuteThird(){
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        // delete old crush's status
        ref.child("Users").child(self.oldCrush).child("Status").removeValue()
        
        // delete user from oldCrush's crush
        ref.child("Users").child(self.oldCrush).child("CrushNumber").removeValue()
        
        // delete matched object
        //Here we want to loop through all the matches entry in our database and find our number inside that database
        let number = user!.phoneNumber
        
        ref.child("Matched").observeSingleEvent(of: .value, with: { (snapshot) in
            let matches = snapshot.children.allObjects as! [DataSnapshot]
            
            for match in matches {
                print(match)
                print("match.key:::", match.key)
                let object = match.value as! [String: String]
                print(object)
                if object["A"] == number || object["B"] == number {
                    //delete the whole object
                    ref.child("Matched").child(match.key).removeValue()
                    return
                }
            }
        })
        
        // delete user's crush number
        ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").removeValue()
        
        // delete user's status
        ref.child("Users").child((user?.phoneNumber)!).child("Status").removeValue()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
