//
//  ContactTableViewController.swift
//  Trendin
//
//  Created by Rockson on 10/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import Contacts
import CoreData



class ContactTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    let reuseIdentifier = "cellId"
    var users = [Contacts]()
    var filteredUsers = [Contacts]()
    let currentUser = BmobUser.current()
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    
    let backgroundV: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.white
        return bView
        
    }()
    
    let BackgroundImageView: customImageView = {
        let imageV = customImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    var leftButton: UIButton?
    
    var resultsTableViewController = UITableViewController(style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        let reView = RecommendedUsersView(frame: rect)
        reView.incomingVC = self
        tableView.tableHeaderView = reView
        
        self.resultsTableViewController.tableView.delegate = self
        self.resultsTableViewController.tableView.dataSource = self
        
        
        navigationItem.title = "Friends"
        
        
        self.tableView.backgroundColor = UIColor.white
        
        
        let image = UIImage(named: "Add")
        
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftButton?.addTarget(self, action: #selector(handleLeftBarButton), for: .touchUpInside)
        leftButton?.setBackgroundImage(image, for: .normal)
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton!)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        
        
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleRightBarButton))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        
        //        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleLeftBarButton))
        
        
        //        self.loadUsers()
        
        self.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.resultsTableViewController.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refetchData), name: NSNotification.Name("reloadMessages"), object: nil)
        
        self.loadContactsFromCoreData()
        self.loadNotificationFromBackend()
        self.loadUsersFromBackendInBackground()
//        self.refetchData()

        
    }
    
    func refetchData(){
        
        if allContactsArray.count > 0 {
            
            for contact in allContactsArray{
                
                if let roomId = contact.roomId, let objectId = contact.objectId{
                    
                    
                    self.loadMessagesFromBackend(roomId: roomId, objectId: objectId)
                    
                    
                    
                }
                
                self.loadUsersFromBackendInBackground()
                
                
            }
            
            
        }
        
    }
    
    func loadUsersFromBackendInBackground(){
        
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
                    
           
                }else{
                    
                    
                    
                    //No rooms
                    
                    
                    
                }
            }else{
                
                
                
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
                
                
            }
            
        } catch {
            print("Error with request: \(error)")
            
            
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

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
        
    }
    
    
    func handleLeftBarButton(){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        alert.addAction(UIAlertAction(title: "Search By Username", style: .default, handler: { (action) in
            
            let searchUserVC = SearchByUsernameTableViewController()
            searchUserVC.searchBy = "username"
            searchUserVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(searchUserVC, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Search By Phone Number", style: .default, handler: { (action) in
            
            let searchVC = SearchByUsernameTableViewController()
            searchVC.searchBy = "phoneNumber"
            searchVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(searchVC, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
            
            presenter.sourceView = self.leftButton
            presenter.sourceRect = (self.leftButton?.bounds)!
            
            
        }
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func handleRightBarButton(){
        
        let searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        self.present(searchController, animated: true, completion: nil)
        
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        
        self.filteredUsers = self.users.filter({ (contact) -> Bool in
            
            if (contact.username?.lowercased().contains((searchText?.lowercased())!))! {
                
                return true
                
            }else{
                
                return false
            }
            
        })
        
        
        self.resultsTableViewController.tableView.reloadData()
        
        
        
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
                        
                        self.processAndSaveReceivedObjectFromBackend(object: object, objectId: objectId)
                        
                        self.deleteMessageAfterReceive(object: object)
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }else{
                
            }
        }
        
        
    }
    
    func deleteMessageAfterReceive(object: BmobObject){
        
        object.deleteInBackground { (success, error) in
            if success {
                
                print("message deleted")
                
                
            }else{}
        }
        
        
    }
    
    
    func processAndSaveReceivedObjectFromBackend(object: BmobObject, objectId: String){
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "objectId == %@", objectId)
        fetch.fetchLimit = 1
        
        
        do {
            
            let foundContacts = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
            if let contact = foundContacts.first {
                
                let originalNumber = Int(contact.numberOfNotifications)
                contact.numberOfNotifications = Int32(originalNumber + 1)
                
                do {
                    
                    try self.moc.save()
                    
                }catch{}
                
                
                
            }
            
        }catch{}
        
        
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (objectId))
        request.fetchLimit = 1
        
        do {
            let searchResults = try self.moc.fetch(request)
            
            if let result = searchResults.first {
                
                result.lastUpdate = NSDate()
                result.newOrOld = NSNumber(booleanLiteral: true) as Bool
                
                print("user info updated")
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        
        
        
        
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
            
        }catch {}
        
        
        
        if UserDefaults.standard.object(forKey: "numberOfNotifications") == nil {
            
            UserDefaults.standard.setValue(1 , forKeyPath: "numberOfNotifications")
            
            
            let customNotification  = self.tabBarController
            for item in  (customNotification?.tabBar.items!)! {
                
                if let title = item.title {
                    
                    if title == "Chats" {
                        
                        if let savedNotification = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                            
                            item.badgeValue = "\(savedNotification)"
                            item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                            
                            
                        }
                        
                        
                        
                        
                    }
                }
                
            }
            
            
            
            
            
        }else{
            
            
            if let numberOfNotifi = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                
                let newNumberOfNotifcations = numberOfNotifi + 1
                UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
                UserDefaults.standard.setValue(newNumberOfNotifcations, forKeyPath: "numberOfNotifications")
                
                
                
                let customNotification  = self.tabBarController
                for item in  (customNotification?.tabBar.items!)! {
                    
                    if let title = item.title {
                        
                        if title == "Chats" {
                            
                            if let savedNotification = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int{
                                
                                item.badgeValue = "\(savedNotification)"
                                item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                                
                                
                            }
                            
                            
                            
                            
                        }
                    }
                    
                }
                
            }
            
            
            
        }
        
    }
    
    

    
//    func loadNumberOfNotification(){
//        self.fetchAndSaveNotifications()
//        
//        
//        
//        let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
//        let array = [["incomingUserId": BmobUser.current().objectId]]
//        unreadMessageQuery?.addTheConstraintByAndOperation(with: array)
//        unreadMessageQuery?.countObjectsInBackground({ (counts, error) in
//            if error == nil {
//                
//                self.loadNotificationFromBackend()
//                
//                DispatchQueue.main.async {
//                    
//                    if counts > 0 {
//                        
//                        
//                        let customNotification  = self.tabBarController
//                        for item in  (customNotification?.tabBar.items!)! {
//                            
//                            if let title = item.title {
//                                
//                                if title == "Chats" {
//                                    
//                                    print(title)
//                                    
//                                    item.badgeValue = "\(counts)"
//                                    item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
//                                    
//                                    
//                                }
//                            }
//                            
//                        }
//                        
//                        
//                    }
//                    
//                }
//            }else{
//                
//                self.tabBarItem.badgeValue = nil
//                
//            }
//        })
//        
//    }
    
    func loadNotificationFromBackend(){
        print("notified being called...")
        
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
    
    func queryCoreDataIfUserExists(user: BmobUser){
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "objectId == %@", user.objectId)
        fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            
            let results = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
            
            if results.count > 0 {
                
                self.filteredUsers.removeAll(keepingCapacity: true)
                
                
                for result in results {
                    
                    print(result)
                    
                    
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
    
    
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Friends"
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func loadContactsFromCoreData(){
        
        let AppDel = UIApplication.shared.delegate as! AppDelegate
        let moc = AppDel.persistentContainer.viewContext
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let searchResults = try moc.fetch(request)
            
            if searchResults.count > 0  {
                self.users.removeAll(keepingCapacity: true)
                
                // save the new user if the user doesn't exist
                
                for contact in searchResults {
                    
                    //                    let movies = [movieB, movieC, movieA]
                    //                    let sortedMovies = movies.sort { $0.name < $1.name }
                    //                    sortedMovies
                    
                    
                    self.users.append(contact)
                    
                    //                    self.users = users.sorted(by: {$0 < $1 })
                }
                
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
                
                
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        
        
    }
    
    //    func loadUsers(){
    //
    //        let query = BmobUser.query()
    //        let loggedInUser = BmobObject(outDataWithClassName: "_User", objectId: currentUser?.objectId)
    //        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
    //        query?.whereObjectKey("friends", relatedTo: loggedInUser)
    //        query?.findObjectsInBackground { (array, error) in
    //            if error == nil {
    //
    //                if (array?.count)! > 0 {
    //
    //                    self.users.removeAll(keepingCapacity: true)
    //
    //                    for user in array! {
    //
    //                        let friend = user as! BmobUser
    //
    ////                        self.users.append(friend)
    //
    //                    }
    //
    //
    //                    DispatchQueue.main.async {
    //
    //                        self.tableView.reloadData()
    //                    }
    //
    //
    //                }
    //            }
    //
    //        }
    //
    //
    //    }
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactsTableViewCell
        cell.backgroundColor = UIColor.white
        // Configure the cell...
        
        cell.accessoryType = .detailButton
        
        
        if tableView == self.resultsTableViewController.tableView {
            
            let userInf = self.filteredUsers[indexPath.row]
            
            if let username = userInf.username {
                
                cell.usernameLabel.text = username
            }
            
            if let profileImageData = userInf.profileImageData {
                
                let image = UIImage(data: profileImageData as Data)
                cell.profileImageView.image = image
                
            }
            
            
            
            
            
        }else{
            
            let userInfo = self.users[indexPath.row]
            
            if let username = userInfo.username {
                
                cell.usernameLabel.text = username
            }
            
            if let profileImageData = userInfo.profileImageData {
                
                let image = UIImage(data: profileImageData as Data)
                cell.profileImageView.image = image
                
            }
            
            
            
        }
        
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if tableView == self.resultsTableViewController.tableView {
            
            let selectedUser = self.filteredUsers[indexPath.row].objectId
            
            let layout = UICollectionViewFlowLayout()
            let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
            myMomentsVC.incomingUser = selectedUser
            myMomentsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myMomentsVC, animated: true)
            
        }else{
            
            let selectedUser = self.users[indexPath.row].objectId
            
            let layout = UICollectionViewFlowLayout()
            let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
            myMomentsVC.incomingUser = selectedUser
            myMomentsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myMomentsVC, animated: true)
            
        }
        
        
        
    }


    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.resultsTableViewController.tableView  {
            
            let selectedItem = self.filteredUsers[indexPath.row]
            
            
            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            fetch.predicate = NSPredicate(format: "objectId == %@", selectedItem.objectId!)
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
                        
            
                    }
                    
                    contact.numberOfNotifications = Int32(0)
                    
                    do {
                        
                        try  self.moc.save()
                        
                        
                    }catch{}
                    
                }
                
            }catch{}
            
            let layout = UICollectionViewFlowLayout()
            let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
            messagesVC.hidesBottomBarWhenPushed = true
            layout.minimumLineSpacing = 4
            messagesVC.incomingUser = selectedItem
            messagesVC.navigationItem.title = selectedItem.username
//            self.navigationController?.pushViewController(messagesVC, animated: true)
            
            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
            request.predicate = NSPredicate(format: "roomId == %@", selectedItem.roomId!)
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
            
            
            let selectedItem = self.users[indexPath.row]
            
            
            
            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            fetch.predicate = NSPredicate(format: "objectId == %@", selectedItem.objectId!)
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
                 
                        
                        
                    }
                    
                    contact.numberOfNotifications = Int32(0)
                    
                    do {
                        
                        try  self.moc.save()
                        
                        
                    }catch{}
                    
                }
                
            }catch{}
            
            
            
            let layout = UICollectionViewFlowLayout()
            
            let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
            messagesVC.hidesBottomBarWhenPushed = true
            layout.minimumLineSpacing = 4
            messagesVC.incomingUser = selectedItem
            messagesVC.navigationItem.title = selectedItem.username
//            self.navigationController?.pushViewController(messagesVC, animated: true)
            
            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
            request.predicate = NSPredicate(format: "roomId == %@", selectedItem.roomId!)
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
            
            

            
            
        }
        
       
        
        
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
