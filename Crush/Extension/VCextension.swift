//
//  Spinner.swift
//  Crush
//
//  Created by Ruhsane Sawut on 3/21/19.
//  Copyright © 2019 Ruhsane Sawut. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    
    func matchOrNo(num: String, completion: @escaping(Bool)->()) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        ref.child("Users").child((user?.uid)!).child("CrushNumber").setValue(num)
        
        ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observe(.value) { (snapshot) in
            self.removeSpinner()
            if snapshot.hasChild(num){
                
                print("matched")
                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                
                let couple = ref.child("Matched").childByAutoId()
                couple.updateChildValues(["A" : user?.phoneNumber])
                couple.updateChildValues(["B" : num])
                
                //notify B with text message saying you matched
                AlamofireRequest().twillioSendText(to: num, body: "You have matched with your crush.😍 re-open the 'Crush' app to see.", completion: { (completion) in
                    if completion == true{
                        print("sent tonification to inform they got matched")
                    } else {
                        print("notification text failed to send")
                    }
                })
                return completion(true)

            } else {
                
                return completion(false)

            }
        }
    }
    
}
