//
//  ResultsCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 21/02/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData


class ResultsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    var filteredUsers = [Contacts]()

    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()


    var motherView: ChatsCollectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView?.backgroundColor = .white

        // Register cell classes
      self.collectionView!.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ResultsCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ResultsCollectionViewCell
        cell.backgroundColor = UIColor.white
        
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCollectionViewCell
        cell.backgroundColor = UIColor.white

        let newContact = self.filteredUsers[indexPath.item]
        
        let numberOfNotifications = newContact.numberOfNotifications
        
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
        
        
        
        if let username = newContact.username {
            
            cell.usernameLabel.text = username
        }
        
        if let profileImageData = newContact.profileImageData {
            
            let image = UIImage(data: profileImageData as Data)
            cell.profileImageView.image = image
            
        }
        
        if let roomId = newContact.roomId {
            
            self.fetchLastMessage(roomId: roomId, cell: cell, objectId: newContact.objectId!)
            
        }
    
        // Configure the cell
    
        return cell
    }
    
    func fetchLastMessage(roomId: String , cell: ResultsCollectionViewCell, objectId: String){
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ResultsCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        
        let selectedUser = self.filteredUsers[indexPath.item]
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
                    
                    
                    
                    if let cell = collectionView?.cellForItem(at: indexPath) as? ResultsCollectionViewCell {
                        
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
                
                self.motherView?.navigationController?.pushViewController(messagesVC, animated: true)
                
                
            }else{
                
                self.motherView?.navigationController?.pushViewController(messagesVC, animated: true)
                
                
            }
            
        }catch{}
        
    }



  

}
