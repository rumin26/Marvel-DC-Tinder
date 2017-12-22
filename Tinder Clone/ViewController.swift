//
//  ViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/12/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var txtfield_username: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (PFUser.current() != nil)
        {
            self.performSegue(withIdentifier: "showMatchAfterLogin", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginBtnPressed(_ sender: Any) {
    
        if txtfield_username.text != "" || txtfield_password.text != ""
        {
            PFUser.logInWithUsername(inBackground: txtfield_username.text!, password: txtfield_password.text!) { (user, error) in
            
                if error != nil
                {
                    let userError = error! as NSError
                    
                    let alert = UIAlertController(title: "Error", message: userError.userInfo["error"] as? String, preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.performSegue(withIdentifier: "showMatchAfterLogin", sender: nil)
                }
            
            }
        }
        
    }
}

