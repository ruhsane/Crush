//
//  NotMatchedViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 8/8/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import SCLAlertView

class NotMatchedViewController: UIViewController {
    var phoneNumber: String?

    @IBOutlet weak var askToSendLabel: UILabel!
    
    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
            
            self.present(loginVC,animated: true)
        }
        catch{
            
        }
    }
    
    @IBAction func sendToEnteredCrush(_ sender: Any) {
        let number = self.phoneNumber ?? ""
//        sendText(number: number!) { (completed) in
//            // if text sent successfully
//            if completed == true{
//                let ref = Database.database().reference()
//                let user = Auth.auth().currentUser
//                // add receiver under loved
//                ref.child("Loved").child(number!).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
//            }
//        }
        
        AlamofireRequest().twillioSendText(to: number, body: "Someone labeled you as his/her crush on 'Crush' app. Download the app to see.", completion: { (completion) in
            if completion == true{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let WaitForResponse = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
                self.present(WaitForResponse,animated: true)
                
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser
                // add receiver under loved
                ref.child("Loved").child(number).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
                
            } else {
                let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func sendToDiffNum(_ sender: Any) {
        popUpView()
    }
    
    func popUpView() {
        let alert = SCLAlertView()
        let txt = alert.addTextField("Enter your crush's number")
        print(txt)
        
        alert.addButton("Send Anonymous Text") {
            
//            self.sendText(number: txt.text!) { (completed) in
//                // if text sent sucessfully
//                let number = txt.text
//                if completed == true{
//                    let ref = Database.database().reference()
//                    let user = Auth.auth().currentUser
//                    // add receiver under loved
//                    ref.child("Loved").child(number!).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
//                }
//            }
            AlamofireRequest().twillioSendText(to: txt.text ?? "", body: "Someone labeled you as his/her crush on 'Crush' app. Download the app to see.", completion: { (completion) in
                if completion == true{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let WaitForResponse = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
                    self.present(WaitForResponse,animated: true)

                    let ref = Database.database().reference()
                    let user = Auth.auth().currentUser
                    let number = txt.text ?? ""

                    // add receiver under loved
                    ref.child("Loved").child(number).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
                    
                } else {
                    let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        alert.showEdit("", subTitle: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        let currentUserRef = Database.database().reference().child("Users").child(user!.uid)
        currentUserRef.observe(.value) { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            self.phoneNumber = currentUser["CrushNumber"]!
            self.askToSendLabel.text = "Do you want to send anonymous text message to the number you entered?(" +  currentUser["CrushNumber"]! + ")"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
//    
//    func sendText(number: String, completion: @escaping(Bool)->()) {
//
//        let accountSID = "ACc89f0f2bdefcc860202e3dce683e8855"
//        let authToken = "42a5ab35149266391e7649e0c7927c74"
//
//        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
//
//        let parameters = ["From": "9032943794", "To": number, "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."] as [String : Any]
//
//       Alamofire.request(url, method: .post, parameters: parameters)
//            .authenticate(user: accountSID, password: authToken)
//            .responseJSON { response in
//                let status = response.response?.statusCode
//                print(status)
//                if status! > 200 && status! < 299{
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let WaitForResponse = storyboard.instantiateViewController(withIdentifier: "WaitForResponse")
//                    self.present(WaitForResponse,animated: true)
//                    return completion (true)
//
//                }
//                else{
//                    let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                    return completion(false)
//                }
//            
//        } 
//
//        RunLoop.main.run()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
