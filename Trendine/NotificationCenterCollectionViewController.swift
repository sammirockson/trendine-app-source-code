//
//  NotificationCenterCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 05/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData


class NotificationCenterCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    var incomignVC: TrendinCollectionViewController?
    var objects = [BmobObject]()
    var friendsId = [String]()

    
    var isLoadingOldPosts = false

    override func viewDidLoad() {
        super.viewDidLoad()
        


        
//        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 0.9)


        collectionView?.backgroundColor = .white
        navigationItem.title = "Notifications"


        // Register cell classes
        self.collectionView!.register(NotificationCenterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        if incomignVC != nil {
            
            let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleLeftBarButton))
            navigationItem.setLeftBarButton(leftBarButton, animated: true)
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarItem.badgeValue = nil
        
        if allContactsArray.count > 0 {
            
            for contact in allContactsArray{
                
                if let roomId = contact.roomId, let objectId = contact.objectId{
                    
                    
                    self.loadMessagesFromBackend(roomId: roomId, objectId: objectId)
                    
                    
                    
                }
                
            }
            
            
        }
        
//        loadNumberOfNotification()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterNotifications), name: NSNotification.Name("reloadMessages"), object: nil)
 
        
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.queryFriends()

        self.loadNotification()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarItem.badgeValue = nil
    }
    
    func handleLeftBarButton(){
        
        self.dismiss(animated: true, completion: nil)
    }

    
    
    func deleteMessageAfterReceive(object: BmobObject){
        
        object.deleteInBackground { (success, error) in
            if success {
                
                print("message deleted")
                
                
            }else{
                
                
                print("error deleting message \(error?.localizedDescription)")
            }
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
                        
                        self.processAndSaveReceivedObjectFromBackend(object: object, objectId: objectId)
                        
                        self.deleteMessageAfterReceive(object: object)
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }else{
                
            }
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

    
    
    func queryFriends(){
        
        let queryUser = BmobUser.query()
        let loggedInUser = BmobUser.current()
        queryUser?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        queryUser?.whereObjectKey("friends", relatedTo: loggedInUser)
        queryUser?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                    
                    self.friendsId.removeAll(keepingCapacity: true)
                    
                    for result in results! {
                       
                        if let friend = result as? BmobUser{
                            
                            DispatchQueue.main.async {
                                
                            self.friendsId.append(friend.objectId)
   
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
        })
        
    }
    
    
    func loadNotification(){
        let currentUser = BmobUser.current()

        let query = BmobQuery(className: "NotificationCenter")
        query?.order(byDescending: "createdAt")
        query?.includeKey("responder")
        query?.whereKey("userToBeNotified", equalTo: currentUser)
        query?.limit = 50
//        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.findObjectsInBackground({ (results, error) in
            
            if error == nil {
              
                self.isLoadingOldPosts = false
                
                if (results?.count)! > 0 {
                    
                    self.objects.removeAll(keepingCapacity: true)

                    
                    for result in results! {
                        
                        
                       // if let userToBeNotified = (result as! BmobObject).object(forKey: "userToBeNotified") as? BmobUser {
                        
                           // if userToBeNotified.objectId != BmobUser.current().objectId {
                            
                                self.objects.append(result as! BmobObject)

                                
                          //  }
                        //}
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                    
                        self.collectionView?.reloadData()
                        
                    }
                }
                
                
            }else{
                

                
                print(error?.localizedDescription as Any)
                
            }
        })
        
        
    }

    func loadMoreNotifications(){
        
        self.isLoadingOldPosts = true

        
        let currentUser = BmobUser.current()
        
        let query = BmobQuery(className: "NotificationCenter")
        query?.order(byDescending: "createdAt")
        query?.includeKey("responder")
        query?.whereKey("userToBeNotified", equalTo: currentUser)
        query?.limit = 50
        query?.findObjectsInBackground({ (results, error) in
            
            if error == nil {
                
                self.isLoadingOldPosts = false

                
                if (results?.count)! > 0 {
                    
                    
                
                    for result in results! {
                        
                    
                        self.objects.append(result as! BmobObject)
                        
                     
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        
                        self.collectionView?.reloadData()
                        
                    }
                }
                
                
            }else{
                
                self.isLoadingOldPosts = false

                print(error?.localizedDescription as Any)
                
            }
        })
    }
    
    
    
    
    func handleAddUserTapped(sender: UIButton){
        if sender.currentTitle == "Add" {
//            sender.setTitle("Added", for: .normal)

        
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point){
                
                let selectedItem = self.objects[indexPath.item]
                if let selectedUser = selectedItem.object(forKey: "responder") as? BmobUser {
                   let user = selectedItem.object(forKey: "userToBeNotified") as? BmobUser

                    
                    let relation = BmobRelation()
                    let currentUser = BmobUser.current()
                    
                    relation.add(selectedUser)
                    currentUser?.add(relation, forKey: "friends")
                    currentUser?.updateInBackground(resultBlock: { (success, error) in
                        if error == nil {
                            
                            print("added")
                            
                            let notify = BmobObject(className: "NotificationCenter")
                            notify?.setObject(user, forKey: "userToBeNotified")
                            notify?.setObject("You have earned 100 points!", forKey: "notificationReason")
                            notify?.setObject(false, forKey: "userLikedIt")
                            notify?.setObject(false, forKey: "addRequest")
                            notify?.setObject(true, forKey: "addPoints")
                            notify?.setObject(BmobUser.current(), forKey: "responder")
                            notify?.setObject(true, forKey: "notified")
                            notify?.setObject(true, forKey: "requestAccepted")
                            notify?.updateInBackground(resultBlock: { (success, error) in
                                if success {
                                    
                                 print("updated...")
                                    
                                }else{
                                    
                                    
                                
                                }
                            })
                            
                            sender.setTitle("Added", for: .normal)
                            
                            self.prepareToSaveRoom(selectedItem: selectedUser, sender: sender)
                            
                            
                        }else {
                            
                            
                            
                            
                        }
                    })
                    
                    
                }
                
                
            }
            
        }else if sender.currentTitle == "Accept" {
//        sender.setTitle("Accepted", for: .normal)

            print("layer 1")
            
            let currentUser = BmobUser.current()
            
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point){
                
                print("layer 2")

                
                let selectedItem = self.objects[indexPath.item]
                
                
                    if var currentBalance = currentUser?.object(forKey: "contestPoints") as? Int {
                        
                        print("layer 3")

                        
                            currentBalance = currentBalance + 100
                            currentUser?.setObject(currentBalance, forKey: "contestPoints")
                            currentUser?.updateInBackground(resultBlock: { (success, error) in
                                if success {
                                    
                                    sender.setTitle("Accepted", for: .normal)
                                    
                                    let query = BmobQuery(className: "NotificationCenter")
                                    query?.getObjectInBackground(withId: selectedItem.objectId, block: { (obj, error) in
                                        if error == nil {
                                            
                                            obj?.deleteInBackground({ (success, error) in
                                                if success {
                                                    
                                                    print("deleted....")
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        self.objects.remove(at: indexPath.item)
                                                        self.collectionView?.reloadData()
                                                        
                                                    }
                                                }else{
                                                    
                                                    
                                                    print(error?.localizedDescription as Any)
                                                }
                                            })
                                            
                                        }
                                    })

                                    
//                                    let notify = BmobObject(className: "NotificationCenter")
//                                    notify?.setObject(user, forKey: "userToBeNotified")
//                                    notify?.setObject("Recommendation: you've earned 100 points!", forKey: "notificationReason")
//                                    notify?.setObject(false, forKey: "userLikedIt")
//                                    notify?.setObject(false, forKey: "addRequest")
//                                    notify?.setObject(true, forKey: "addPoints")
//                                    notify?.setObject(true, forKey: "pointsAccepted")
//                                    notify?.setObject(BmobUser.current(), forKey: "responder")
//                                    notify?.setObject(true, forKey: "notified")
//                                    notify?.updateInBackground(resultBlock: { (success, error) in
//                                        if success {
//                                            
//                                            sender.setTitle("Accepted", for: .normal)
//   
//                                         print("updated...")
//                                        }else{
//                                            
//                                            print(error?.localizedDescription)
//                                        }
//                                    })
//                                    
                                    
                                    
                                    
                                    
                                }
                            })
                            
                        
                    
                    
                    
                    
                    
                    
                    
                
                }
                
              
                
                
            }
            
           
            
            
            
            
        }
        
      
        
    }
    
    func prepareToSaveRoom(selectedItem: BmobUser, sender: UIButton){
        let currentUser = BmobUser.current()
        
        let query1 = BmobQuery(className: "Room")
        let array1 = [["user1Id": currentUser?.objectId] ,["user2Id": selectedItem.objectId]]
        query1?.addTheConstraintByAndOperation(with: array1)
        query1?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if results?.count == 0 {
                    //no room yet
                    
                    let query = BmobQuery(className: "Room")
                    let array2 = [["user1Id": selectedItem.objectId],  ["user2Id": currentUser?.objectId]]
                    query?.addTheConstraintByAndOperation(with: array2)
                    query?.findObjectsInBackground({ (secondResults, error) in
                        if error == nil {
                            
                            if secondResults?.count == 0 {
                                
                                self.saveToRoom(selectedItem: selectedItem, sender: sender)
                                
                                
                            }else if secondResults?.count == 1 {
                                
                            self.savedContactToCoreData(friend: selectedItem, room: secondResults?.first as! BmobObject, sender: sender)
                                
                                
                            }
                            
                            
                        }else{
                            
//                            self.backgroundBlurView.isHidden = true
                            
                            
                            
                            
                        }
                    })
                    
                    
                    
                }else if results?.count == 1{
                    
                    //there's room
                    
                    
                    self.savedContactToCoreData(friend: selectedItem, room: results?.first as! BmobObject, sender: sender)
                    
                    
                }
                
            }else{
                
//                self.backgroundBlurView.isHidden = true
                
            }
        })
        
    }
    
    
    func saveToRoom(selectedItem: BmobUser, sender: UIButton){
        
        let room = BmobObject(className: "Room")
        room?.setObject(selectedItem, forKey: "user1")
        room?.setObject(BmobUser.current(), forKey: "user2")
        room?.setObject(selectedItem.objectId, forKey: "user1Id")
        room?.setObject(BmobUser.current().objectId, forKey: "user2Id")
        room?.saveInBackground(resultBlock: { (success, error) in
            if error == nil {
                
                print("room saved...")
                
                self.savedContactToCoreData(friend: selectedItem, room: room!, sender: sender)
                
            }else{
                
//                self.backgroundBlurView.isHidden = true
                
                
                
                
            }
        })
        
        
        
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
                
                // save the new user if the user doesn't exist
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                
                entity.createdAt = friend.createdAt as NSDate?
                entity.objectId = friend.objectId
                entity.lastUpdate = NSDate()
                entity.newOrOld = NSNumber(booleanLiteral: false) as Bool
                entity.roomId = room.objectId
                
                do {
                    
                    try moc.save()
                    
                    
                    sender.setTitle("Added", for: .normal)
//                    self.backgroundBlurView.isHidden = true
                    
                    
                    
                    print("contact saved successfully")
                    

                    
                    
                }catch {
                    
//                    self.backgroundBlurView.isHidden = true
                    
                    
                    
                    print(error.localizedDescription)
                }
                
                
                
                
                
                
            }else{
                
                
                //                self.blurView.isHidden = true
                
            }
            
        } catch {
            
            
            print("Error with request: \(error)")
        }
        
        
    }
   
    
    var timeStamp = ""

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NotificationCenterCollectionViewCell
        
        
        if objects.count == indexPath.row{
            
            
            if self.isLoadingOldPosts == false {
                
                self.loadMoreNotifications()
                
                
                
            }
            
            
        }
        
        cell.videoButton.isHidden = true
        cell.addButton.addTarget(self, action: #selector(handleAddUserTapped), for: .touchUpInside)
        
        let object =  self.objects[indexPath.row]
        
        if object.object(forKey: "notified") as? Bool == false {
            
            cell.backgroundColor = UIColor.groupTableViewBackground

        }else{
            
            cell.backgroundColor = UIColor.white

            
        }
        
      
        
        
        if let responder = object.object(forKey: "responder") as? BmobUser, let profileImageFile = responder.object(forKey: "profileImageFile") as? BmobFile {
            
            
            if object.object(forKey: "addRequest") as? Bool == true {
                
                cell.addButton.isHidden = false
                cell.PostImageView.isHidden = true
                cell.videoButton.isHidden = true
                cell.statusTextView.isHidden = true
                
                if self.friendsId.contains(responder.objectId) {
                    
                    cell.PostImageView.isHidden = true

                    
                    cell.addButton.setTitle("Added", for: .normal)
                }else{
                    
                    cell.addButton.setTitle("Add", for: .normal)
                    
                }
                
           
                
            }else if object.object(forKey: "addPoints") as? Bool == true{
                
                
                cell.addButton.isHidden = false
                cell.PostImageView.isHidden = true
                cell.videoButton.isHidden = true
                cell.statusTextView.isHidden = true

                
                if object.object(forKey: "pointsAccepted") as? Bool == true{
                    cell.PostImageView.isHidden = true

                    
                    cell.addButton.setTitle("Accepted", for: .normal)
                    
                }else{
                    cell.PostImageView.isHidden = true

                    
                    cell.addButton.setTitle("Accept", for: .normal)
                    
                }
                
                
            }else{
                
                cell.addButton.isHidden = true
                cell.PostImageView.isHidden = true
                cell.statusTextView.isHidden = true
                
                
                
            }
            
            cell.profileImage.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
          
           
    
        
        if let notificationReason = object.object(forKey: "notificationReason") as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy, EEE h:mm a"
            let stringFromDate = dateFormatter.string(from: object.createdAt as Date)
            
            let diffDateComponents = Calendar.current.dateComponents([.day, .hour , .minute], from: (object.createdAt as Date), to: NSDate() as Date)
            
            
            let days = diffDateComponents.day
            let dateByMins = diffDateComponents.minute
            let hourHand = diffDateComponents.hour
            
            
            
            if let day = days ,let hour = hourHand, let mins = dateByMins{
                
                if day == 0 {
                    
                    switch hour {
                        
                    case 0:
                        
                        if mins == 0 {
                            
                            cell.timeStampLabel.text = "Now"
                            
                            
                        }else if mins == 1{
                            
                            
                            cell.timeStampLabel.text  = "1 min ago"
                            
                        }else{
                            
                            cell.timeStampLabel.text  = "\(mins) mins ago"
                            
                            
                        }
                        
                    case 1:
                        
                        cell.timeStampLabel.text  = "1 hour ago"
                        
                        
                    default:
                        
                        cell.timeStampLabel.text  = "\(hour) hours ago"
                    }
                    
                    
                    
                }else if day >= 1 {
                    
                    cell.timeStampLabel.text  = stringFromDate
                    
                }
                
            }
            
            
            let attributedMutableText = NSMutableAttributedString(string: responder.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName: MessagesCollectionViewCell.blueColor])
            
            let atrributedReasonText = NSAttributedString(string: "\n\(notificationReason)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.black])
            attributedMutableText.append(atrributedReasonText)
            

            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
            
            cell.notificationLabel.attributedText = attributedMutableText
            
        }
        
        
        }
        
        if let postId = object.object(forKey: "postId") as? String {
          
            let query = BmobQuery(className: "Trends")
            query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
            query?.getObjectInBackground(withId: postId, block: { (Post, error) in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        if let imageFile = Post?.object(forKey: "imageFile") as? BmobFile {
                            
                            cell.PostImageView.isHidden = false
                            
                            cell.PostImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                            
                            cell.videoButton.isHidden = true
                            cell.statusTextView.isHidden = true
                            cell.PostImageView.isHidden = false
                            
                            
                            
                            
                        }else{
                            
                            cell.PostImageView.isHidden = true
                            
                        }
                        
                        if let imageFile = Post?.object(forKey: "videoPreviewFile") as? BmobFile {
                            
                            cell.PostImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                            
                            cell.videoButton.isHidden = false
                            cell.PostImageView.isHidden = false
                            cell.statusTextView.isHidden = true
                            
                            
                        }else{
                            
                            cell.videoButton.isHidden = true
                            //                            cell.PostImageView.isHidden = true
                            
                            
                        }
                        
                        if let text = Post?.object(forKey: "statusText") as? String{
                            
                            cell.statusTextView.text = text
                            cell.statusTextView.isHidden = false
                            cell.videoButton.isHidden = true
                            cell.PostImageView.isHidden = true
                            
                            
                            
                            
                        }else{
                            
                            cell.statusTextView.isHidden = true
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }else{
                    
                    
                }
            })
            
            
            //////ends here
            
            if let reason =  object.object(forKey: "awardedPoints") as? Bool {
                
                if reason == true {
                    
                    let query = BmobQuery(className: "Contest")
                    query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                    query?.getObjectInBackground(withId: postId, block: { (receivedObject, error) in
                        if error == nil {
                            if let imageFile = receivedObject?.object(forKey: "contestImageFile") as? BmobFile {
                                
                            cell.PostImageView.isHidden = false
                                
                            cell.PostImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                              
                                
                                
                            }
                            
                            
                            
                        }else{
                            
                            print(error?.localizedDescription as Any)
  
                            
                        }
                    })
                    
                
                    
                }
                
                
            }
            
            
            
        }
        
      
      
        
        self.updateNotificationInBackend(cell: cell, object: object)
    
        return cell
    }
    
    func updateNotificationInBackend(cell: NotificationCenterCollectionViewCell, object: BmobObject){
        
        let query = BmobQuery(className: "NotificationCenter")
        query?.getObjectInBackground(withId: object.objectId, block: { (receivedObject, error) in
            if error == nil {
                
                receivedObject?.setObject(true, forKey: "notified")
                receivedObject?.updateInBackground(resultBlock: { (success, error) in
                    if success{
                        
                        print("notified update")
                    }
                })
                
               
                
            }
        })
        
        
    }
    
    //            notify?.setObject(false, forKey: "notified")

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectetedItem = self.objects[indexPath.item]
        
        if selectetedItem.object(forKey: "addRequest") as? Bool == true {
            
            return
        }
        
        
        if selectetedItem.object(forKey: "awardedPoints") as? Bool == true {
            
            return
        }
        
        
        
        if selectetedItem.object(forKey: "addPoints") as? Bool == true {
            
            return
        }
        
        if selectetedItem.object(forKey: "userLikedIt") as? Bool == true {
            
            if let postId = selectetedItem.object(forKey: "postId") as? String {
                
                let likedUsersVC = LikedUsersTableViewController()
               likedUsersVC.postId = postId
                self.navigationController?.pushViewController(likedUsersVC, animated: true)

            }

            
            
            
        }else{
            
            var captionTextHeight = 0
            var videoCaptionHeight = 0
            
            let detailsVC = NotifcationDetailsTableVController()
            detailsVC.incomingObject = selectetedItem
            detailsVC.hidesBottomBarWhenPushed = true

            if let userWhoCommented = selectetedItem.object(forKey: "responder") as? BmobUser {
                
            detailsVC.userWhoCommented = userWhoCommented
            
            }
            
            if let imageHeight = selectetedItem.object(forKey: "imageHeight") as? Int, let imageWidth =  selectetedItem.object(forKey: "imageWidth") as? Int {
                
                let height = CGFloat(imageHeight) / CGFloat(imageWidth) * CGFloat(self.view.frame.width)
                
                if let textH = selectetedItem.object(forKey: "captionTextHeight") as? Int {
                    
                    captionTextHeight = textH + 10 + 5
                    
                }
                
                detailsVC.incomingHeaderViewHeight = height + 70 + CGFloat(captionTextHeight)
                self.navigationController?.pushViewController(detailsVC, animated: true)

                return 
                
            }
            
            if let statusText = selectetedItem.object(forKey: "statusTextHeight") as? Int {
                
                detailsVC.incomingHeaderViewHeight = CGFloat(statusText) + 125
                self.navigationController?.pushViewController(detailsVC, animated: true)
                
                return

                
            }
            
            if let videoFileHeight = selectetedItem.object(forKey: "videoFileHeight") as? Int {
                print(videoFileHeight)
                if let videoCaptionTextHeight = selectetedItem.object(forKey: "videoCaptionText") as? Int {
                    
                    videoCaptionHeight = videoCaptionTextHeight + 15
                }
                detailsVC.incomingHeaderViewHeight = 300 + 80 + CGFloat(videoCaptionHeight)
                self.navigationController?.pushViewController(detailsVC, animated: true)
                
                

                
            }
            
            
            
        }
        
    
        
    }
    
    
//    if let imageHeight = Post?.object(forKey: "imageHeight") as? Int {
//        
//        notify?.setObject(imageHeight, forKey: "imageHeight")
//        
//    }
//    
//    if let imageWidth = Post?.object(forKey: "imageWidth") as? Int {
//        
//        notify?.setObject(imageWidth, forKey: "imageWidth")
//        
//    }
//    
//    if let statusText = Post?.object(forKey: "statusText") as? String {
//        
//        let textHeight = Int(self.estimatedRect(text: statusText).height)
//        notify?.setObject(textHeight, forKey: "statusTextHeight")
//        
//    }
//    
//    if let captionText = Post?.object(forKey: "captionText") as? String {
//        
//        let textHeight = Int(self.estimatedRect(text: captionText).height)
//        notify?.setObject(textHeight, forKey: "captionTextHeight")
//        
//    }
//    
//    if let videoCaptionText = Post?.object(forKey: "videoCaptionText") as? String {
//        
//        let videoCaptionText = Int(self.estimatedRect(text: videoCaptionText).height)
//        notify?.setObject(videoCaptionText, forKey: "videoCaptionText")
//        
//    }

 

}
