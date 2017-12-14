//
//  UserDetailsViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/12/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse
class UserDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imgView_user: UIImageView!
    @IBOutlet weak var switch_gender: UISwitch!
    @IBOutlet weak var switch_lookingfor: UISwitch!

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

    @IBAction func chooseUserImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
    
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
        }
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage]
        imgView_user.image = image as? UIImage
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    @IBAction func updateProfilePressed(_ sender: Any) {
        var gender = ""
        var lookingfor = ""
        if switch_gender.isOn
        {
            gender = "Woman"
        }
        else
        {
            gender = "Man"
        }
        
        if switch_lookingfor.isOn
        {
            lookingfor = "Woman"
        }
        else
        {
            lookingfor = "Man"
        }
        
        
        let user = PFUser.current()!
        user["gender"] = gender
        user["lookingFor"] = lookingfor
        
        let imageData = UIImagePNGRepresentation(imgView_user.image!)
        let file = PFFile(name: "userImage.jpg", data: imageData!)
        
        user["userImage"] = file
        
        
        user.saveInBackground { (success, error) in
            
            if success
            {
                self.performSegue(withIdentifier: "showMatchAfterSignUp", sender: nil)
            }
            
            else
            {
                let error = error! as NSError
                let alert = UIAlertController(title: "Error", message: error.userInfo["error"] as? String, preferredStyle: .alert)
                alert.addAction(.init(title: "Okay", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert, animated: true, completion: nil)

            }
            
        }
    
        
    }
}
