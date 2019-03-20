//
//  main.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/24/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

public class AlamofireRequest {
    
    public func twillioSendText(fromVC: UIViewController, to: String, body: String, completion: @escaping(Bool)->()) {
        let fromVC = fromVC
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
        let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"]{
    
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": "9032943794", "To": to, "Body": body]
    
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                let status = response.response?.statusCode
                if status! > 200 && status! < 299{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let WaitForResponse = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
                    fromVC.present(WaitForResponse,animated: true)
                    return completion (true)
                    
                }
                else{
                    let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    fromVC.present(alert, animated: true, completion: nil)
                    return completion(false)
                }
            }
        }
    
        RunLoop.main.run()
    }

}
