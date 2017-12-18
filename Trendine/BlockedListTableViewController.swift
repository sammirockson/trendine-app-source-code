//
//  BlockedListTableViewController.swift
//  Trendin
//
//  Created by Rockson on 20/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


var chosenUserToBeBlocked: Contacts?

class BlockedListTableViewController: UITableViewController, UISearchResultsUpdating {
    private let reuseIdentifier = "reuseIdentifier"
    
    var searchController = UISearchController()
    var resultsTableViewController = UITableViewController()
    
    var blockedLists = [BmobUser]()
    var filteredUsers = [BmobUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Block List"

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleRightBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        tableView.register(BlockedListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.register(BlockedListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.dataSource = self
        self.resultsTableViewController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadBlockedUsers()

    }
    
 
    
    func handleRightBarButton(){
       
        let friendsLists = PopUpFriendsListTableViewController()
        let navVC = UINavigationController(rootViewController: friendsLists)
        self.present(navVC, animated: true, completion: nil)
        
        
    }
    
    func loadBlockedUsers(){
        
       let currentUser = BmobUser.current()
        
        let queryUser = BmobUser.query()
        queryUser?.whereObjectKey("blockedLists", relatedTo: currentUser)
        queryUser?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                    
                    self.blockedLists.removeAll(keepingCapacity: true)
                    
                    for result in results! {
                        
                       self.blockedLists.append(result as! BmobUser)
                        
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let query = BmobQuery(className: "_User")
        query?.whereKey("username", equalTo: searchController.searchBar.text)
        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                
                    for result in results! {
                        
                        if let obj = result as? BmobObject {
                            
                            self.filteredUsers.append(obj as! BmobUser)
                        }
                        
                    }
                 
                    DispatchQueue.main.async {
                        
                      self.resultsTableViewController.tableView.reloadData()
                    }
                    
                }
                
            }
        })
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tableView == resultsTableViewController.tableView {
            
           return filteredUsers.count
            
        }else{
        
            return self.blockedLists.count

        
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BlockedListTableViewCell

        
        if tableView == resultsTableViewController.tableView {
            
            let fileteredArray = self.filteredUsers[indexPath.row]
            
            
            if let profileImageFile = fileteredArray.object(forKey: "profileImageFile") as? BmobFile {
                
                cell.usernameLabel.text = fileteredArray.username
                
                cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            }

            
        }else{
            
            let blockedUser = self.blockedLists[indexPath.row]
            
            
            if let profileImageFile = blockedUser.object(forKey: "profileImageFile") as? BmobFile {
                
                cell.usernameLabel.text = blockedUser.username
                
                cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            }
            
        }
        
        
        

        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    var userToBeDeleted: BmobObject?
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            let selectedUser = self.blockedLists[indexPath.row]
            userToBeDeleted = selectedUser
            
            self.blockedLists.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            if let user = self.userToBeDeleted {
                
                
                self.deleteChatRoom(user: user)
            }
            
            
            
        }
        
    }
    
    
    
    
    func deleteChatRoom(user: BmobObject){
        
        let relation = BmobRelation()
        let currentUser = BmobUser.current()
        
        relation.remove(user)
        currentUser?.add(relation, forKey: "blockedLists")
        currentUser?.updateInBackground(resultBlock: { (success, error) in
            if success{
                
                print("successfully removed")
                
                
                
            }else{
                
                
                print(error?.localizedDescription as Any)
            }
        })
        
        ///
        
      
    }

    

}
