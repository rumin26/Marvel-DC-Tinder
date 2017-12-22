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
    var displayedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imgView_match.isUserInteractionEnabled = true
        
        imgView_match.addGestureRecognizer(gesture)
    
        self.changeMatch()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        let imgView = gestureRecognizer.view!
        
        imgView.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = imgView.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        imgView.transform = rotation
        
        var swipe = ""
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            if imgView.center.x < 100 {
                
                swipe = "rejectedUsers"
            
                
            } else if imgView.center.x > self.view.bounds.width - 100 {
                
                swipe = "acceptedUsers"
        
            }
            
            PFUser.current()?.addUniqueObject(displayedUserId, forKey: swipe)
            PFUser.current()?.saveInBackground(block: { (success, error) in
                
                if success
                {
                    let query = PFQuery(className: "_User")
                    query.whereKey("acceptedUsers", contains: PFUser.current()?.objectId)
                    query.whereKey("objectId", equalTo: self.displayedUserId)
                    query.findObjectsInBackground(block: { (object, error) in
                    
                        if object != nil
                        {
                            if (object?.count)! > 0
                            {
                                for user in object!
                                {
                                    let string = "You matched with " + (user.object(forKey: "username") as! String) + "!"
                                    PFUser.current()?.addUniqueObject(self.displayedUserId, forKey: "matchedUsers")
                                    PFUser.current()?.saveInBackground(block: { (success, error) in
                                        
                                        if success
                                        {
                                            let query = PFQuery(className: "_User")
                                            query.whereKey("objectId", equalTo: self.displayedUserId)
                                            query.findObjectsInBackground(block: { (object, error) in
                                                
                                                if object != nil
                                                {
                                                    for user in object!
                                                    {
//                                                        user.addUniqueObject((PFUser.current()?.objectId!)!, forKey: "matchedUsers")
//                                                        user.saveInBackground(block: { (success, error) in
//                                                            
//                                                            if success
//                                                            {
                                                                let alert = UIAlertController(title: "It's a Match!!", message: string, preferredStyle: .alert)
                                                                alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                                                                    
                                                                        
                                                                        self.changeMatch()
                                                                        
                                                                   
                                                                    
                                                                }))
                                                                self.present(alert, animated: true, completion: nil)
//                                                            }
//                                                            
//                                                        })
                                                    }
                                                    
                                                }
                                                
                                            })
                                            
                                            
                                        }
                                    })
                                    
                                }
                            }
                            else
                            {
                                self.changeMatch()
                            }
                            
                        }
                        
                        
                    })
                    
                }
            })
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            imgView.transform = rotation
            imgView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }

    

    func changeMatch()
    {
        let lookingFor = PFUser.current()?["lookingFor"]
        if let userLooingFor = lookingFor
        {
            let userLookingFor = userLooingFor as! String
            if userLookingFor == "Woman"
            {
                var arr_swipedUsers = [""]
                
                if let arr_acceptedUsers = PFUser.current()?["acceptedUsers"]
                {
                    arr_swipedUsers += arr_acceptedUsers as! Array
                }
                
                if let arr_rejectedUsers = PFUser.current()?["rejectedUsers"]
                {
                    arr_swipedUsers += arr_rejectedUsers as! Array
                }
                
                
                let query = PFQuery(className: "_User")
                query.whereKey("gender", equalTo: "Woman")
                query.whereKey("objectId", notContainedIn: arr_swipedUsers)
                
                query.findObjectsInBackground(block: { (objects, error) in
                query.limit = 1
                    
                    
                    
                    if objects != nil
                    {
                        if objects?.count == 0
                        {
                            
                            let alert = UIAlertController(title: "All Users Swiped!!", message: "Come back again later!!", preferredStyle: .alert)
                            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        for women in objects!
                        {
                            let image = women.object(forKey: "userImage") as! PFFile
                            self.displayedUserId = women.objectId!
                            
                            image.getDataInBackground(block: { (data, error) in
                                
                                if data != nil
                                {
                                    self.imgView_match.image = UIImage(data: data!)
                                }
                            })
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
                var arr_swipedUsers = [""]
                
                if let arr_acceptedUsers = PFUser.current()?["acceptedUsers"]
                {
                    arr_swipedUsers += arr_acceptedUsers as! Array
                }
                
                if let arr_rejectedUsers = PFUser.current()?["rejectedUsers"]
                {
                    arr_swipedUsers += arr_rejectedUsers as! Array
                }
                
                
                let query = PFQuery(className: "_User")
                query.whereKey("gender", equalTo: "Man")
                query.whereKey("objectId", notContainedIn: arr_swipedUsers)
                
                query.findObjectsInBackground(block: { (objects, error) in
                query.limit = 1
                    
                    if objects != nil
                    {
                        if objects?.count == 0
                        {
                            
                            let alert = UIAlertController(title: "All Users Swiped!!", message: "Come back again later!!", preferredStyle: .alert)
                            alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        for men in objects!
                        {
                            let image = men.object(forKey: "userImage") as! PFFile
                            self.displayedUserId = men.objectId!
                            
                            image.getDataInBackground(block: { (data, error) in
                                
                                if data != nil
                                {
                                    self.imgView_match.image = UIImage(data: data!)
                                }
                            })
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
