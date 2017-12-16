//
//  ChatViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/15/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var txtView_message: UITextView!
    @IBOutlet weak var tbl_chat: UITableView!
    var arr_senderImages = [PFFile]()
    var arr_receiverImages = [PFFile]()
    var arr_usernames = [] as Array
    var arr_messages = [] as Array
    var arr_userImages = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotifications()
        
        self.txtView_message.delegate = self
        self.txtView_message.clipsToBounds = true
        self.txtView_message.layer.cornerRadius = 5.0
        self.txtView_message.autoresizingMask = .flexibleWidth
        
        txtView_message.keyboardAppearance = .alert
        
        tbl_chat.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        receiveChats()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableViewCell

        if arr_messages.count > 0
        {
            
            cell.lbl_message.text = self.arr_messages[indexPath.row] as? String
        
        arr_senderImages[indexPath.row].getDataInBackground { (data, error) in
            
            if data != nil
            {
                cell.imgView_user.image = UIImage(data: data!)
            }
            
        }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 107
        
    }

    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLogoutPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnSendPressed(_ sender: Any) {
        
        let selectedUser = UserDefaults.standard.object(forKey: "selectedUser")
        //let data = UIImagePNGRepresentation(UIImage(named: "person.png")!)
        //var receiverImage:PFFile = PFFile(data: data!)!
        
        let object = PFObject(className: "Chat")
        object["sender"] = PFUser.current()?.objectId
        object["receiver"] = selectedUser
        object["chattingUsers"] = (PFUser.current()?.objectId)! + (selectedUser as! String)
        object["message"] = self.txtView_message.text
        object["senderImage"] = PFUser.current()?["userImage"]
        //object["receiverImage"] = receiverImage
        
        object.saveInBackground { (success, error) in
            
            if success
            {
                self.txtView_message.text = "";
                self.txtView_message.resignFirstResponder()
                self.receiveChats()
            }
            
        }
        
        
    }
    
    func receiveChats()
    {
        let selectedUser = UserDefaults.standard.object(forKey: "selectedUser")
        let query = PFQuery(className:"Chat" )
        query.whereKey("chattingUsers", contains: selectedUser as? String)
        
        
        query.findObjectsInBackground { (objects, error) in
            
            self.arr_messages.removeAll()
            self.arr_senderImages.removeAll()
            self.arr_receiverImages.removeAll()
            
            if objects != nil
            {
                for chats in objects!
                {
                    self.arr_messages.append(chats["message"])
                    if let userImage = chats["senderImage"]
                    {
                        self.arr_senderImages.append(userImage as! PFFile)
                    }
                    
                }
                self.tbl_chat.reloadData()
                let lastRowNumber = self.tbl_chat.numberOfRows(inSection: 0) - 1
                
                let ip = IndexPath(row: lastRowNumber, section: 0)
                self.tbl_chat.scrollToRow(at: ip, at: .top, animated: true)
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.hasSuffix("\n")
        {
            CATransaction.setCompletionBlock({ 
                
                self.scrollToCaretInTextView(textView: textView, animated: false)
                
            })
        }
        else
        {
            self.scrollToCaretInTextView(textView: textView, animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
   
    func scrollToCaretInTextView(textView:UITextView, animated:Bool)   {
        
        var rect = textView.caretRect(for: (textView.selectedTextRange?.end)!) as CGRect
        rect.size.height += textView.textContainerInset.bottom
        textView.scrollRectToVisible(rect, animated: true)
    }
   

    func registerForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
    
        
        let info = notification.userInfo! as NSDictionary
        
        
        let duration = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let curve = info.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        let frame = info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as! CGRect
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))! )
        UIView.setAnimationDuration(TimeInterval(duration))
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
    
        
        let lastRowNumber = tbl_chat.numberOfRows(inSection: 0) - 1
        
        let ip = IndexPath(row: lastRowNumber, section: 0)
        tbl_chat.scrollToRow(at: ip, at: .top, animated: true)
        
        UIView.commitAnimations()
        

    }
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo! as NSDictionary
        
        
        let duration = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let curve = info.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        let frame = info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as! CGRect
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))! )
        UIView.setAnimationDuration(TimeInterval(duration))
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        UIView.commitAnimations()

    }
}
