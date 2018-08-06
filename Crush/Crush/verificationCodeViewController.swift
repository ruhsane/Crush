//
//  verificationCodeViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/30/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth

class verificationCodeViewController: UIViewController {

    @IBOutlet weak var enterCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Login(_ sender: Any) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: enterCode.text!)
//        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
//            if error != nil {
//                print("error: \(String(describing: error?.localizedDescription))")
//            } else {
//                print("Phone number: \(String(describing: user?.phoneNumber))")
//                let userInfo = user?.providerData[0]
//                print("Provider ID: \(String(describing: userInfo?.providerID))")
//                self.performSegue(withIdentifier: "logged", sender: Any?.self)
//            }
//        }
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                self.performSegue(withIdentifier: "logged", sender: Any?.self)
                

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
