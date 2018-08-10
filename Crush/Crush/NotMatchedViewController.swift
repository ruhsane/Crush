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

class NotMatchedViewController: UIViewController {

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
        sendText { (completed) in
            
            if completed == true{
                let ref = Database.database().reference()
                
                //add crush number under user uid
                let user = Auth.auth().currentUser
                guard let number = self.phoneNumber else { return}
                print(number)
                ref.child("Users").child((user?.uid)!).child("CrushNumber").setValue(number)
                
                ref.child("Loved").child(number).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
            }
        }
    }
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let number = phoneNumber else { return}
        let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("Matched")
        let currentUserRef = Database.database().reference().child("Users").child(user!.uid)
        let currentUserSnap = currentUserRef.observe(.value) { (snapshot) in
            let currentUser = snapshot.value as! [String: String]

            
            self.askToSendLabel.text = "Do you want to send anonymous text message to the number you entered?(" +  currentUser["CrushNumber"]! + ")"

        // Do any additional setup after loading the view.
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendText(completion: @escaping(Bool)->()) {
        guard let number = phoneNumber else { return}
        print(number)

        let accountSID = "ACc89f0f2bdefcc860202e3dce683e8855"
        let authToken = "42a5ab35149266391e7649e0c7927c74"

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"

        let parameters = ["From": "9032943794", "To": number, "Body": "Someone labeled you as his/her crush on 'Crush' app. Download the app to see."] as [String : Any]

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

        RunLoop.main.run()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
