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

        Auth.auth().signIn(with: credential) { (user, error) in
            self.removeSpinner()
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
                UserDefaults.standard.setIsLoggedIn(value: true)
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser
                
                ref.child("Users").child((user?.phoneNumber)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("Status"){
                        let status = ref.child("Users").child((user?.phoneNumber)!).child("Status")
                        status.observeSingleEvent(of: .value, with: { (snapshot) in
                            let statusValue = snapshot.value as? String
                            print(status)
                            print(statusValue)
                            if statusValue == "Matched"{
                                //                        self.setRootVC(identifier: "Matched", vc: MatchedViewController.self)
                                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                                
                            } else if statusValue == "Not Matched" {
                                presentVC(sbName: "Main", identifier: "notMatched", fromVC: self)
                                
                                //                        self.setRootVC(identifier: "notMatched", vc: NotMatchedViewController.self)
                            } else if statusValue == "Wait" {
                                presentVC(sbName: "Main", identifier: "WaitForResponse", fromVC: self)
                                
                                //                        self.setRootVC(identifier: "WaitForResponse", vc: WaitForResponse.self)
                            } else {
                                presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
                                
                                //                        self.setRootVC(identifier: "mainVC", vc: UserViewController.self)
                            }
                        })
                    } else {
                        presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)
                    }
                })
            }
        }
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

extension verificationCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        <#code#>
//    }
}
