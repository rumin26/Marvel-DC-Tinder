//
//  SignUpViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/12/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtfield_username: UITextField!
    @IBOutlet weak var txtfield_email: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
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
    @IBAction func signupBtnPressed(_ sender: Any) {
    
        if txtfield_email.text != "" || txtfield_username.text != "" || txtfield_password.text != ""
        {
            let user = PFUser()
            user.email = txtfield_email.text
            user.username = txtfield_username.text
            user.password = txtfield_password.text
            let acl = PFACL()
            acl.getPublicWriteAccess = true
            acl.getPublicReadAccess = true
            user.acl = acl
            
            user.signUpInBackground(block: { (success, error) in
                
                if success{
                    
                    PFUser.logInWithUsername(inBackground: self.txtfield_username.text!, password: self.txtfield_password.text!) { (user, error) in
                        
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
                            self.performSegue(withIdentifier: "showUserdetails", sender: nil)
                        }
                        
                    }
                    
                    
                }
                else
                {
                    let userError = error! as NSError
                    
                    let alert = UIAlertController(title: "Error", message: userError.userInfo["error"] as? String, preferredStyle: .alert)
                    alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            })
        }
        
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter your details !!", preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
