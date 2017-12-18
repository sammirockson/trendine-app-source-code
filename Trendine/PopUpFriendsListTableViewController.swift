//
//  PopUpFriendsListTableViewController.swift
//  Trendin
//
//  Created by Rockson on 20/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class PopUpFriendsListTableViewController: UITableViewController, UISearchResultsUpdating{
    private let reuseIdentifier = "reuseIdentifier"
    
    var friends = [Contacts]()
    
    var searchController = UISearchController()
    var resultsTableViewController = UITableViewController()
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.sortDescriptors =  [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(PopUpFriendsListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.register(PopUpFriendsListTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.dataSource = self
        self.resultsTableViewController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        
        let lefttBarItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.leftBarButtonItem = lefttBarItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.loadFriendsFromCoreData()
        
    }
    
    
    func handleLeftBarButton(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadFriendsFromCoreData(){
        
        do {
            
            try self.fetchedResultsControler.performFetch()
            
            if let fetchedContacts = self.fetchedResultsControler.fetchedObjects as? [Contacts] {
                
                if fetchedContacts.count > 0 {
                    
                    self.friends.removeAll(keepingCapacity: true)
                    
                    for contact in fetchedContacts {
                        
                        self.friends.append(contact)
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                    
                    
                }
                
            }
            
            
            
        }catch {
            
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let query = BmobQuery(className: "_User")
        query?.whereKey("username", equalTo: searchController.searchBar.text)
        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
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
        return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopUpFriendsListTableViewCell

        let userInfo = self.friends[indexPath.row]
        
        let query = BmobQuery(className: "_User")
        query?.whereKey("objectId", equalTo: userInfo.objectId)
        query?.limit = 1
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.findObjectsInBackground({ (users, error) in
            if error == nil {
                if (users?.count)! > 0 {
                    
                    for user in users! {
                        
                        if let newUser = user as? BmobUser {
                            
                            DispatchQueue.main.async {
                                
                                cell.usernameLabel.text = newUser.username
                                
                                if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
                                    
                                    cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
            }else{
                
                
                print(error?.localizedDescription as Any)
            }
        })
  
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = self.friends[indexPath.row]
        
        self.dismiss(animated: true, completion: {
        
            let userToBeBlocked = BmobObject(outDataWithClassName: "_User", objectId: selectedUser.objectId)
            let relation = BmobRelation()
            let currentUser = BmobUser.current()
            
            relation.remove(userToBeBlocked)
            currentUser?.add(relation, forKey: "friends")
            currentUser?.updateInBackground(resultBlock: { (success, error) in
                if success{
                    
                    print("successfully removed")
                    
                    let blockRelation = BmobRelation()
                    blockRelation.add(userToBeBlocked)
                    currentUser?.add(blockRelation, forKey: "blockedLists")
                    currentUser?.updateInBackground(resultBlock: { (success, error) in
                        if success{
                            
                            print("blocklist updated")
                            
                            self.queryChatRoom(userId: selectedUser.objectId!)
                            
                            
                        }else{
                            
                            print(error?.localizedDescription as Any)
                            
                        }
                    })
                    
                    
                }else{
                    
                    
                    print(error?.localizedDescription as Any)
                }
            })
            
        
        
        })
        
        
        
    }
    
    let currentUser = BmobUser.current()
    
    func queryChatRoom(userId: String){
        
        
        let query1 = BmobQuery(className: "Room")
        let array1 = [["user1Id": self.currentUser?.objectId] ,["user2Id": userId]]
        query1?.addTheConstraintByAndOperation(with: array1)
        query1?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if results?.count == 0 {
                    //no room yet
                    
                    self.secondQuery(userId: userId)
                    self.finallyDeleteFoundRoom(roomObject: nil, userId: userId)

                    
                }else if (results?.count)! > 0 {
                    
                    for result in results!{
                        
                        self.finallyDeleteFoundRoom(roomObject: result as! BmobObject, userId: userId)
                        
                    }
                    
                }
                
            }else{
                
                print(error?.localizedDescription as Any)
            }
        })
        
        
        
    }
    
    
    func secondQuery(userId: String){
        
        let query = BmobQuery(className: "Room")
        let array2 = [["user1Id": userId],  ["user2Id": self.currentUser?.objectId]] as [Any]
        query?.addTheConstraintByAndOperation(with: array2)
        query?.findObjectsInBackground({ (secondResults, error) in
            if error == nil {
                
                if (secondResults?.count)! > 0 {
                    
                    
                    for secondResult in secondResults!{
                        
                        self.finallyDeleteFoundRoom(roomObject: secondResult as! BmobObject, userId: userId)
                        
                        
                        
                    }
                    
                }
                
                
            }else{
                
                
                self.finallyDeleteFoundRoom(roomObject: nil, userId: userId)

                print(error?.localizedDescription as Any)
                
            }
        })
        
        
    }
    
    func finallyDeleteFoundRoom(roomObject: BmobObject?, userId: String){
        
        self.deleteNotifications(roomId: roomObject?.objectId)
        if roomObject != nil {
            roomObject?.deleteInBackground({ (success, error) in
                if success{
                    
                    print("room deleted")
                    
                    
                    let AppDel = UIApplication.shared.delegate as! AppDelegate
                    let moc = AppDel.persistentContainer.viewContext
                    
                    let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                    request.predicate = NSPredicate(format: "objectId == %@", userId)
                    
                    do {
                        let searchResults = try moc.fetch(request)
                        
                        if searchResults.count > 0  {
                            
                            for result in searchResults {
                                
                                moc.delete(result)
                                
                                do {
                                    
                                    try moc.save()
                                    print("user deleted from CoreData as well")
                                    
                                }catch{
                                    
                                    print(error)
                                }
                                
                            }
                            
                        }
                        
                    } catch {
                        print("Error with request: \(error)")
                    }
                    
                    
                    
                    
                    
                    
                    
                }else{
                    
                    
                    print("Error deleting room \(error?.localizedDescription as Any)")
                }
            })
            
            
        }else{
            
            
            let AppDel = UIApplication.shared.delegate as! AppDelegate
            let moc = AppDel.persistentContainer.viewContext
            
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            request.predicate = NSPredicate(format: "objectId == %@", userId)
            
            do {
                let searchResults = try moc.fetch(request)
                
                if searchResults.count > 0  {
                    
                    for result in searchResults {
                        
                        moc.delete(result)
                        
                        do {
                            
                            try moc.save()
                            print("user deleted from CoreData as well")
                            
                        }catch{
                            
                            print(error)
                        }
                        
                    }
                    
                }
                
            } catch {
                print("Error with request: \(error)")
            }
            
            
            
            
            
        }
        
    }

 
    
    func deleteNotifications(roomId: String?){
        
        
        if roomId != "" {
            
            let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
            let array = [["roomId": roomId]]
            unreadMessageQuery?.addTheConstraintByAndOperation(with: array)
            unreadMessageQuery?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    if (results?.count)! > 0 {
                        
                        for result in results! {
                            
                            let object = result as! BmobObject
                            object.deleteInBackground({ (success, error) in
                                if success{
                                    
                                    print("unread messages deleted")
                                }
                            })
                        }
                        
                    }
                    
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
            })
            
            
            
        }
      
        
    }

}
