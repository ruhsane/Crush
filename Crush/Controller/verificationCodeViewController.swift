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
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Login(_ sender: Any) {
        self.showSpinner(onView: self.view)

        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: enterCode.text!)

        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            self.removeSpinner()
            if error != nil {
//                print("error: \(String(describing: error?.localizedDescription))")
                let alert = UIAlertController(title: "Invalid Verification Code", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                UserDefaults.standard.setIsLoggedIn(value: true)
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser
                
                ref.child("Users").child((user?.phoneNumber)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("Status"){
                        let status = ref.child("Users").child((user?.phoneNumber)!).child("Status")
                        status.observeSingleEvent(of: .value, with: { (snapshot) in
                            let statusValue = snapshot.value as? String
                            if statusValue == "Matched"{
                                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                            } else if statusValue == "Not Matched" {
                                presentVC(sbName: "Main", identifier: "notMatched", fromVC: self)
                            } else if statusValue == "Wait" {
                                presentVC(sbName: "Main", identifier: "WaitForResponse", fromVC: self)
                            } else {
                                presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
                            }
                        })
                    } else {
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
