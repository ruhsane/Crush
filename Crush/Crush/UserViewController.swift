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
import CountryPickerView

class UserViewController: UIViewController, CountryPickerViewDelegate {

    var ref: DatabaseReference?
    var code = "+1"
    var crushes = [String]()

    
    @IBOutlet weak var countLabel: UILabel!

    
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
    
    @IBOutlet weak var enterNumberTextField: UITextField!
    
    @IBAction func checkButton(_ sender: Any) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let num = self.code + self.enterNumberTextField.text!
       
        let alert = UIAlertController(title: "Phone number", message: "Is this your crush's phone number? \n \(num)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default){ (UIAlertAction) in
            ref.child("Users").child((user?.uid)!).child("CrushNumber").setValue(num)

            ref.child("Loved").observe(.value) { (snapshot) in
                if snapshot.hasChild((user?.phoneNumber)!){
                    ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observe(.value) { (snapshot) in
                        
                        if snapshot.hasChild(num){
                            
                            print("matched")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let Matched = storyboard.instantiateViewController(withIdentifier: "Matched")
                            self.present(Matched,animated: true)
                            let couple = ref.child("Matched").childByAutoId()
                            couple.updateChildValues(["A" : user?.phoneNumber])
                            couple.updateChildValues(["B" : num])
                            
                            ref.child("Loved").child(num).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
                            

                        }else{
                            
                            print("not matched")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let notMatched = storyboard.instantiateViewController(withIdentifier: "notMatched") as! NotMatchedViewController
                            notMatched.phoneNumber = num
                            self.present(notMatched,animated: true)
                        }
                    }
                    
                }else{
                    
                    print("no one labeled you as their crush.")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let notMatched = storyboard.instantiateViewController(withIdentifier: "notMatched") as! NotMatchedViewController
                    notMatched.phoneNumber = num
                    self.present(notMatched,animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        sendText { (completed) in
            
            if completed == true{
                let ref = Database.database().reference()
                
                //add crush number under user uid
                let user = Auth.auth().currentUser
                let num = self.code + self.enterNumberTextField.text!
                ref.child("Users").child((user?.uid)!).child("CrushNumber").setValue(num)

            ref.child("Loved").child(num).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
            }
        }
    }
    
    func showKeyboard() {
        self.enterNumberTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("Loved").observe(.value) { (snapshot) in
            if snapshot.hasChild((user?.phoneNumber)!){
                ref.child("Loved").child((user?.phoneNumber)!).child("Followers").observe(.value, with: { (snapshot: DataSnapshot!) in
                    
                    print("Got snapshot");
                    print(snapshot.childrenCount)
                    let crushCount = snapshot.childrenCount
                    self.countLabel.text = String(crushCount) + " users have labeled you as their crush."
                })
            } else {
                self.countLabel.text = "0 users have labeled you as their crush."
            }
        }
        
        // if users/uid/ exists "crushNumber" {
        //       if matched/ exists user phone number {
        //              take to matched page
        //            } else {
        //              if loved/.. has user phone number {
        //                     take to wait for response page
        //              } else {
        //                      take to check page
        //          }
        //      } else {
        //  
            
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        cpv.delegate = self
        enterNumberTextField.leftView = cpv
        enterNumberTextField.leftViewMode = .always

    
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
//        let int = Int(enterNumberTextField.text!)!
//        let str = String(int)
        if let str = enterNumberTextField.text{
    //    let code = Country.phoneCode
            let num = self.code + str
        
            let parameters = ["From": "9032943794", "To": num, "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    let status = response.response?.statusCode
                    print(status)
                    if status! > 200 && status! < 299{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let WaitForResponse = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
                        self.present(WaitForResponse,animated: true)
                        return completion (true)
                        
                    }
                    else{
                        let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        return completion(false)

                    }
            }
        }        else { print("emty")}

        RunLoop.main.run()
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
         self.code = country.code
    }
}

