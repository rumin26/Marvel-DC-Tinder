//
//  MatchesTableViewController.swift
//  Tinder Clone
//
//  Created by Rumin on 12/15/17.
//  Copyright © 2017 Rumin. All rights reserved.
//

import UIKit
import Parse
class MatchesTableViewController: UITableViewController {

    @IBOutlet var tbl_matches: UITableView!
    
    var arr_acceptedUsers = [] as Array
    var arr_userImages = [PFFile]()
    var arr_userNames = [] as Array
    var arr_userIds = [] as Array
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView = UITableView(frame:CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        self.tbl_matches.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        if let array = PFUser.current()?["matchedUsers"]
        {
            let matchedUsers = array as! NSArray
            
            for matchUser in matchedUsers
            {
                let query = PFQuery(className: "_User")
                query.whereKey("objectId", equalTo: matchUser)
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if objects != nil
                    {
                        for match in objects!
                        {
                            self.arr_acceptedUsers.append(match)
                            self.arr_userNames.append(match.object(forKey: "username")!)
                            self.arr_userIds.append(match.objectId!)
                            self.arr_userImages.append(match.object(forKey: "userImage") as! PFFile)
                        }
                    }
                    
                })
                
            }
        }
        
        let query = PFQuery(className: "_User")
        query.whereKey("matchedUsers", contains: (PFUser.current()?.objectId!)!)
        query.findObjectsInBackground { (objects, error) in
            
            if objects != nil
            {
                if (objects?.count)! > 0
                {
                    for match in objects!
                    {
                        let objectId = match.objectId
                        let query = PFQuery(className: "_User")
                        query.whereKey("objectId", equalTo: objectId!)
                        
                        query.findObjectsInBackground(block: { (objects, error) in
                            
                            if objects != nil
                            {
                                for acceptedUser in objects!
                                {
                                    
                                    self.arr_acceptedUsers.append(acceptedUser)
                                    self.arr_userNames.append(acceptedUser.object(forKey: "username")!)
                                    self.arr_userIds.append(acceptedUser.objectId!)
                                    self.arr_userImages.append(acceptedUser.object(forKey: "userImage") as! PFFile)
                                    
                                    
                                }
                                self.tbl_matches.reloadData()
                            }

                        })
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "No Matches Yet", message: "Come back when you match with someone", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr_acceptedUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MatchesTableViewCell

        cell.lbl_username.text = arr_userNames[indexPath.row] as? String
        
        arr_userImages[indexPath.row].getDataInBackground(block: { (data, error) in
            
            if data != nil
            {
                cell.imgview_User.image = UIImage(data: data!)
            }
            
        })
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set((arr_userIds[indexPath.row] as! String), forKey: "selectedUser")
        self.performSegue(withIdentifier: "openChat", sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
