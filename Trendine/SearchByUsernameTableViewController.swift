//
//  SearchByUsernameTableViewController.swift
//  Trendin
//
//  Created by Rockson on 15/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class SearchByUsernameTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    var filteredUsers = [BmobUser]()

    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        bView.isHidden = false
        return bView
        
    }()
    

    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
    }()
    
    let displayText: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textAlignment = .center
        return lb
        
    }()

    
    let reuseIdentifier = "reuseIdentifier"
    var searchBy: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        displayActivityInProgressView()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            blurView.addSubview(activityIndicator)
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            blurView.isHidden = true
        }
        
     self.navigationItem.title = "Search for friends"
        
    resultsController.tableView.dataSource = self
    resultsController.tableView.delegate = self

    self.searchController = UISearchController(searchResultsController: self.resultsController)
    self.tableView.tableHeaderView = self.searchController.searchBar
//    self.searchController.searchResultsUpdater = self
    self.searchController.searchBar.delegate = self
    definesPresentationContext = true
        
        if let searchTitle = searchBy {
            
            self.searchController.searchBar.placeholder = searchTitle
        }

    
     tableView.register(SearchByUsernameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
     self.resultsController.tableView.register(SearchByUsernameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
//    func displayActivityInProgressView(){
//        
//        
//        if let motherView = UIApplication.shared.keyWindow {
//            
//            motherView.addSubview(backgroundBlurView)
//            
//            
//            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
//            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
//            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
//            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
//            
//            backgroundBlurView.addSubview(blurView)
//            
//            blurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
//            blurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
//            blurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//            blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            
//            blurView.addSubview(activityIndicator)
//            blurView.addSubview(displayText)
//            
//            displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
//            displayText.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
//            displayText.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
//            displayText.heightAnchor.constraint(equalToConstant: 20).isActive = true
//            
//            activityIndicator.startAnimating()
//            
//            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
//            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
//            activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
//            activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
//            
//            self.backgroundBlurView.isHidden = true
//            
//        }
//        
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.blurView.isHidden = false


    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    self.blurView.isHidden = false
    self.activityIndicator.startAnimating()

        
        self.filteredUsers.removeAll(keepingCapacity: true)
        
        let query = BmobQuery(className: "_User")
        query?.whereKey(self.searchBy, equalTo: searchController.searchBar.text)
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
            self.blurView.isHidden = true
                

                
                if (results?.count)! > 0 {
                    
                    for result in results!{
                        
                        if let user = result as? BmobUser {
                            
                            if user.objectId != "2e897823de" && user.objectId != "712b4069b8" {
                                
                                if let findByPhoneNumber = user.object(forKey: "FindByPhone") as? Bool {
                                    
                                    if findByPhoneNumber == true {
                                        
                                        self.filteredUsers.append(user)
                                        
                                    }
                                    
                                }
                                
                              
                                
                            }
                            
                        }
                        
                      
                       
                    }
                    
                    
                    
                DispatchQueue.main.async {
                        
                self.resultsController.tableView.reloadData()
                        
                }
                    
                }else if results?.count == 0 {
                    
                    
                // No user found
                    
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "", message: "No user found!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
                
            }else{
                
                self.blurView.isHidden = true

                
            }
        })
        
    }
    

    
    func handleAddFriend(sender: UIButton){
        
        
        let point = sender.convert(sender.bounds.origin, to: self.resultsController.tableView)
        if let indexPath = self.resultsController.tableView.indexPathForRow(at: point){
            
            self.blurView.isHidden = false
            self.activityIndicator.startAnimating()
        

            
            let selectedItem = self.filteredUsers[indexPath.row]
            
            
            let relation = BmobRelation()
            let currentUser = BmobUser.current()
            
            relation.add(selectedItem)
            currentUser?.add(relation, forKey: "friends")
            currentUser?.updateInBackground(resultBlock: { (success, error) in
                if error == nil {
                    
                    print("added")
                    
                    let installationQuery = BmobInstallation.query()
                    installationQuery?.whereKey("userId", equalTo: selectedItem.objectId)
                    
                    if let name = currentUser?.username {
                        
                        let push = BmobPush()
                        push.setQuery(installationQuery)
                        push.setMessage("\(name) added you as a friend!")
                        push.sendInBackground({ (success, error) in
                            if error == nil {
                                
                                print("push has been sent")
                                
                                
                            }else{
                                
                                
                                print(error?.localizedDescription as Any)
                                
                            }
                        })
                        
                    }
                    
                    
                    self.prepareToSaveRoom(selectedItem: selectedItem, sender: sender)
                    
                    
                }else {
                    
                    
                    self.blurView.isHidden = true
                    self.activityIndicator.stopAnimating()


                    
                    print(error?.localizedDescription as Any)
                }
            })
            
            
        }
        
        
    }
    
    func savedContactToCoreData(friend: BmobUser , room: BmobObject, sender: UIButton){
        let AppDel = UIApplication.shared.delegate as! AppDelegate
        let moc = AppDel.persistentContainer.viewContext
        
        // Query coreData first if the user doesn't exists already
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", friend.objectId)
        
        do {
            let searchResults = try moc.fetch(request)
            
            if searchResults.count == 0  {
                
                if let newRoom = room.object(forKey: "newRoom") as? Bool {
                    
                    if newRoom == false  {
                        
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                    
                        
                        entity.createdAt = NSDate()
                        entity.objectId = friend.objectId
                        entity.updatedAt = friend.updatedAt as NSDate?
                        entity.lastUpdate = NSDate()
                        entity.newOrOld = true
                        entity.roomId = room.objectId
                        entity.username = friend.username
                        if let phoneNumber = friend.object(forKey: "phoneNumber") as? String {
                            
                            entity.phoneNumber = phoneNumber
                            
                            
                        }
                        
                        if let profileImageFile = friend.object(forKey: "profileImageFile") as? BmobFile {
                            
                            let url = NSURL(string: profileImageFile.url)
                            if let profileImageData = NSData(contentsOf: url as! URL){
                                
                                entity.profileImageData = profileImageData
                                
                            }
                        }
                        
                        
                        do {
                            
                            try moc.save()
                            
                            sender.setTitle("Added", for: .normal)
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            
                            
                            
                            print("contact saved successfully")
                            
                            let notify = BmobObject(className: "NotificationCenter")
                            notify?.setObject(friend, forKey: "userToBeNotified")
                            notify?.setObject("Added you", forKey: "notificationReason")
                            notify?.setObject(friend.objectId, forKey: "postId")
                            notify?.setObject(false, forKey: "notified")
                            notify?.setObject(BmobUser.current(), forKey: "responder")
                            notify?.setObject(false, forKey: "userLikedIt")
                            notify?.setObject(true, forKey: "addRequest")
                            notify?.setObject(false, forKey: "addPoints")
                            notify?.setObject(false, forKey: "pointsAccepted")
                            notify?.setObject(false, forKey: "requestAccepted")
                            notify?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("notified!!!")
                                }
                            })
                            
                        }catch {
                            
                            self.blurView.isHidden = true
                            
                            print(error.localizedDescription)
                        }
                        
                        
                    }else if newRoom == true {
                        
                        let entity2 = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
               
                        entity2.createdAt = NSDate()
                        entity2.objectId = friend.objectId
                        entity2.updatedAt = friend.updatedAt as NSDate?
                        entity2.lastUpdate = NSDate()
                        entity2.newOrOld = false
                        entity2.roomId = room.objectId
                        entity2.username = friend.username
                        if let phoneNumber = friend.object(forKey: "phoneNumber") as? String {
                            
                            entity2.phoneNumber = phoneNumber
                            
                            
                        }
                        
                        if let profileImageFile = friend.object(forKey: "profileImageFile") as? BmobFile {
                            
                            let url = NSURL(string: profileImageFile.url)
                            if let profileImageData = NSData(contentsOf: url as! URL){
                                
                                entity2.profileImageData = profileImageData
                                
                            }
                        }
                        
                        
                        do {
                            
                            try moc.save()
                            
                            sender.setTitle("Added", for: .normal)
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()

                            
                            print("contact saved successfully")
                            
                            let notify = BmobObject(className: "NotificationCenter")
                            notify?.setObject(friend, forKey: "userToBeNotified")
                            notify?.setObject("Added you", forKey: "notificationReason")
                            notify?.setObject(friend.objectId, forKey: "postId")
                            notify?.setObject(false, forKey: "notified")
                            notify?.setObject(BmobUser.current(), forKey: "responder")
                            notify?.setObject(false, forKey: "userLikedIt")
                            notify?.setObject(true, forKey: "addRequest")
                            notify?.setObject(false, forKey: "addPoints")
                            notify?.setObject(false, forKey: "pointsAccepted")
                            notify?.setObject(false, forKey: "requestAccepted")
                            notify?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("notified!!!")
                                }
                            })
                            
                            
                        }catch {
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                }
                
               
                
            }else{
                
                self.blurView.isHidden = true


            }
            
        } catch {
            
            self.blurView.isHidden = true

            
            print("Error with request: \(error)")
        }
        
        
    }
    
    let currentUser = BmobUser.current()

    func saveToRoom(selectedItem: BmobUser, sender: UIButton){
        
        
        let room = BmobObject(className: "Room")
        room?.setObject(selectedItem, forKey: "user1")
        room?.setObject(BmobUser.current(), forKey: "user2")
        room?.setObject(selectedItem.objectId, forKey: "user1Id")
        room?.setObject(BmobUser.current().objectId, forKey: "user2Id")
        room?.setObject(true, forKey: "newRoom")
        room?.saveInBackground(resultBlock: { (success, error) in
            if error == nil {
                
                print("room saved...")
                
                
                let backendMessage = BmobObject(className: "Messages")
                backendMessage?.setObject(self.currentUser, forKey: "sender")
                backendMessage?.setObject("Nice to meet you...", forKey: "textMessage")
                backendMessage?.setObject(room?.objectId, forKey: "roomId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "uniqueId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                backendMessage?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        
                        let unreadMessage = BmobObject(className: "UnreadMesssages")
                        unreadMessage?.setObject(selectedItem.objectId, forKey: "incomingUserId")
                        unreadMessage?.setObject(room?.objectId, forKey: "roomId")
                        unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                            if success{
                                
                                print("unread message sent successfully")
                                
                            }else{
                                
                                print(error?.localizedDescription as Any)
                            }
                        })
                        
                    }
                })
                
                self.savedContactToCoreData(friend: selectedItem, room: room!, sender: sender)
                
            }else{
                
                self.blurView.isHidden = true
                self.activityIndicator.stopAnimating()

//                self.backgroundBlurView.isHidden = true

            }
        })
        
        
        
    }
    
    
    func prepareToSaveRoom(selectedItem: BmobUser, sender: UIButton){
        let currentUser = BmobUser.current()
        
        let query1 = BmobQuery(className: "Room")
        let array1 = [["user1Id": currentUser?.objectId] ,["user2Id": selectedItem.objectId]]
        query1?.addTheConstraintByAndOperation(with: array1)
        query1?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query1?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if results?.count == 0 {
                    //no room yet
                    
                    let query = BmobQuery(className: "Room")
                    let array2 = [["user1Id": selectedItem.objectId],  ["user2Id": currentUser?.objectId]]
                    query?.addTheConstraintByAndOperation(with: array2)
                    query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                    query?.findObjectsInBackground({ (secondResults, error) in
                        if error == nil {
                            
                            if secondResults?.count == 0 {
                                
                                self.saveToRoom(selectedItem: selectedItem, sender: sender)
                                
                                
                            }else if secondResults?.count == 1 {
                                
                                self.savedContactToCoreData(friend: selectedItem, room: secondResults?.first as! BmobObject, sender: sender)
                                
                                
                            }
                            
                            
                        }else{
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()

                            print(error?.localizedDescription as Any)
                            
                        }
                    })
                    
                    
                    
                }else if results?.count == 1{
                    
                    //there's room
                    
        
                    
                    
                    self.savedContactToCoreData(friend: selectedItem, room: results?.first as! BmobObject, sender: sender)
                    
                    
                }
                
            }else{
               
                self.blurView.isHidden = true
                self.activityIndicator.stopAnimating()

            }
        })
        
    }

    

    override func viewWillDisappear(_ animated: Bool) {
        self.resultsController.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.resultsController.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filteredUsers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchByUsernameTableViewCell
        
        cell.addButton.addTarget(self, action: #selector(handleAddFriend), for: .touchUpInside)
        
      let user = self.filteredUsers[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
        if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
            
            cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
        }
        

        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", user.objectId)
        
        do {
            let searchResults = try self.moc.fetch(request)
            
            if searchResults.count == 0 {
                
               cell.addButton.isHidden = false
                
            }else{
                
                cell.addButton.isHidden = true

                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    
    

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.filteredUsers[indexPath.row]
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", user.objectId)
        request.fetchLimit = 1
        
        do {
            let searchResults = try self.moc.fetch(request)
            
            if searchResults.count != 0 {
                
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 4
                let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
                messagesVC.hidesBottomBarWhenPushed = true
                messagesVC.incomingUser = searchResults.first
                messagesVC.navigationItem.title = user.username
                self.navigationController?.pushViewController(messagesVC, animated: true)
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        
        
    }
 

}
