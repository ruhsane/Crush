//
//  UserViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 8/6/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseDatabase


class UserViewController: UIViewController {
    var ref: DatabaseReference!

    
    @IBAction func SignOut(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
            
            self.present(loginVC,animated: true)
        }
        catch{
            
        }
//        let LoginController = LoginPage()
//        present(LoginController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var enterNumberTextField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        sendText { (completed) in
            
            if completed == true{
                let ref = Database.database().reference()
                
                //add crush number under user uid
                let user = Auth.auth().currentUser
                
                ref.child("Users").child((user?.uid)!).child("CrushNumber").setValue(self.enterNumberTextField.text)

                ref.child("Loved").child(self.enterNumberTextField.text!).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
            }
        }
    }
    
    func showKeyboard() {
        self.enterNumberTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
     }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendText(completion: @escaping(Bool)->()) {
        let accountSID = "ACc89f0f2bdefcc860202e3dce683e8855"
        let authToken = "42a5ab35149266391e7649e0c7927c74"
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let int = Int(enterNumberTextField.text!)!
        let str = String(int)
        let parameters = ["From": "9032943794", "To": str, "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                let status = response.response?.statusCode
                print(status)
                if status! > 200 && status! < 299{
                    return completion (true)
                }
                else{
                    return completion(false)
                }
        }
        
        RunLoop.main.run()
    }
    
}

