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
import Alamofire

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
    
    func twillioSendText(to: String, body: String, completion: @escaping(Bool)->()) {

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(TWILIO_ACCOUNT_SID)/Messages"
        let parameters = ["From": TWILIO_NUMBER, "To": to, "Body": body] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: TWILIO_ACCOUNT_SID, password: TWILIO_AUTH_TOKEN)
            .responseJSON { response in
                let status = response.response?.statusCode
                if status! > 200 && status! < 299{
                    return completion(true)
                }
                else{
                    return completion(false)
                }
        }
        
    }
    
    func matchOrNo(num: String, completion: @escaping(Bool)->()) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").setValue(num)
        
        ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
            self.removeSpinner()
            if snapshot.hasChild(num){
                ref.child("Loved").child(num).child("Followers").updateChildValues([(user?.phoneNumber)! : true])

                // print("matched")
                // change status in db
                ref.child("Users").child((user?.phoneNumber)!).child("Status").setValue("Matched")
                // change the other one's status too
                ref.child("Users").child(num).child("Status").setValue("Matched")


                //present matched vc
                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                //have a db object with who are matched
                let couple = ref.child("Matched").childByAutoId()
                couple.updateChildValues(["A" : user?.phoneNumber])
                couple.updateChildValues(["B" : num])
                
                //notify B with text message saying you matched
                self.twillioSendText(to: num, body: "You have matched with your crush(" + num + ").😍 re-open the 'Crush' app to see. http://www.appstore.com/crushsendanonymoussignal", completion: { (completion) in
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
        })
    }
    
}
