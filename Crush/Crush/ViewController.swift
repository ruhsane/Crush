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

    @IBAction func loginButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LoginPage")
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var enterNumberTextField: UITextField!
    @IBAction func sendButton(_ sender: UIButton) {
//        print ( "text sent" )
//        let storyboard = UIStoryboard(name: "Main", bundle: nil);
//        let vc = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
//        self.present(vc, animated: true, completion: nil)
        sendText()

    }
    
    
    func showKeyboard() {
        self.enterNumberTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sendText() {
        let accountSID = "ACc89f0f2bdefcc860202e3dce683e8855"
        let authToken = "42a5ab35149266391e7649e0c7927c74"
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let int = Int(enterNumberTextField.text!)!
        let str = String(int)
        let parameters = ["From": "9032943794", "To": str, "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
        }
        
        RunLoop.main.run()
    }

}

