//
//  main.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/24/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import Foundation
import Alamofire

if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
    let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
    
    let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
    let parameters = ["From": "9032943794", "To": "9293539492", "Body": "Hello from Swift!"]
    
    Alamofire.request(url, method: .post, parameters: parameters)
        .authenticate(user: accountSID, password: authToken)
        .responseJSON { response in
            debugPrint(response)
    }
     
    RunLoop.main.run()
}
