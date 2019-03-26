//
//  WaitForResponse.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/26/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView
import CountryPickerView

class WaitForResponse: UIViewController, CountryPickerViewDelegate {
    var code = "+1"
    var phoneNumber: String?
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBAction func unCrushBtn(_ sender: UIButton) {
        unCrushAlert()
    }
    
    
    
    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.setIsLoggedIn(value: false)

        }
        catch{
            
        }
    }
    
    func unCrushAlert() {
        // Create the subview
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("I am sure") {
            self.updateDBAfterUnCrush()
            presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
        }
        
        alert.showInfo("Are you sure you want to un-crush?", subTitle: "We will delete your current crush number in our database and you will no longer receive further notification on the current crush status. You can send text to different crush of yours after you un-crush.", closeButtonTitle: "Cancel",  colorStyle: 0x34C4F6)
        
    }
    
    
    func updateDBAfterUnCrush() {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        //delete user's status in db
        ref.child("Users").child((user?.phoneNumber)!).child("Status").removeValue()

        //delete user's number under oldcrush's followers
        let currentUserRef = Database.database().reference().child("Users").child(user!.phoneNumber!)
        currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            let oldCrush = currentUser["CrushNumber"] as! String
            // go into old receiver in loved
            ref.child("Loved").child(oldCrush).child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
                print("old crush followers count", snapshot.childrenCount)
                if snapshot.childrenCount == 1 && snapshot.hasChild((user?.phoneNumber)!) {
                    // if oldcrush only had current user as followers
                    // delete the whole oldcrush object in loved
                    Database.database().reference(withPath: "Loved").child(oldCrush).removeValue()
                } else if snapshot.hasChild((user?.phoneNumber)!) {
                    // if oldcrush had multiple followers
                    // only delete current user's number from followers list
                    Database.database().reference(withPath: "Loved").child(oldCrush).child("Followers").child((user?.phoneNumber)!).removeValue()
                }
            })
            
            
            // delete user's crush number
            ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").removeValue()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        let currentUserRef = Database.database().reference().child("Users").child(user!.phoneNumber!)
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            self.phoneNumber = currentUser["CrushNumber"]!
            self.StatusLabel.text = "Text sent to " +  currentUser["CrushNumber"]! + ". We will notify you if you matched."
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.code = country.phoneCode
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
