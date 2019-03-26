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
    
    public func twillioSendText(to: String, body: String, completion: @escaping(Bool)->()) {
        
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
        let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"]{
    
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            let parameters = ["From": ProcessInfo.processInfo.environment["TWILIO_NUMBER"], "To": to, "Body": body] as! [String: String]
    
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
//            .responseJSON { response in
//                let status = response.response?.statusCode
//                print(status)
//                if status! > 200 && status! < 299{
//                    return completion(true)
//                }
//                else{
//                    return completion(false)
//                }
//            }
        }
    
        RunLoop.main.run()
    }

}
