//
//  ViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 7/23/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {
    var ref: DatabaseReference!

    @IBAction func loginButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LoginPage")
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var enterNumberTextField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {

        //alert: login first
        let alert = UIAlertController(title: "Login First", message: "Please Login First", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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

    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

