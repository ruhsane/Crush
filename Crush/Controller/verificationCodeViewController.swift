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
//                self.performSegue(withIdentifier: "logged", sender: Any?.self)

                let userRef = Database.database().reference().child("Users").child((user?.uid)!)
                
                let userAtt = ["myNumber": user?.phoneNumber]
                userRef.updateChildValues(userAtt)
                
//                let rootViewController = UIApplication.shared.keyWindow?.rootViewController
//                guard let UserViewController = rootViewController as? UserViewController else{return}
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                
                //MARK: INITIAL VC LOGIC
                
                let user = Auth.auth().currentUser
                
                if user != nil {
                    
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
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let mainVC = storyboard.instantiateViewController(withIdentifier: "Matched")
//                                        self.present(mainVC, animated: true)
                                        presentVC(sbName: "Main", identifier: "Matched", fromVC: self)

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
//                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                            let mainVC = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
//                                            self.present(mainVC, animated: true)
                                            presentVC(sbName: "Main", identifier: "WaitForResponse", fromVC: self)

                                        } else {
                                            
//                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                            let mainVC = storyboard.instantiateViewController(withIdentifier: "notMatched")
//                                            self.present(mainVC, animated: true)
                                            presentVC(sbName: "Main", identifier: "notMatched", fromVC: self)

                                            print("crushObject")
                                        }
                                    })
                                    
                                } else {
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let mainVC = storyboard.instantiateViewController(withIdentifier: "notMatched")
//                                    self.present(mainVC, animated: true)
                                    presentVC(sbName: "Main", identifier: "notMatched", fromVC: self)

                                    print("go to not match")
                                }
                                
                            })
                            
                            //if the currentUser doesn't have a crushNumber
                        } else {
                            
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
//                            self.present(mainVC, animated: true)
                            presentVC(sbName: "Main", identifier: "mainVC", fromVC: self)

                        }
                    }
                    
                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC")
//                    self.present(mainVC, animated: true)
                    
                }
//                else {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
//                    self.present(loginVC, animated: true)
//                }
                
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
