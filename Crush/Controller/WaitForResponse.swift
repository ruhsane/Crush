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

    @IBAction func changeCrushBtn(_ sender: Any) {
        changeCrushAlert()
    }
    
    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            presentVC(sbName: "Main", identifier: "loginVC", fromVC: self)
            UserDefaults.standard.setIsLoggedIn(value: false)


        }
        catch{
            
        }
    }
    
    func changeCrushAlert() {
        // Create the subview
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("I am sure") {
            self.popUpView()

        }
        
        alert.showInfo("Are you sure you want to change?", subTitle: "We will update your crush number in our database and you will no longer receive further notification on the current crush status", closeButtonTitle: "Cancel",  colorStyle: 0x34C4F6)
        
    }
    
    func popUpView() {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        cpv.showCountryCodeInView = false
        cpv.delegate = self
        
        txt.leftView = cpv
        txt.leftViewMode = .always
        
        alert.addButton("Send Anonymous Text") {
//            self.showSpinner(onView: self.view)
            let num = txt.text ?? ""
            let fullNum = self.code + num
            print(fullNum)

            //  if the number user sending message to is in user's followers, match them (takes care of matching in matchorno func).
            self.matchOrNo(num: fullNum, completion: { (matched) in
                if matched == false {
                    // TODO: check if the number was the same as the old num

                    self.sendText(fullNum: fullNum)
                }
            })
        }
        
        alert.showEdit("", subTitle: "Enter your crush's number")
    }
    
    func sendText(fullNum: String) {
        self.twillioSendText(to: fullNum, body: "Someone labeled you as his/her crush on 'Crush' app. Download the app to see.", completion: { (completion) in
            print(completion)
            if completion == true{
                
                self.updateDBAfterTxt(num: fullNum)
                
            } else {
                let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func updateDBAfterTxt(num: String) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("Users").child((user?.phoneNumber)!).child("Status").setValue("Wait")

        let currentUserRef = Database.database().reference().child("Users").child(user!.phoneNumber!)
        currentUserRef.observeSingleEvent(of: .value) { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            
            //if the currentUser has a crushNumber already, update db
            if currentUser["CrushNumber"] != nil {
                let oldCrush = currentUser["CrushNumber"] as! String
                // go into old receiver in loved
                ref.child("Loved").child(oldCrush).child("Followers").observe(.value, with: { (snapshot: DataSnapshot!) in
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
            }
            
            // update/write crush number for user
            ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").setValue(num)
            
            // receiver phone number in db with sender number under followers
            ref.child("Loved").child(num).child("Followers").updateChildValues([(user?.phoneNumber)! : true])

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        guard let number = self.phoneNumber else { return}
        print(number)

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
