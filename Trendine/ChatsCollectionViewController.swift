//
//  ChatsCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 08/02/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData


class ChatsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    private let reuseIdentifier = "Cell"
    private let headerViewIdentifier = "headerViewIdentifier"
    
    lazy var  searchController:  UISearchController = {
        let controller = UISearchController(searchResultsController: self.searchUsersController)
        controller.searchBar.delegate = self
        return  controller
        
    }()
    
    let resultsController: ResultsCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let vc =  ResultsCollectionViewController(collectionViewLayout: layout)
        return vc
        
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
    
    
//    lazy var  searchController:  UISearchController = {
//        let controller = UISearchController()
//        controller.searchBar.delegate = self
//        return  controller
//        
//    }()
//    var resultsTableViewController = ChatsTableViewController()
    
    
//    let searchUsersController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    
    let searchUsersController:  UICollectionViewController = {
       let cvtroller = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        cvtroller.collectionView?.backgroundColor = .white
        return cvtroller
        
    }()

//    var filteredUsers = [Contacts]()
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "newOrOld == %@", NSNumber(booleanLiteral: true))
        request.sortDescriptors =  [NSSortDescriptor(key: "lastUpdate", ascending: false)]
        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResults.delegate  = self
        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
    }()
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            
            blockOperations.append(BlockOperation(block: {
                
                (self.collectionView?.insertItems(at: [newIndexPath!]))!
                
                
            }))
            
        }
        
    
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.collectionView?.performBatchUpdates({
            
            for operation in self.blockOperations{
                
                operation.start()
                
            }
            
            
            
        }, completion: { (completed) in
            
//        let indexPath = NSIndexPath(item: (self.fetchedResultsControler.sections?[0].numberOfObjects)! - 1, section: 0)
//         self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            

            
        })
        
        
       
        
        
    }

    
//    let layout = UICollectionViewLayout()
//    var resultsCollectionViewController = UICollectionViewController(collectionViewLayout: layout)
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.groupTableViewBackground
        
        self.displayActivityInProgressView()
        
        
        do {
            
            try self.fetchedResultsControler.performFetch()
            
        }catch{}

        navigationItem.title = "Chats"
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange), name: NSNotification.Name(ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()

    collectionView?.register(ChatsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)

        self.collectionView?.backgroundColor = .white
        self.collectionView!.register(ChatsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  
//        searchUsersController.collectionView?.register(ChatsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        
//        searchUsersController.collectionView?.delegate = self
//        searchUsersController.collectionView?.dataSource = self

        
        
//        self.resultsTableViewController.tableView.dataSource = self
//        self.resultsTableViewController.tableView.delegate = self
        
//        self.searchController = UISearchController(searchResultsController: self.resultsTableViewController)
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = true
////        C = self.searchController.searchBar
//        definesPresentationContext = true
//        self.searchController.searchBar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()

        
        
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
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        self.checkReachability()
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMessagesNotified), name: NSNotification.Name("reloadMessages"), object: nil)
        

        self.loadNotificationFromBackend()
        
        if let friends = fetchedResultsControler.sections?[0].objects as? [Contacts] {
            
            if friends.count > 0 {
                
              allContactsArray.removeAll(keepingCapacity: true)
                
                for friend in friends {
                    
                allContactsArray.append(friend)
                self.loadMessagesFromBackend(roomId: friend.roomId!, objectId: friend.objectId!)
                    
                    
                }
                
            self.loadUsersFromBackend(showLoader: true)
                
            }else{
                
             self.loadUsersFromBackend(showLoader: false)
                
                
            }
            
            
        }
        

        
        
        
    }
    
    func fetchMessagesNotified(){
        
        if allContactsArray.count > 0 {
            
            for contact in allContactsArray {
              
                self.loadMessagesFromBackend(roomId: contact.roomId!, objectId: contact.objectId!)

                
            }
        }
    }
    
    func displayActivityInProgressView(){
        
        
        if let motherView = self.view {
            
            
            motherView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: motherView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: motherView.centerYAnchor).isActive = true
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
            self.blurView.isHidden = true
            
        }
        
        
    }
    


    func updateSearchResults(for searchController: UISearchController) {
        self.resultsController.filteredUsers.removeAll(keepingCapacity: true)
        
        
        let searchText = searchController.searchBar.text
        
        self.resultsController.filteredUsers = (fetchedResultsControler.sections![0].objects! as! [Contacts]).filter({ (contact) -> Bool in
            
            if ((contact as Contacts).username?.lowercased().contains((searchText?.lowercased())!))! {
                
                return true
                
            }else{
                
                return false
            }
            
        })
        
        
        self.resultsController.collectionView?.reloadData()

        
        
    }
    

    
    func checkReachability() {
        
        guard let r = reachability else { return }
        if r.isReachable  {
            
            
        } else {
            
            
            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
            
        }
    }
    
    func alert(reason: String){
        
        let alert = UIAlertController(title: "No Internet!!", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func reachabilityDidChange(notification: Notification){
        
        
        guard let r = reachability else { return }
        if r.isReachable  {
            
        } else {
            
            
            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
            
        }
        
    }
    
    func loadNotificationFromBackend(){
        
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
                                    
                                    if let count = results?.count {
                                        
                                        item.badgeValue = "\(count)"
                                        item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }else{}
        })
        
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
    
    
    func processAndSaveReceivedObjectFromBackend(object: BmobObject, objectId: String){
        
    
        
    
        
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
          
        }catch {}
        
        
        
        
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
        
        
        DispatchQueue.main.async {
            
            self.collectionView?.reloadData()
   
            
        }
        
        
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
        
        
        
        
    }
    
    func deleteMessageAfterReceive(object: BmobObject){
        
        object.deleteInBackground { (success, error) in
            if success {
                
                print("message deleted")
                
                
            }else{}
        }
        
        
    }
    
    
    
    func loadUsersFromBackend(showLoader: Bool){
        
        self.blurView.isHidden = showLoader
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
                        
                    
                    self.blurView.isHidden = true
                        
                    self.collectionView?.reloadData()
                        
                    }
                    
                    
                }else{
                    
                    
                    self.blurView.isHidden = true
                    
                    //No rooms
                    
                    
                    
                }
            }else{
                
                
                self.blurView.isHidden = true
                
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


    
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ChatsCollectionViewCell
        cell.backgroundColor = UIColor.lightGray

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ChatsCollectionViewCell
        cell.backgroundColor = UIColor.white

        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if collectionView == self.searchUsersController.collectionView {
//            
//           return self.filteredUsers.count
//            
//        }else{
        
            if let count = fetchedResultsControler.sections?[0].numberOfObjects{
                
                return count
                
            }
            
//        }

        
       
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatsCollectionViewCell
        
           cell.backgroundColor = UIColor.white

        
            
            let contact = fetchedResultsControler.object(at: indexPath) as! Contacts
            
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
            
            if let roomId = contact.roomId {
                
                self.fetchLastMessage(roomId: roomId, cell: cell, objectId: contact.objectId!)
                
            }
            
            
        
        
       
    
        return cell
    }
    
    func fetchLastMessage(roomId: String , cell: ChatsCollectionViewCell, objectId: String){
        
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
                        
                        
                        
                    }else if (results.last?.imageMessageURL) != nil {
                        

                        cell.lastMessageLabel.text = "[Image]"
                        cell.lastMessageLabel.isHidden = false
                        
                        
                    }else if (results.last?.imageMessage) != nil {

                        
                        cell.lastMessageLabel.text = "[Image]"
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
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: ChatsHeaderCollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath) as? ChatsHeaderCollectionReusableView
            
            headerView?.searchButton.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)

//            headerView?.searchButton  = searchController.searchBar
//            self.collectionView?.reloadData()
            
        }
        
        return headerView!
    }
  
    
    func handleSearchButtonTapped(){
        
        self.resultsController.motherView = self
        
        searchController = UISearchController(searchResultsController: self.resultsController)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.view.backgroundColor = UIColor.groupTableViewBackground
        self.present(searchController, animated: true, completion: nil)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 50)  // Header size
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! ChatsCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
      
            let selectedUser = fetchedResultsControler.object(at: indexPath) as! Contacts
            self.prepareToMoveToChatRoom(selectedUser: selectedUser, indexPath: indexPath)

        
        
        
      }
    
    
    
    func prepareToMoveToChatRoom(selectedUser: Contacts, indexPath: IndexPath){
        
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
                
                let foundContacts = try moc.fetch(fetch) 
                if let contact = foundContacts.first{
                    
                    if let numbOfNoti = UserDefaults.standard.object(forKey: "numberOfNotifications") as? Int {
                        
                        let originalNumber = Int(contact.numberOfNotifications)
                        
                        if numbOfNoti > originalNumber {
                            
                            let newNotification = numbOfNoti - originalNumber
                            
                            UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
                            UserDefaults.standard.setValue(newNotification, forKeyPath: "numberOfNotifications")
                            
                            
                        }else if numbOfNoti == originalNumber {
                            
                            UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
                            UserDefaults.standard.setValue(0, forKeyPath: "numberOfNotifications")
                            
                            
                        }else{
                            
                            UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
 
                        }
                        
                        
                        
                        if let cell = collectionView?.cellForItem(at: indexPath) as? ChatsCollectionViewCell {
                            
                            cell.unreadMessageLabel.text = ""
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
