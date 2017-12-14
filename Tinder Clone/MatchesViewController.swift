//
//  MatchesViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/14/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController {
    @IBOutlet weak var imgView_match: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let lookingFor = PFUser.current()?["lookingFor"]
        if let userLooingFor = lookingFor
        {
            let userLookingFor = userLooingFor as! String
            if userLookingFor == "Woman"
            {
                let query = PFQuery(className: "_User")
                query.whereKey("gender", equalTo: "Woman")
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if objects != nil
                    {
                        for women in objects!
                        {
                            print(women)
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
                let query = PFQuery(className: "_User")
                query.whereKey("gender", equalTo: "Man")
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if objects != nil
                    {
                        for men in objects!
                        {
                            print(men)
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

    @IBAction func btnLogoutPressed(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            
            if error != nil
            {
                let error = error! as NSError
                let alert = UIAlertController(title: "Error", message: error.userInfo["error"] as? String, preferredStyle: .alert)
                alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
}
