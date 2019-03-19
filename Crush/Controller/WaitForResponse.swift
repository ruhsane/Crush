//
//  WaitForResponse.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/26/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView

class WaitForResponse: UIViewController {
    var phoneNumber: String?

    @IBAction func changeCrushBtn(_ sender: Any) {
        changeCrushAlert()
    }
    
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
    
    func changeCrushAlert() {
        // Create the subview
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("I am sure") {
            print("take back to main screen")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewController(withIdentifier: "mainVC")
            self.present(main, animated: true)
        }
        
        alert.showInfo("Are you sure you want to change?", subTitle: "We will update your crush number in our database and you will no longer receive further notification on the current crush status", closeButtonTitle: "Cancel",  colorStyle: 0x34C4F6)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        guard let number = self.phoneNumber else { return}
        print(number)


        ref.child("Matched").childByAutoId().observe(.value) { (snapshot) in

            if snapshot.hasChild((user?.phoneNumber)!){

                print("matched")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let Matched = storyboard.instantiateViewController(withIdentifier: "Matched")
                self.present(Matched,animated: true)

        }else{

                return
            }
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
