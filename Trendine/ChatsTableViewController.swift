//
//  ChatsTableViewController.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class ChatsTableViewController: UITableViewController,  UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    let reuseIdentifier = "cell"
    
    var users = [Contacts]()
    var filteredUsers = [Contacts]()
    
    lazy var  searchController:  UISearchController = {
        let controller = UISearchController()
        controller.searchBar.delegate = self
        return  controller
        
    }()
    var resultsTableViewController = UITableViewController()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        bView.isHidden = false
        return bView
        
    }()
    
    let backgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bView.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    let blockBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        bView.isHidden = true
        return bView
        
    }()
    
    let blockActivityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
    }()
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    var beginToRefreshChat = false
    
//    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
//        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
//        request.predicate = NSPredicate(format: "newOrOld == %@", NSNumber(booleanLiteral: true))
//        request.sortDescriptors =  [NSSortDescriptor(key: "lastUpdate", ascending: false)]
//        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
////        fetchResults.delegate  = self
//        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
//    }()
//
//    var blockOperations = [BlockOperation]()
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        if type == .insert {
//            
//         blockOperations.append(BlockOperation(block: { 
//            
//            self.tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.bottom)
//            
//         }))
//            
//        }
//    }
//    
//    
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    
//        for operation in self.blockOperations{
//            
//            operation.start()
//            
//        }
//        
//        
//    }
//    
    
    
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange), name: NSNotification.Name(ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
 
        self.displayActivityInProgressView()
        
        navigationItem.title = "Chats"
        
        tableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.resultsTableViewController.tableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        self.resultsTableViewController.tableView.dataSource = self
        self.resultsTableViewController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar


    }

    
    func reachabilityDidChange(notification: Notification){
        
        
        guard let r = reachability else { return }
        if r.isReachable  {
         
        } else {
            
            
            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
            
        }
        
    }
////
    
    func alert(reason: String){
        
        let alert = UIAlertController(title: "No Internet!!", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkReachability() {
        
        guard let r = reachability else { return }
        if r.isReachable  {
//            view.backgroundColor = UIColor.green
            
            
            //network...
        } else {
            
            
            self.alert(reason: "No internet connection detected or you're probably on a very slow network")

            //no network
//            view.backgroundColor = UIColor.red
        }
    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
//        reachability?.stopNotifier()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let counts = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int {
            
            if counts > 0 {
                
                self.tabBarItem.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                self.tabBarItem.badgeValue = "\(counts)"
                
            }else{
                
                self.tabBarItem.badgeValue = nil
                
                
            }
            
            
            
        }else{
            
            self.tabBarItem.badgeValue = nil
            
            
        }
        
//        fetchAndSaveNotifications()
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadAfterNotifications(){
        
        if allContactsArray.count > 0 {
            
            for contact in allContactsArray{
                
                if let roomId = contact.roomId, let objectId = contact.objectId{
                    
                    
                    self.loadMessagesFromBackend(roomId: roomId, objectId: objectId)
                    
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        self.checkReachability()

         NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterNotifications), name: NSNotification.Name("reloadMessages"), object: nil)
        
        self.view.addSubview(blockBlurView)
        
        blockBlurView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        blockBlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        blockBlurView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        blockBlurView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        blockBlurView.addSubview(blockActivityIndicator)
        
        blockActivityIndicator.centerYAnchor.constraint(equalTo: blockBlurView.centerYAnchor).isActive = true
        blockActivityIndicator.centerXAnchor.constraint(equalTo: blockBlurView.centerXAnchor).isActive = true
        blockActivityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        blockActivityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
         self.loadNotificationFromBackend()
        allContactsArray.removeAll(keepingCapacity: true)
        
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "newOrOld == %@", NSNumber(booleanLiteral: true))
        fetch.sortDescriptors =  [NSSortDescriptor(key: "lastUpdate", ascending: false)]
        
        do {
            
            let foundContacts = try moc.fetch(fetch)
            
            if foundContacts.count > 0 {
                
                self.users.removeAll(keepingCapacity: true)
                
                for contact in foundContacts {
                    
                    allContactsArray.append(contact)
                  
                    self.users.append(contact)
                    
                    
                }
                
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                }
                
                
                self.searchBackendInBackground()
                
            }else{
                
                self.loadUsersFromBackend()
                
                
            }
            
            
            
        }catch{}
        
      


        if users.count > 0 {
            
            for contact in users {
                
                
                if let roomId = contact.roomId, let objectId = contact.objectId{
                    
//                    self.loadMessagesFromBackend(roomId: roomId, objectId: objectId)
                    
                    
                    
                }
                
            }
       
            
        }
        
        

        
    }
    
   

 
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
   

    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        
        self.filteredUsers = users.filter({ (contact) -> Bool in
            
            if ((contact as AnyObject).username??.lowercased().contains((searchText?.lowercased())!))! {
                
              return true
                
            }else{
                
                return false
            }
            
        }) 
        
        
        self.resultsTableViewController.tableView.reloadData()

        

    }
    

//    
    
    func queryCoreDataIfUserExists(user: BmobUser){
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "objectId == %@", user.objectId)
        fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            
            let results = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
            
            if results.count > 0 {
                
                for result in results {
                    
                    self.filteredUsers.append(result)
                    
                }
                
                
                DispatchQueue.main.async {
                    
                    self.resultsTableViewController.tableView.reloadData()
                }
                
            }
 
        }catch{
            
         print(error.localizedDescription)
        }
    }
    
    func searchBackendInBackground(){
        
        let currentUser = BmobUser.current()
        
        
        let query = BmobQuery(className: "Room")
        query?.includeKey("user1,user2")
        let array1 = [["user1Id": currentUser?.objectId], ["user2Id": currentUser?.objectId]]
        query?.addTheConstraintByOrOperation(with: array1)
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                                        
                    for result in results!{
                        
                        if let newResult = result as? BmobObject{
                            
                            if let user1 = newResult.object(forKey: "user1") as? BmobUser{
                                
                                if user1.objectId != currentUser?.objectId && user1.objectId != "712b4069b8" && user1.objectId != "2e897823de"{
                                    
                                    if let room = result as? BmobObject {
                                        
                                        print("user1 detected")
                                        self.CheckCoreDataInBackground(friend: user1, room: room)
                                            
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                            }
                            
                            if let user2 = newResult.object(forKey: "user2") as? BmobUser{
                                
                                if user2.objectId != currentUser?.objectId && user2.objectId != "712b4069b8" && user2.objectId != "2e897823de"{
                                    
                                    print("user2 detected")

                                    
                                    if let room2 = result as? BmobObject {
                                        
                                        
                                    self.CheckCoreDataInBackground(friend: user2, room: room2)
                                            
                                            
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                    
                        
                    }
                    
                    
                }
            }
        })
  
        
        
    }
    
    
    func CheckCoreDataInBackground(friend: BmobUser , room: BmobObject){
        
        // Query coreData first if the user doesn't exists already
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", friend.objectId)
        
        do {
            let searchResults = try moc.fetch(request)
            
            if searchResults.count == 0  {
                print("core data checkeed.... user doen't exists")
                // save the new user if the user doesn't exis
                self.PrepareForeSavingInBackground(user: friend, room: room)
                
                
            }else{
                
                print("error.... user doees exists already")

            }
            
        } catch {
            //            loadingObjectsView.isHidden = true
            print("Error with request: \(error)")
            
        }
        
        
    }
    
    func PrepareForeSavingInBackground(user: BmobUser, room: BmobObject){
        
        print("we here...")
            if let newRoom = room.object(forKey: "newRoom") as? Bool {
                
                if newRoom == false  {
                    
                    let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                    
                    entity.createdAt = NSDate()
                    entity.objectId = user.objectId
                    entity.updatedAt = user.updatedAt as NSDate
                    entity.newOrOld = true
                    entity.roomId = room.objectId
                    entity.username = user.username
                    entity.lastUpdate = NSDate()
                    
                    if let phoneNumber = user.object(forKey: "phoneNumber") as? String {
                        
                        entity.phoneNumber = phoneNumber
                        
                        
                    }
                    
                    if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                        
                        let url = NSURL(string: profileImageFile.url)
                        if let profileImageData = NSData(contentsOf: url as! URL){
                            
                            entity.profileImageData = profileImageData
                            
                        }
                    }
                    
                    do {
                        
                        try moc.save()
                        
                        print("contact saved successfully")
//                        self.updateTableViewInBackground(friend: user)
                        
                        
                    }catch {}
                    
                    
                }else if newRoom == true {
                    
                    let entity2 = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                    
                    entity2.createdAt = NSDate()
                    entity2.lastUpdate = NSDate()
                    entity2.objectId = user.objectId
                    entity2.updatedAt = user.updatedAt as NSDate
                    entity2.newOrOld = false
                    entity2.roomId = room.objectId
                    entity2.username = user.username
                    
                    if let phoneNumber = user.object(forKey: "phoneNumber") as? String {
                        
                        entity2.phoneNumber = phoneNumber
                        
                        
                    }
                    
                    
                    if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                        
                        let url = NSURL(string: profileImageFile.url)
                        if let profileImageData = NSData(contentsOf: url as! URL){
                            
                            entity2.profileImageData = profileImageData
                            
                        }
                    }
                    
                    do {
                        
                        try moc.save()
                        
                        print("contact saved successfully")
//                        self.updateTableViewInBackground(friend: user)
                        
                    }catch {
                        
                        
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }
            
        
        
    }
    
    

    
    func displayActivityInProgressView(){
        
        
        if let motherView = self.view {
            
            motherView.addSubview(backgroundBlurView)
            
            
            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            backgroundBlurView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            blurView.addSubview(activityIndicator)
            blurView.addSubview(displayText)
            
            displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
            displayText.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
            displayText.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
            displayText.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            activityIndicator.startAnimating()
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            displayText.text = "Loading..."
            self.backgroundBlurView.isHidden = true
            
        }
        
        
    }
    
    func loadNotificationFromBackend(){
//        print("notified being called...")
        
        let currentUser = BmobUser.current()
        
        let query = BmobQuery(className: "NotificationCenter")
        query?.order(byDescending: "createdAt")
        query?.whereKey("userToBeNotified", equalTo: currentUser)
        let array = [["notified": false]]
        query?.addTheConstraintByAndOperation(with: array)
        query?.findObjectsInBackground({ (results, error) in
            
            if error == nil {
                
                if (results?.count)! > 0 {
                    
                    DispatchQueue.main.async {
                        
                        let customNotification  = self.tabBarController
                        for item in  (customNotification?.tabBar.items!)! {
                            
                            if let title = item.title {
                                
                                if title == "Notifications" {
                                    
                                    print(title)
                                    if let count = results?.count {
                                        
                                        item.badgeValue = "\(count)"
                                        item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }else{
                
                print(error?.localizedDescription as Any)
                
            }
        })
        
    }
    
     func loadUsersFromBackend(){
        
        self.backgroundBlurView.isHidden = false
        let currentUser = BmobUser.current()
        
        
        let query = BmobQuery(className: "Room")
        query?.includeKey("user1,user2")
        let array1 = [["user1Id": currentUser?.objectId], ["user2Id": currentUser?.objectId]]
        query?.addTheConstraintByOrOperation(with: array1)
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {

                
                if (results?.count)! > 0 {
                    
                    
                    for result in results!{
                        
                        if let newResult = result as? BmobObject{
                        
                            if let user1 = newResult.object(forKey: "user1") as? BmobUser{
                            
                            if user1.objectId != currentUser?.objectId && user1.objectId != "2e897823de" && user1.objectId != "712b4069b8"{
                                            
                                    if let room = result as? BmobObject {
                                                
                                     self.savedContactToCoreData(friend: user1, room: room)
                                                
                                                
                                  }
                                            
                                }
                                  
                                
                                
                            }
                            
                           
                            
                            
                            if let user2 = newResult.object(forKey: "user2") as? BmobUser{
                                
                                if user2.objectId != currentUser?.objectId && user2.objectId != "712b4069b8" && user2.objectId != "2e897823de"{
                                    
                                    
                                    
                                    if let room2 = result as? BmobObject {
                                        
                                        self.savedContactToCoreData(friend: user2, room: room2)

                                        
                                        
                                        
                                        
                                    }
                                
                                }
                                
                            }
                        
                         
                        
                        }

                    }
                    
                    ////////
                    
                    
                    DispatchQueue.main.async{
                    self.backgroundBlurView.isHidden = true

                    self.tableView.reloadData()
                        
                    }
                    
                    
                }else{
                    
                    
                    self.backgroundBlurView.isHidden = true

                    //No rooms
                    

                    
                }
            }else{
                
                
                self.backgroundBlurView.isHidden = true

            }
        })
    }

    
    func savedContactToCoreData(friend: BmobUser , room: BmobObject){
        
        // Query coreData first if the user doesn't exists already

        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", friend.objectId)
        
        do {
            let searchResults = try moc.fetch(request) 
            
            if searchResults.count == 0  {
                
                // save the new user if the user doesn't exis
            self.prepareForTableViewUpdate(user: friend, room: room)
                
                
            }else{
                
                self.backgroundBlurView.isHidden = true

            }
            
        } catch {
//            loadingObjectsView.isHidden = true
            print("Error with request: \(error)")
            
            self.backgroundBlurView.isHidden = true

        }
        
        
    }
    
    func prepareForTableViewUpdate(user: BmobUser, room: BmobObject){
        
    let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts

        
        if let newRoom = room.object(forKey: "newRoom") as? Bool {
            
            if newRoom == false  {
                
                
                entity.createdAt = NSDate()
                entity.lastUpdate = NSDate()
                entity.objectId = user.objectId
                entity.updatedAt = user.updatedAt as NSDate
                entity.newOrOld = true
                entity.roomId = room.objectId
                entity.username = user.username
                
                if let phoneNumber = user.object(forKey: "phoneNumber") as? String {
                    
                    entity.phoneNumber = phoneNumber
                    
                    
                }
                
                if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                    
                    if let url = NSURL(string: profileImageFile.url) {
                        
                        if let profileImageData = NSData(contentsOf: url as URL){
                            
                        entity.profileImageData = profileImageData
                            
                        }
                        
                    }
                  
                }
                
                do {
                    
                    try moc.save()
            
                    
                }catch{}
                
                
            }else if newRoom == true{
                
                
                entity.createdAt = NSDate()
                entity.objectId = user.objectId
                entity.updatedAt = user.updatedAt as NSDate
                entity.lastUpdate = NSDate()
                entity.newOrOld = false
                entity.roomId = room.objectId
                entity.username = user.username
                
                if let phoneNumber = user.object(forKey: "phoneNumber") as? String {
                    
                    entity.phoneNumber = phoneNumber
                    
                    
                }
                
                if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                    
                    if let url = NSURL(string: profileImageFile.url){
                        
                        if let profileImageData = NSData(contentsOf: url as URL){
                            
                            entity.profileImageData = profileImageData
                            
                        }
                        
                    }

                   
                }
                
                do {
                    
                    try moc.save()
                    
                    
                }catch{}
                
                
            }
        }
        
        
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.resultsTableViewController.tableView {
            
            return self.filteredUsers.count
            
        }else{
        
         
        return self.users.count
            
   
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatsTableViewCell

        if tableView == self.resultsTableViewController.tableView {
            
           let userInf = self.filteredUsers[indexPath.row]
            
            if let username = userInf.username {
                
                cell.usernameLabel.text = username
            }
            
            if let profileImageData = userInf.profileImageData {
                
                let image = UIImage(data: profileImageData as Data)
                cell.profileImageView.image = image
                
            }
            
            if let roomId = userInf.roomId {
                
                self.fetchLastMessage(roomId: roomId, cell: cell, objectId: userInf.objectId!)
            }

            
        }else{
        

               let contact = users[indexPath.row]

                let numberOfNotifications = contact.numberOfNotifications
                
                let intNotification = Int(numberOfNotifications)
                
                if intNotification > 0 {
                    
                    cell.unreadMessageView.isHidden = false
                    cell.unreadMessageLabel.isHidden = false
                    
                    if intNotification >= 99 {
                        
                        cell.unreadMessageLabel.text = "99+"
                        
                    }else{
                        
                        
                        cell.unreadMessageLabel.text = "\(intNotification)"
                        
                    }
                    
                    
                    
                }else{
                    
                    cell.unreadMessageView.isHidden = true
                    cell.unreadMessageLabel.isHidden = true
                    
                }
                
            
            
            if let username = contact.username {
                
                cell.usernameLabel.text = username
            }
            
            if let profileImageData = contact.profileImageData {
                
                let image = UIImage(data: profileImageData as Data)
                cell.profileImageView.image = image
                
            }
    
            self.updateUserInfoInCoreData(userInfo: contact)
        
            if let roomId = contact.roomId {
                
//                self.fetchLastMessage(roomId: roomId, cell: cell, objectId: contact.objectId!)
            }
            
        

            
        }
        
     
        

        return cell
    }
 
    
    
    func updateUserInfoInCoreData(userInfo: Contacts){
        
        let query = BmobUser.query()
        query?.whereKey("objectId", equalTo: userInfo.objectId)
        query?.limit = 1
        query?.findObjectsInBackground({ (users, error) in
            if error == nil {
                if (users?.count)! > 0 {
                    
                    for user in users! {
                        
                        if let newUser = user as? BmobUser {
                            
                            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                            fetch.predicate = NSPredicate(format: "objectId == %@", userInfo.objectId!)
                            fetch.fetchLimit = 1
                            
                            do {
                                
                                let searchResults = try self.moc.fetch(fetch) as [Contacts]
                                if searchResults.count > 0 {
                                 
                                    if let foundContact = searchResults.first {
                                        
                                        let dateForm = DateFormatter()
                                        dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                        
                                        let updatedAt = dateForm.string(from: newUser.updatedAt)
                                        let lastUpdate = dateForm.string(from: foundContact.updatedAt as! Date)
                                        
                                        if updatedAt != lastUpdate {
                                            
                                            
                                            
                                            if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
                                                
                                                let url = NSURL(string: profileImageFile.url)
                                                if let profileImageData = NSData(contentsOf: url as! URL){
                                                    
                                                    foundContact.profileImageData = profileImageData
                                                    foundContact.username = newUser.username
                                                    foundContact.updatedAt = newUser.updatedAt as NSDate?
                                                    
                                                    do {
                                                        
                                                        try self.moc.save()
                                                        
                                                    }catch{}
                                                    
                                                    
                                                }
                                            }
                                            
                                            
                                            
                                        }else{}
                                        
                                        
                                    }
                                    
                                    
                                }

                            }catch{}
                          
                        }
                            
                        }
                        
                    }
                    
                    
            }else{}
                
        })
 
        
        
        
    }
    
    func deleteMessageAfterReceive(object: BmobObject){
        
        object.deleteInBackground { (success, error) in
            if success {
                
             print("message deleted")
                
                
            }else{}
        }
        
        
    }

    
    var objectsToBeReversed = [BmobObject]()
    var totalCount = 0

    func loadMessagesFromBackend(roomId: String, objectId: String){
        
        totalCount = 0
        
        
        let query = BmobQuery(className: "Messages")
        query?.limit = 100
        query?.order(byDescending: "createdAt")
        query?.includeKey("sender")
        let array  = [["roomId": roomId], ["receiverId": BmobUser.current().objectId]] as [Any]
        query?.addTheConstraintByAndOperation(with: array)
        query?.findObjectsInBackground { (results, error) in
            if error == nil {


                self.objectsToBeReversed.removeAll(keepingCapacity: true)
                
                
                if (results?.count)! > 0 {
                    
                    self.totalCount = results!.count
                    
                    self.objectsToBeReversed = results as! [BmobObject]
                    let returnedObjects =  self.objectsToBeReversed.reversed()
                    
                    for result in returnedObjects {
                        
                        let object = result as BmobObject
//                        let uniqueId = object.object(forKey: "uniqueId") as? String
                        
//                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
//                        request.fetchLimit = 100
//                        request.predicate = NSPredicate(format: "objectId == %@", uniqueId!)
//                        
//                        do {
//                            let searchResults = try self.moc.fetch(request)
//                            
//                            if searchResults.count == 0 {
//                                //check if message already exists or not
                        
                            self.processAndSaveReceivedObjectFromBackend(object: object, objectId: objectId)
                                
                            self.deleteMessageAfterReceive(object: object)
                                
                                ////////////////
                                
//                            }
                        
                            
//                        }catch {}
                        
                        
                    }
                    
              
                
                }
                
                
                
            }else{
                
                
//                self.deleReadMessages(roomId: roomId)
                
            }
        }
        
        
    }
    
  
    func processAndSaveReceivedObjectFromBackend(object: BmobObject, objectId: String){
        
        if UserDefaults.standard.object(forKey: "numberOfNotifications") == nil {
            
            UserDefaults.standard.setValue(1 , forKeyPath: "numberOfNotifications")
            
            if let savedNotification = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                
                self.tabBarItem.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                self.tabBarItem.badgeValue = "\(savedNotification)"
                
                
            }
            
            
        }else{
            
            
            if let numberOfNotifi = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                
                let newNumberOfNotifcations = numberOfNotifi + 1
                UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
                UserDefaults.standard.setValue(newNumberOfNotifcations, forKeyPath: "numberOfNotifications")
                
                if let savedNotification = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                    
                    self.tabBarItem.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                    self.tabBarItem.badgeValue = "\(savedNotification)"
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "objectId == %@", objectId)
        fetch.fetchLimit = 1
        
        
        do {
            
            let foundContacts = try self.moc.fetch(fetch)
            if let contact = foundContacts.first {
                
                contact.lastUpdate = NSDate()
                contact.newOrOld = NSNumber(booleanLiteral: true) as Bool
                
                let originalNumber = Int(contact.numberOfNotifications)
                contact.numberOfNotifications = Int32(originalNumber + 1)
                
                do {
                    
                    try self.moc.save()
                    
                }catch{}
                
                
                
            }
            
        }catch{}
        
        
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        

        
        
        if let uniqueId = object.object(forKey: "uniqueId") as? String {
            
            entity.objectId = uniqueId
            
        }
        
        if let sender = object.object(forKey: "sender") as? BmobUser {
            
            entity.senderId = sender.objectId
            entity.senderName = sender.username
  
            
        }
        
        
        if let roomId = object.object(forKey: "roomId") as? String {
            
            entity.roomId = roomId
            
            
        }
        
        
        if let nameCardId = object.object(forKey: "nameCardId") as? String {
            
            entity.nameCardId = nameCardId
            
            
        }
        
        
        if let textMessage = object.object(forKey: "textMessage") as? String {
            
            entity.textMessage = textMessage
            
            
            
        }
        
        
        if let imageFile = object.object(forKey: "imageMessage") as? BmobFile {
            
            let imageHeight = object.object(forKey: "imageHeight") as? Float
            let imageWidth = object.object(forKey: "imageWidth") as? Float
           
            entity.imageHeight = imageHeight!
            entity.imageWidth = imageWidth!
            entity.imageMessageURL = imageFile.url
            
   
            
        }
        
        if let audioFile = object.object(forKey: "audioMessage") as? BmobFile {
            
            let audioDuration = object.object(forKey: "audioDuration") as? Int
            let audioData = NSData(contentsOf: NSURL(string: (audioFile.url)!) as! URL)
            
            entity.audioMessage = audioData
            entity.audioDuration = Float(audioDuration!)
        
            
        }
        
        
        if let stickerFile = object.object(forKey: "stickerFile") as? BmobFile {
            
            if let width = object.object(forKey: "stickerWidth") as? Float {
                
                entity.stickerWidth = width
                
                
            }
            
            if let height = object.object(forKey: "stickerHeight") as? Float {
                
                entity.stickerHeight = height
                
            }
            
            if let stickerData = NSData(contentsOf: NSURL(string: stickerFile.url) as! URL){
                
                entity.stickerData = stickerData
     
                
            }
            
        }
        
        
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.lastUpdate =  NSDate()
        entity.createdAt = NSDate()
        
        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
//            DispatchQueue.main.async {
//                
//                self.tableView.reloadData()
//                
//            }
            
            
            
        }catch {}
        
    }

    
    
    
    
    
    func deleReadMessages(roomId: String){
        
        let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
        let array = [["roomId": roomId], ["incomingUserId": BmobUser.current().objectId]]
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
    

    
    func fetchNotifications(cell: ChatsTableViewCell, objectId: String){
      
        
//        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
//        fetch.predicate = NSPredicate(format: "objectId == %@", objectId)
//        fetch.fetchLimit = 1
//        
//        do {
//            
//            let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
//            
//            DispatchQueue.main.async {
//                
//                if results.count > 0 {
//                    
//                    if let numberOfNotifications = results.first?.numberOfNotifications{
//                        
//                        let intNotification = Int(numberOfNotifications)
//                        
//                        if intNotification > 0 {
//                            
//                            cell.unreadMessageView.isHidden = false
//                            cell.unreadMessageLabel.isHidden = false
//                            
//                            if intNotification >= 99 {
//                                
//                                cell.unreadMessageLabel.text = "99+"
//                                
//                            }else{
//                                
//                                
//                                cell.unreadMessageLabel.text = "\(intNotification)"
//                                
//                            }
//                            
//                            
//                            
//                        }else{
//                            
//                            cell.unreadMessageView.isHidden = true
//                            cell.unreadMessageLabel.isHidden = true
//                            
//                        }
//                        
//                    }
//                    
//                    
//                }
//                
//              
//                
//            }
//        }catch{}
        
    }
    
    
    
    func fetchLastMessage(roomId: String , cell: ChatsTableViewCell, objectId: String){
        
        cell.lastMessageLabel.isHidden = true
        cell.timeStampLabel.isHidden = true

        
        
        let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
        fetch.predicate = NSPredicate(format: "roomId == %@", roomId)
        fetch.sortDescriptors = [NSSortDescriptor(key: "lastUpdate", ascending: false)]
        fetch.fetchLimit = 1
        
        
        do {
            
            let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
            
            DispatchQueue.main.async {
            
                if results.count > 0 {
                    
                    if let lastDate = results.last?.createdAt {
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        
                        let timeElapsedInSeconds = NSDate().timeIntervalSince(lastDate as Date)
                        let secondsInDays: TimeInterval = 60 * 60 * 24
                        
                        if timeElapsedInSeconds > 7 * secondsInDays {
                            
                            dateFormatter.dateFormat = "MM-dd-yyyy"
                            
                        }else if timeElapsedInSeconds > secondsInDays {
                            
                            dateFormatter.dateFormat = "EEE"
                            
                            
                        }
                        
                        cell.timeStampLabel.isHidden = false

                        cell.timeStampLabel.text = dateFormatter.string(from: lastDate as Date)
                        
                    }
                    
                    
                    if let lastMessage = results.last?.textMessage {
                        
                        cell.lastMessageLabel.text = lastMessage
                        cell.lastMessageLabel.isHidden = false

                        
                        
                    }else if let urlString = results.last?.imageMessageURL {
                        
                        
                        
                        let attributed = NSMutableAttributedString(string: "[Image]", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
                        
                        if let url = NSURL(string: urlString) {
                            
                            if let imageData = NSData(contentsOf: url as URL){
                                
                                let attachment = NSTextAttachment()
                                attachment.image = UIImage(data: imageData as Data)
                                attachment.bounds = CGRect(x: 5, y: -5, width: 20, height: 20)
                                attributed.append(NSAttributedString(attachment: attachment))
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                        cell.lastMessageLabel.attributedText = attributed
                        cell.lastMessageLabel.isHidden = false

                        
                    }else if let imageData =  results.last?.imageMessage {
                        
                        
                        let attributed = NSMutableAttributedString(string: "[Image]", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
                        
                        let attachment = NSTextAttachment()
                        attachment.image = UIImage(data: imageData as Data)
                        attachment.bounds = CGRect(x: 5, y: -5, width: 20, height: 20)
                        attributed.append(NSAttributedString(attachment: attachment))
                        cell.lastMessageLabel.attributedText = attributed
                        
                        cell.lastMessageLabel.isHidden = false

                        
                    }else if (results.last?.audioMessage) != nil {
                        
                        cell.lastMessageLabel.isHidden = false

                        cell.lastMessageLabel.text = "[Audio]"
                        
                    }else if let nameCard = results.last?.nameCardId{
                        print(nameCard)
                        
                        cell.lastMessageLabel.isHidden = false

                        cell.lastMessageLabel.text = "[NameCard]"
                        
                    }else if (results.last?.stickerData) != nil {
                        
                        cell.lastMessageLabel.isHidden = false

                        cell.lastMessageLabel.text = "[GIF]"
                        
                        
                    }else{
                        
                        cell.lastMessageLabel.isHidden = true
                        
                        
                    }
                    
                    
                    
                }
                    
                    
                }
            
             
          
        }catch{}
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.searchController.dismiss(animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? ChatsTableViewCell {
           
            cell.unreadMessageLabel.isHidden = true
            cell.unreadMessageView.isHidden = true

            
        }

        if tableView == self.resultsTableViewController.tableView {
        
            
            let chosenUser = self.filteredUsers[indexPath.row]
            
            let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
            let array = [["incomingUserId": BmobUser.current().objectId]]
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
            
            
            
            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            fetch.predicate = NSPredicate(format: "roomId == %@", chosenUser.roomId!)
            fetch.fetchLimit = 1
            
            
            do {
                
                let foundContacts = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
                if let contact = foundContacts.first{
                    
                    if let numbOfNoti = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int {
                        
                        let originalNumber = Int(contact.numberOfNotifications)
                        
                        if numbOfNoti > originalNumber {
                            
                            let newNotification = numbOfNoti - originalNumber
                            UserDefaults.standard.setValue(newNotification, forKeyPath: "numberOfNotifications")
                            
                            
                        }else if numbOfNoti == originalNumber {
                            
                            UserDefaults.standard.setValue(0, forKeyPath: "numberOfNotifications")
                            
                            
                        }
                        
                        
                        
                        if let cell = tableView.cellForRow(at: indexPath) as? ChatsTableViewCell {
                            
                            cell.unreadMessageLabel.text = "\(0)"
                            cell.unreadMessageLabel.isHidden = true
                            cell.unreadMessageView.isHidden = true
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    contact.numberOfNotifications = Int32(0)
                    
                    do {
                        
                        try  self.moc.save()
                        
                        
                    }catch{}
                    
                }
                
            }catch{}
            
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 4
            let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
            messagesVC.hidesBottomBarWhenPushed = true
            messagesVC.incomingUser = chosenUser
            
            messagesVC.navigationItem.title = chosenUser.username
            
            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
            request.predicate = NSPredicate(format: "roomId == %@", chosenUser.roomId!)
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            request.fetchLimit = 15
            
            do {
                let searchResults = try self.moc.fetch(request)
                
                if searchResults.count > 0 {
                    messagesVC.messageObjects.removeAll(keepingCapacity: true)
                    
                    
                    for message in searchResults {
                        
                        let messageObject = MessageObject()
                        
                        messageObject.objectId = message.objectId
                        messageObject.createdAt = message.createdAt
                        messageObject.lastUpdate = message.lastUpdate
                        messageObject.senderId =  message.senderId
                        messageObject.delivered = message.sentOrFailed
                        messageObject.textMessage = message.textMessage
                        messageObject.senderName = message.senderName
                        messageObject.imageWidth = message.imageWidth
                        messageObject.imageHeight = message.imageHeight
                        messageObject.imageMessageURL = message.imageMessageURL
                        messageObject.imageMessage  = message.imageMessage
                        messageObject.audioData = message.audioMessage
                        messageObject.audioDuration = message.audioDuration
                        messageObject.nameCardId = message.nameCardId
                        messageObject.audioListened = message.audioListened
                        messageObject.roomId = message.roomId
                        messageObject.stickerData = message.stickerData
                        messageObject.stickerWidth = message.stickerWidth
                        messageObject.stickerHeight = message.stickerHeight
                        messageObject.nameCardProfilemageData = message.nameCardProfileData
                        messageObject.username = message.nameCardName
                        messageObject.phoneNumber = message.nameCardPhoneNumber
                        messageObject.stickerId = message.stickerId
                        
                        
                        messagesVC.messageObjects.insert(messageObject, at: 0)
                        
                        
                    }
                    if messagesVC.messageObjects.count > 0 {
                        
                        let indexPath = NSIndexPath(item: messagesVC.messageObjects.count - 1, section: 0)
                        messagesVC.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                        
                    }
                    self.navigationController?.pushViewController(messagesVC, animated: true)

                    
                    
                }else{
                    self.navigationController?.pushViewController(messagesVC, animated: true)

                    
                    
                }
                
            } catch {
                print("Error with request: \(error)")
            }

    
            
            
        }else{
            
            let selectedUser = self.users[indexPath.row]
//            let selectedUser = fetchedResultsControler.object(at: indexPath) as! Contacts
            
            
            
            let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
            let array = [["incomingUserId": BmobUser.current().objectId]]
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
                    
                }else{}
            })
            
            
        
            
            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            fetch.predicate = NSPredicate(format: "roomId == %@", selectedUser.roomId!)
            fetch.fetchLimit = 1
            
            
            do {
                
                let foundContacts = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
                if let contact = foundContacts.first{
                    
                    if let numbOfNoti = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int {
                        
                        let originalNumber = Int(contact.numberOfNotifications)
                        
                        if numbOfNoti > originalNumber {
                            
                            let newNotification = numbOfNoti - originalNumber
                            UserDefaults.standard.setValue(newNotification, forKeyPath: "numberOfNotifications")
                            
                            
                        }else if numbOfNoti == originalNumber {
                            
                            UserDefaults.standard.setValue(0, forKeyPath: "numberOfNotifications")
  
                            
                        }
                        
                      
                        
                        if let cell = tableView.cellForRow(at: indexPath) as? ChatsTableViewCell {
                            
                            cell.unreadMessageLabel.text = "\(0)"
                            cell.unreadMessageLabel.isHidden = true
                            cell.unreadMessageView.isHidden = true
  
                            
                            
                        }
                        
                        
                        
                    }
                    
                    contact.numberOfNotifications = Int32(0)
                    
                    do {
                        
                        try  self.moc.save()
                        
                        
                    }catch{}
                    
                }
                
            }catch{}
          
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 4
            let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
            messagesVC.hidesBottomBarWhenPushed = true
            messagesVC.incomingUser = selectedUser
            
            messagesVC.navigationItem.title = selectedUser.username
            
            
            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
            request.predicate = NSPredicate(format: "roomId == %@", selectedUser.roomId!)
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            request.fetchLimit = 15
            
            do {
                let searchResults = try self.moc.fetch(request) 
                
                if searchResults.count > 0 {
                    messagesVC.messageObjects.removeAll(keepingCapacity: true)

                    
                    for message in searchResults {
                        
                        let messageObject = MessageObject()
                        
                        messageObject.objectId = message.objectId
                        messageObject.createdAt = message.createdAt
                        messageObject.lastUpdate = message.lastUpdate
                        messageObject.senderId =  message.senderId
                        messageObject.delivered = message.sentOrFailed
                        messageObject.textMessage = message.textMessage
                        messageObject.senderName = message.senderName
                        messageObject.imageWidth = message.imageWidth
                        messageObject.imageHeight = message.imageHeight
                        messageObject.imageMessageURL = message.imageMessageURL
                        messageObject.imageMessage  = message.imageMessage
                        messageObject.audioData = message.audioMessage
                        messageObject.audioDuration = message.audioDuration
                        messageObject.nameCardId = message.nameCardId
                        messageObject.audioListened = message.audioListened
                        messageObject.roomId = message.roomId
                        messageObject.stickerData = message.stickerData
                        messageObject.stickerWidth = message.stickerWidth
                        messageObject.stickerHeight = message.stickerHeight
                        messageObject.nameCardProfilemageData = message.nameCardProfileData
                        messageObject.username = message.nameCardName
                        messageObject.phoneNumber = message.nameCardPhoneNumber
                        messageObject.stickerId = message.stickerId

                        
                        
                        messagesVC.messageObjects.insert(messageObject, at: 0)
                        
                        
                    }
                    if messagesVC.messageObjects.count > 0 {
                        
                        let indexPath = NSIndexPath(item: messagesVC.messageObjects.count - 1, section: 0)
                        messagesVC.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                        
                    }
                    
                    self.navigationController?.pushViewController(messagesVC, animated: true)
  
                    
                }else{
                    
                    self.navigationController?.pushViewController(messagesVC, animated: true)
   
                    
                }
                
            }catch{}
            
            
           

     
            
        }
    }
 
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var userIdToBeDeleted: Contacts?
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Block and Delete", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Block", style: .destructive , handler: { (action) in
               
                let selectedUserId = self.users[indexPath.row]
//                let selectedUserId = self.fetchedResultsControler.object(at: indexPath) as! Contacts
                self.userIdToBeDeleted = selectedUserId
                
               
                
                if let userId = self.userIdToBeDeleted?.objectId {
                    
//                    self.users.remove(at: indexPath.row)
                    
                    self.tableView.reloadData()
                    
                    
//                    self.blockBlurView.isHidden = false
//                    self.blockActivityIndicator.startAnimating()
                    
                    let userToBeBlocked = BmobObject(outDataWithClassName: "_User", objectId: userId)
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
                                    
                                    self.queryChatRoom(userId: userId)
                                    
                                    
                                }else{
                                    
                                    self.queryChatRoom(userId: userId)

//                                    self.blockBlurView.isHidden = true
//                                    self.blockActivityIndicator.stopAnimating()
                                    print(error?.localizedDescription as Any)
                                    
                                }
                            })
                            
                            
                        }else{
                            
                            
                            
                            self.queryChatRoom(userId: userId)


//                            self.blockBlurView.isHidden = true
//                            self.blockActivityIndicator.stopAnimating()
                            
                            print(error?.localizedDescription as Any)
                        }
                    })
                    
                    
                    
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    let currrentUser = BmobUser.current()

    func queryChatRoom(userId: String){
        
        let query1 = BmobQuery(className: "Room")
        let array1 = [["user1Id": self.currrentUser?.objectId] ,["user2Id": userId]]
        query1?.addTheConstraintByAndOperation(with: array1)
        query1?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if results?.count == 0 {
                    //no room yet
                    
                    self.secondQuery(userId: userId)
                    

                    
                }else if (results?.count)! > 0 {
                    
                    for result in results! {
                        
                        self.finallyDeleteFoundRoom(roomObject: result as! BmobObject , userId: userId)
   
                        
                    }
                    
                    
                    
                    
                }
                
            }else{
                
//                self.blockBlurView.isHidden = true
//                self.blockActivityIndicator.stopAnimating()
                
                //error
                
            }
        })
        
        
        
    }
    
    
    
    func secondQuery(userId: String){
        
        let query = BmobQuery(className: "Room")
        let array2 = [["user1Id": userId],  ["user2Id": currrentUser?.objectId]] as [Any]
        query?.addTheConstraintByAndOperation(with: array2)
        query?.findObjectsInBackground({ (secondResults, error) in
            if error == nil {
                
                if (secondResults?.count)! > 0 {
                    
                    for result in secondResults! {
                        
                        self.finallyDeleteFoundRoom(roomObject: result as! BmobObject, userId: userId)
    
                        
                    }
                    
                    
                    
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
                                    
                                    //                                self.blockBlurView.isHidden = true
                                    //                                self.blockActivityIndicator.stopAnimating()
                                    
                                    
                                }catch{
                                    
                                    print(error)
                                }
                                
                            }
                            
                        }
                        
                    } catch {
                        
                        //                    self.blockBlurView.isHidden = true
                        //                    self.blockActivityIndicator.stopAnimating()
                        print("Error with request: \(error)")
                    }
                    
                }
                
            }else{
                
//                self.blockBlurView.isHidden = true
//                self.blockActivityIndicator.stopAnimating()
                print(error?.localizedDescription as Any)
                
            }
        })
        
        
    }
    
   
    
    func finallyDeleteFoundRoom(roomObject: BmobObject, userId: String){
        
        
        
                self.deleteNotifications(roomId: roomObject.objectId)
                
                roomObject.deleteInBackground({ (success, error) in
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
                                        
                                        //                                self.blockBlurView.isHidden = true
                                        //                                self.blockActivityIndicator.stopAnimating()
                                        
                                        
                                    }catch{
                                        
                                        print(error)
                                    }
                                    
                                }
                                
                            }
                            
                        } catch {
                            
                            //                    self.blockBlurView.isHidden = true
                            //                    self.blockActivityIndicator.stopAnimating()
                            print("Error with request: \(error)")
                        }
                        
                       
                    
                        
                    }else{
                        
                        //
                        //                self.blockBlurView.isHidden = true
                        //                self.blockActivityIndicator.stopAnimating()
                        
                        print("Error deleting room \(error?.localizedDescription as Any)")
                    }
                })
                
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
