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
        
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
            
            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            let parameters = ["From": ProcessInfo.processInfo.environment["TWILIO_NUMBER"], "To": to, "Body": body] as! [String: String]
            print(parameters)
            //            Alamofire.request(url, method: .post, parameters: parameters, encoding: parameters)
            Alamofire.request(url, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    print(response)
                    let status = response.response?.statusCode
                    print(status)
                    if status! > 200 && status! < 299{
                        return completion(true)
                    }
                    else{
                        return completion(false)
                    }
            }
        }
        
//        RunLoop.main.run()
    }
    
    func matchOrNo(num: String, completion: @escaping(Bool)->()) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").setValue(num)
        ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observeSingleEvent(of: .value, with: { (snapshot) in
            self.removeSpinner()
            if snapshot.hasChild(num){
                
                print("matched")
                // change status in db
                ref.child("Users").child((user?.phoneNumber)!).child("Status").setValue("Matched")
                // change the other one's status too
                ref.child("Users").child(num).child("Status").setValue("Matched")


//                ref.child("Users").child(num).child("Status").setValue("Matched")

                //present matched vc
                presentVC(sbName: "Main", identifier: "Matched", fromVC: self)
                //have a db object with who are matched
                let couple = ref.child("Matched").childByAutoId()
                couple.updateChildValues(["A" : user?.phoneNumber])
                couple.updateChildValues(["B" : num])
                
                //notify B with text message saying you matched
                self.twillioSendText(to: num, body: "You have matched with your crush(" + num + ").😍 re-open the 'Crush' app to see.", completion: { (completion) in
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
