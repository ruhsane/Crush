//
//  Log in Page.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/27/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth
import CountryPickerView


class LoginPage: UIViewController, CountryPickerViewDelegate {

    var code = "+1"
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.code = country.phoneCode
    }
    
    @IBOutlet weak var enterPhoneNumber: UITextField!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        cpv.delegate = self
        enterPhoneNumber.leftView = cpv
        enterPhoneNumber.leftViewMode = .always

    }
    
    @IBAction func confirmButton(_ sender: Any) {
        let num = self.code + self.enterPhoneNumber.text!
        let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(num)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            // check if phone number is proper and do stuff with it?
            self.showSpinner(onView: self.view)

            PhoneAuthProvider.provider().verifyPhoneNumber(num, uiDelegate: nil) { (verificationID, error) in
                self.removeSpinner()
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                    let alert = UIAlertController(title: "Send Text Error", message: "Please check if your entered number is correct", preferredStyle: .alert)
                    let ok = UIKit.UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)

                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "authVID")
                    self.performSegue(withIdentifier: "code", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
