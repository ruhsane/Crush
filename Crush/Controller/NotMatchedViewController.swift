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
import CountryPickerView

class NotMatchedViewController: UIViewController, CountryPickerViewDelegate {
    var phoneNumber: String?
    var code = "+1"

    @IBOutlet weak var askToSendLabel: UILabel!
    
    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
        catch{
            
        }
    }
    
    @IBAction func sendToEnteredCrush(_ sender: Any) {
        self.showSpinner(onView: self.view)

        let number = self.phoneNumber ?? ""
        sendText(num: number)
    }
    
    @IBAction func sendToDiffNum(_ sender: Any) {
        popUpView()
    }
    
    func popUpView() {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        cpv.delegate = self
        cpv.showCountryCodeInView = false
        
        txt.leftView = cpv
        txt.leftViewMode = .always
        
        alert.addButton("Send Anonymous Text") {
            self.showSpinner(onView: self.view)
            let num = txt.text ?? ""
            let fullNum = self.code + num.readOnlyNumber
            print(fullNum)
            // if the number is already in follower, go to matched, else sendtext
            self.matchOrNo(num: fullNum, completion: { (matched) in
                if matched == false {
                    self.sendText(num: fullNum)
                }
            })
        }
        
        alert.showEdit("", subTitle: "Enter your crush's number")
    }
    
    func sendText(num: String) {
        
        self.twillioSendText(to: num, body: "Someone labeled you as his/her crush on 'Crush' app. 😯😍 Download the app to see. http://www.appstore.com/crushsendanonymoussignal", completion: { (completion) in
            
            self.removeSpinner()
            
            if completion == true{

                presentVC(sbName: "Main", identifier: "WaitForResponse", fromVC: self)
                
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser
                //change status to wait
                ref.child("Users").child((user?.phoneNumber)!).child("Status").setValue("Wait")

                // update/write crush number for user
                ref.child("Users").child((user?.phoneNumber)!).child("CrushNumber").setValue(num)
                
                // add receiver under loved
                ref.child("Loved").child(num).child("Followers").updateChildValues([(user?.phoneNumber)! : true])
                
            } else {
                let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        let currentUserRef = Database.database().reference().child("Users").child(user!.phoneNumber!)
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUser = snapshot.value as! [String: String]
            self.phoneNumber = currentUser["CrushNumber"]!
            self.askToSendLabel.text = "Do you want to send anonymous text message to the number you entered?(" +  currentUser["CrushNumber"]! + ")"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 

    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.code = country.phoneCode
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
