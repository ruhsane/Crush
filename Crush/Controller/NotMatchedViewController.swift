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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
