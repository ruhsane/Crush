//
//  MatchedViewController.swift
//  Crush
//
//  Created by Ruhsane Sawut on 8/9/18.
//  Copyright © 2018 Ruhsane Sawut. All rights reserved.
//

import UIKit
import FirebaseAuth

class MatchedViewController: UIViewController {

    @IBAction func SignOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            dismiss(animated: true, completion: nil)
        }
        catch{
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
