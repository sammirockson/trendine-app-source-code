//
//  SettingsTableViewController.swift
//  Trendin
//
//  Created by Rockson on 10/2/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData


class SettingsTableViewController: UITableViewController {
    
    let iconTitles = [["Public Trends", "Around Me", "My Trends"],["Stickers"], ["Settings"]]
    let iconImages = [["globe","NearMe","myTrendsIcon"] , ["stickers"] , ["settings"]]
    
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    

//    
    var numberOfNotifications: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        

        
        navigationItem.title = "More"
        
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

       
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
        
        if allContactsArray.count > 0 {
            
            for contact in allContactsArray{
                
                if let roomId = contact.roomId, let objectId = contact.objectId{
                    
                    
                    self.loadMessagesFromBackend(roomId: roomId, objectId: objectId)
                    
                    
                    
                }
                
            }
            
            
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterNotifications), name: NSNotification.Name("reloadMessages"), object: nil)
        
//        self.loadNumberOfNotification()
        self.loadNotificationFromBackend()
        
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section  == 0 {
            
            return 3
            
        }else if section  == 1 {
            
            return 1
            
        }else if section == 2 {
        
        return 1
            
       }else{
            
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SettingsTableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator


        let title  = self.iconTitles[indexPath.section][indexPath.row]
        
        if title == "Notifications" {
            
            if let count = self.tabBarItem.badgeValue{
                
                let countInt = Int(count)
                if countInt! > 0 {
                    
                    cell.numberOfNotificationsImageView.isHidden = false
                    cell.countNotificationLabel.isHidden = false
                    cell.countNotificationLabel.text = count
                    
                    
                }else{
                    
                    
                    cell.numberOfNotificationsImageView.isHidden = true
                    cell.countNotificationLabel.isHidden = true
                    
                }
                
                
            }else{
                
                cell.numberOfNotificationsImageView.isHidden = true
                cell.countNotificationLabel.isHidden = true
                
            }
  
            
            
        }else{
            
           
            cell.numberOfNotificationsImageView.isHidden = true
            cell.countNotificationLabel.isHidden = true
            
        }
        
        
      

        
        
        // Configure the cell...
        
        cell.settingsLabel.text = title
        
        let imageName = self.iconImages[indexPath.section][indexPath.row]
        cell.iConImage.image = UIImage(named: imageName)
      
        
  


        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = self.iconTitles[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        
        
        if selectedTitle == "Stickers" {
            
            let layout = UICollectionViewFlowLayout()
            let StickersVC = StickersCollectionViewController(collectionViewLayout: layout)
            StickersVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(StickersVC, animated: true)
        }
        
        if selectedTitle == "Settings" {
            
            let aboutUsVC = SettingsPageTableViewController(style: UITableViewStyle.grouped)
            aboutUsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
            
        }
        
        
        if selectedTitle == "Around Me" {
            
            let layout = UICollectionViewFlowLayout()
            let nearByVC = NearByCollectionViewController(collectionViewLayout: layout)
            nearByVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nearByVC, animated: true)
            
        }
        
        
        if selectedTitle == "My Trends" {
            
            let layout = UICollectionViewFlowLayout()
            let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
            myMomentsVC.incomingUser = BmobUser.current().objectId
            myMomentsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myMomentsVC, animated: true)
            
        }
        
        
        if selectedTitle == "Public Trends" {
            
            let layout = UICollectionViewFlowLayout()
            let publicVC = PublicTrendsCollectionViewController(collectionViewLayout: layout)
            publicVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(publicVC, animated: true)
            
        }

        
        
    }


}
