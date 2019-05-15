//
//  verificationCodeViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/30/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class verificationCodeViewController: UIViewController {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var enterCode: UITextField!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
    }
    
    // user clicks on login button after entering verification code
    @IBAction func Login(_ sender: Any) {
        //shows loading spinner
        self.showSpinner(onView: self.view)

        // save user's entered verfication code credential to userDefaults
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: enterCode.text!)

        // try singing in with the credential using FirebaseAuth
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            // remove the loading spinner after retrieving the data
            self.removeSpinner()
            
            // if the verification code was incorrect
            if error != nil {
                // make alert view with message
                let alert = UIAlertController(title: "Invalid Verification Code", message: "", preferredStyle: .alert)
                // add "ok" button to alert view
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                //present the alert view
                self.present(alert, animated: true, completion: nil)
                
            // if the verfication code was valid
            } else {
                // set the user as logged in on userDefaults
                UserDefaults.standard.setIsLoggedIn(value: true)
                
                // make firebase database reference
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser
                
                // go in to Users in database
                ref.child(DatabaseKeys.Users).child((user?.phoneNumber)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // if the user already has account and status
                    if snapshot.hasChild(DatabaseKeys.Status){
                        // check the status
                        let status = ref.child(DatabaseKeys.Users).child((user?.phoneNumber)!).child(DatabaseKeys.Status)
                        status.observeSingleEvent(of: .value, with: { (snapshot) in
                            let statusValue = snapshot.value as? String
                            // if status = matched
                            if statusValue == "Matched"{
                                // present Matched page for user
                                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                                
                            //if status is not matched
                            } else if statusValue == "Not Matched" {
                                // present the not Matched page
                                presentVC(sbName: "Main", identifier: "notMatched", fromVC: self)
                            // if status is user is waiting for response of their crush
                            } else if statusValue == "Wait" {
                                // present waitingForResponse view controller
                                presentVC(sbName: "Main", identifier: "WaitForResponse", fromVC: self)
                            // any other status
                            } else {
                                // show the main page
                                presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
                            }
                        })
                        
                    // the user does not have status in their account
                    } else {
                        // show main page
                        presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
                    }
                })
            }
        }
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
