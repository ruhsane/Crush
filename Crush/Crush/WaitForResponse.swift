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

class WaitForResponse: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let ref = Database.database().reference()
//        let user = Auth.auth().currentUser
//        let num = self.code + self.enterNumberTextField.text!
//
//        ref.child("Loved").observe(.value) { (snapshot) in
//            if snapshot.hasChild((user?.phoneNumber)!){
//                ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observe(.value) { (snapshot) in
//
//                    if snapshot.hasChild(num){
//
//                        print("matched")
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let Matched = storyboard.instantiateViewController(withIdentifier: "Matched")
//                        self.present(Matched,animated: true)
//
//                    }else{
//
//                        print("not matched")
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let notMatched = storyboard.instantiateViewController(withIdentifier: "notMatched")
//                        self.present(notMatched,animated: true)
//                    }
//                }
//
//            }else{
//
//                print("no one labeled you as their crush.")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let notMatched = storyboard.instantiateViewController(withIdentifier: "notMatched")
//                self.present(notMatched,animated: true)
//            }
//        }
        
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
