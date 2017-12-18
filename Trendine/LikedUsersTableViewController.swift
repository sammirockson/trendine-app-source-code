//
//  LikedUsersTableViewController.swift
//  Trendin
//
//  Created by Rockson on 07/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class LikedUsersTableViewController: UITableViewController {
    
    var postId: String?
    var likers = [String]()
    
    private let resuseIdentifier = "resuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Likes"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(LikedUsersTableViewCell.self, forCellReuseIdentifier: resuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadLikers()

    }
    
    
    
    func loadLikers(){
        
        if let Id = self.postId{
            
            let query = BmobQuery(className: "Trends")
            query?.order(byDescending: "createdAt")
            query?.whereKey("objectId", equalTo: Id)
            query?.limit = 1
            query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
            query?.getObjectInBackground(withId: Id, block: { (object, error) in
                if error == nil {
                    self.likers.removeAll(keepingCapacity: true)
                    
                    if let likersArray = object?.object(forKey: "likersArray") as? [String]{
                        
                        self.navigationItem.title = "\(likersArray.count) likes"

                        
                        for liker in likersArray {
                            
                            self.likers.append(liker)
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                        }
                        
                        
                    }
                    
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
            })
          
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.likers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! LikedUsersTableViewCell

        let objectId = self.likers[indexPath.row]
        
        let query = BmobQuery(className: "_User")
        query?.limit = 1
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.getObjectInBackground(withId: objectId, block: { (object, error) in
            if error == nil {
             
                DispatchQueue.main.async {
                    
                    cell.usernameLabel.text = (object as! BmobUser).username
                    
                    if let profileImageFile = object?.object(forKey: "profileImageFile") as? BmobFile {
                        
                    cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                        
                        
                    }
                }
                
                
            }else{
                
                print(error?.localizedDescription as Any)
            }
        })

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = self.likers[indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
        myMomentsVC.incomingUser = selectedUser
        self.navigationController?.pushViewController(myMomentsVC, animated: true)
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
