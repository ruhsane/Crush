//
//  ViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/23/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        let accountSID = "ACc89f0f2bdefcc860202e3dce683e8855"
        let authToken = "42a5ab35149266391e7649e0c7927c74"
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": "9032943794", "To": "9293539492", "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
        }
        
        RunLoop.main.run()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func 

}

