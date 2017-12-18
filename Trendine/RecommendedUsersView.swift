//
//  RecommendedUsersView.swift
//  Trendin
//
//  Created by Rockson on 10/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import MessageUI


class RecommendedUsersView: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, MFMessageComposeViewControllerDelegate {
    
    var contacts: [CNContact] = []
    var contactStore = CNContactStore()
    var allPhoneNumbers = [String]()
    var matchedUsers = [BmobUser]()
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    var matchedContacts = [BmobUser]()
    
    var incomingVC: ContactTableViewController?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let cl = UICollectionView(frame: rect, collectionViewLayout: layout)
        cl.backgroundColor = UIColor.black
        cl.delegate = self
        cl.dataSource = self
        cl.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        return cl
        
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
    
    
    let identifier = "cell"
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        
        collectionView.register(RecommendedUsersViewCell.self, forCellWithReuseIdentifier: identifier)
        setUpViews()
        self.loadContacts()
        
        displayActivityInProgressView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func displayActivityInProgressView(){
        
        
        if let motherView = UIApplication.shared.keyWindow {
            
            motherView.addSubview(backgroundBlurView)
            
            
            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            backgroundBlurView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
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
            
            self.backgroundBlurView.isHidden = true
            
        }
        
        
    }
    
    func setUpViews(){
        
        addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    
    func loadContacts(){
       self.contacts.removeAll(keepingCapacity: true)
        
        
        DispatchQueue.global(qos: .background).async {
            
            
            AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
                if accessGranted {
                    
                    let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor])
                    
                    
                    do{
                        try self.contactStore.enumerateContacts(with: fetchRequest) { (contact, status) -> Void in
                            
                            fetchRequest.unifyResults = true
                            
                            
                            let phoneContacts = contact.phoneNumbers
                            let giveNames = contact.givenName
                            
                            if phoneContacts.count > 0 && giveNames != "" {
                                
                                for eachContact in phoneContacts{
                                    
                                    if  eachContact.label == CNLabelPhoneNumberMobile {
                                        
                                        self.contacts.append(contact)
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                          
                            
                         

                            
                        }
                       ///////////////Reload here...
                        
                        
                        if self.contacts.count == 0 {
                            
                            self.loadContactsFromCoreData()
                            
                        }else{
                            
                            DispatchQueue.main.async {
                                
                                self.collectionView.reloadData()
                                
                            }
                            
                        }
                        
                        
//                       
                        
                    } catch {
                        print("Error \(error)")
                    }
                    
                    
                    
                    
                }
                
            })
  
          
        }


        
    }
    


        

    var users = [Contacts]()
    
    func loadContactsFromCoreData(){
        
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let searchResults = try self.moc.fetch(request)
            
            if searchResults.count > 0  {
                self.users.removeAll(keepingCapacity: true)
                
                
                for contact in searchResults {
                    
                    self.users.append(contact)
                    
                }
                
                DispatchQueue.main.async {
                    
                self.collectionView.reloadData()
   
                    
                }
            
            
                
            }
            
        }catch {
            print("Error with request: \(error)")
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.contacts.count == 0 {
         
            return self.users.count
            
        }else{
            
            return self.contacts.count
   
            
        }
    }
    
    
    func handlePopToTrends(sender: UIButton){
      let points = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: points){
            
            let selectedUser = self.users[indexPath.row].objectId
            
            if let contactVC = self.incomingVC{
                
                let layout = UICollectionViewFlowLayout()
                let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
                myMomentsVC.incomingUser = selectedUser
                myMomentsVC.hidesBottomBarWhenPushed = true
                contactVC.navigationController?.pushViewController(myMomentsVC, animated: true)
                
                
            }
           
            
        }
        
     
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RecommendedUsersViewCell
        cell.backgroundColor = UIColor.clear
        
        if self.contacts.count == 0 {
            
            let contact = self.users[indexPath.item]
            
            let query = BmobQuery(className: "_User")
            query?.whereKey("objectId", equalTo: contact.objectId)
            query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
            query?.findObjectsInBackground({ (users, error) in
                if error == nil {
                    if (users?.count)! > 0 {
                        
                        for user in users! {
                            
                            if let newUser = user as? BmobUser {
                                
                                DispatchQueue.main.async {
                                    
                                    cell.usernameLabel.text = newUser.username
                                    
                                    if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
                                        
                                         cell.BackgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                        
                                        cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
            })
            
            cell.AddUserButton.setTitle("Friends", for: .normal)
            cell.AddUserButton.addTarget(self, action: #selector(handlePopToTrends), for: .touchUpInside)
  
            
            
        }else{
            
            let user = self.contacts[indexPath.item].givenName
            cell.usernameLabel.text = user
            
            let contact = self.contacts[indexPath.row].phoneNumbers[0]
            if  contact.label == CNLabelPhoneNumberMobile {
                
                let finalNumber = (contact.value ).stringValue
                let set = NSCharacterSet.decimalDigits.inverted
                let newNumber = finalNumber.components(separatedBy: set).joined(separator: "")
                
                self.queryForUserWithThisPhoneNumber(cell: cell, phoneNumber: newNumber)
                
                
            }
            
            
            
            
            cell.AddUserButton.addTarget(self, action: #selector(handleTappedUser), for: .touchUpInside)
            
            
        }
        
       
        
        return cell
    }
    
    func queryForUserWithThisPhoneNumber(cell: RecommendedUsersViewCell, phoneNumber: String){
        
        let userQuery = BmobUser.query()
        userQuery?.whereKey("phoneNumber", equalTo: phoneNumber)
        userQuery?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        userQuery?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if (results?.count)! > 0 {
                    
                    for result in results!{
                        
                        DispatchQueue.main.async {
                            
                            if let foundUser = (result) as? BmobUser {
                            
                                
                                let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                                fetch.predicate = NSPredicate(format: "objectId == %@", foundUser.objectId)
                                fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
                                
                                
                                do {
                                    
                                    let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
                                    
                                    if results.count ==  0 {
                                        
                                        
                                        cell.AddUserButton.setTitle("Add", for: .normal)
                                        
                                    }else if results.count > 0 {
                                        
                                        cell.AddUserButton.setTitle("Friends", for: .normal)
                                        
                                        
                                    }
                                    
                                }catch{
                                    
                                    print(error)
                                }
                                
                                
                                cell.usernameLabel.text = foundUser.username
                                
                                if let profileImageFile = foundUser.object(forKey: "profileImageFile") as? BmobFile, let url = profileImageFile.url {
                                    
                                    cell.profileImageView.sd_setImage(with: NSURL(string: url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                    cell.BackgroundImageView.sd_setImage(with: NSURL(string: url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    cell.AddUserButton.backgroundColor = MessagesCollectionViewCell.blueColor

                    
                }else{
                    
                    //phone Number didn't match any User
//                    cell.AddUserButton.backgroundColor = .green
                    cell.AddUserButton.setTitle("Invite", for: .normal)
                    
                    
                }
                
            }else{
                
                print(error?.localizedDescription as Any)
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
                    
                    print("found nothing...")
                    
                    let query = BmobQuery(className: "Room")
                    let array2 = [["user1Id": selectedItem.objectId],  ["user2Id": currentUser?.objectId]]
                    query?.addTheConstraintByAndOperation(with: array2)
                    query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                    query?.findObjectsInBackground({ (secondResults, error) in
                        if error == nil {
                            
                            if secondResults?.count == 0 {
                                
                                self.saveToRoom(selectedItem: selectedItem, sender: sender)
                                print("found nothing again...")

                                
                            }else if secondResults?.count == 1 {
                                
                                self.savedContactToCoreData(friend: selectedItem, room: secondResults?.first as! BmobObject, sender: sender)
                                print("found one more...")

                                
                            }
                            
                            
                        }else{
                            
                         
                            self.backgroundBlurView.isHidden = true

                            print(error?.localizedDescription as Any)
                            
                        }
                    })
                    
                    
                    
                }else if results?.count == 1{
                    
                    //there's room
                    
                    print("found one...")

                    self.savedContactToCoreData(friend: selectedItem, room: results?.first as! BmobObject, sender: sender)
                    
                    
                }
                
            }else{
                
                print(error?.localizedDescription as Any)
                self.backgroundBlurView.isHidden = true

            }
        })
        
    }
    
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
                
                self.savedContactToCoreData(friend: selectedItem, room: room!, sender: sender)
                
            }else{
                
                self.backgroundBlurView.isHidden = true

            }
        })
        
        
        
    }
    
    func handleTappedUser(sender: UIButton){
        
        
        let point  = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
           
            let selectedContact = self.contacts[indexPath.item]
            let phoneNumber = self.processPhoneNumber(contact: selectedContact)

        
            if sender.currentTitle == "Add"{
            
                self.backgroundBlurView.isHidden = false
                self.displayText.text = "Adding"

             
                self.findUserWithTappedPhoneNumber(phoneNumber: phoneNumber, sender: sender)
                
                
            }else if sender.currentTitle == "Invite"{
                
                if MFMessageComposeViewController.canSendText() {
                    
                let controller = MFMessageComposeViewController()
                let url = "https://itunes.apple.com/us/app/trendine/id1186640364?ls=1&mt=8#"
                controller.body = "Hey, download this cool Trendine App and vote for me in the WorldWide Photography Contest to enhance my chances of winning the amazing cash Prize!  link: \(url)"
                controller.recipients = [phoneNumber]
                controller.messageComposeDelegate = self
                self.incomingVC?.present(controller, animated: true, completion: nil)
                        
                        
                        
                }
                
                
            //  Activity view for sharing
                
//                @IBAction func sendText(sender: UIButton) {
//                    if (MFMessageComposeViewController.canSendText()) {
//                        let controller = MFMessageComposeViewController()
//                        controller.body = "Message Body"
//                        controller.recipients = [phoneNumber.text]
//                        controller.messageComposeDelegate = self
//                        self.presentViewController(controller, animated: true, completion: nil)
//                    }
//                }
//                
//                func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
//                    //... handle sms screen actions
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
                
                
                
            }
        
        }
        
    
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.incomingVC?.dismiss(animated: true, completion: nil)
    }
    
    func findUserWithTappedPhoneNumber(phoneNumber: String, sender: UIButton){
        
        let query = BmobUser.query()
        query?.whereKey("phoneNumber", equalTo: phoneNumber)
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                if (results?.count)! > 0 {
                    
                    
                    for result in results!{
                        
                        let user = result as! BmobUser
                        let relation = BmobRelation()
                        let currentUser = BmobUser.current()
                        
                        if user.objectId != "2d9ff2a1f3" && user.objectId != "d26d792078" {
                            
                          
                            relation.add(user)
                            currentUser?.add(relation, forKey: "friends")
                            currentUser?.updateInBackground(resultBlock: { (success, error) in
                                if error == nil {
                                    
                                    print("added")
                                    
                                    let installationQuery = BmobInstallation.query()
                                    installationQuery?.whereKey("userId", equalTo: user.objectId)
                                    
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
                                    
                                    self.prepareToSaveRoom(selectedItem: result as! BmobUser, sender: sender)
                                    
                                    
                                }else {
                                    
                                    self.backgroundBlurView.isHidden = true
                                    
                                    print(error?.localizedDescription as Any)
                                }
                            })
                            
                            
                            
                            
                            
                        }else{
                            
                            self.backgroundBlurView.isHidden = true
                            print("its special")
 
                            
                        }
                        
                       
                    }
                    
                }else{
                    
                    self.backgroundBlurView.isHidden = true
   
                    
                }
                
            }else{
                
                self.backgroundBlurView.isHidden = true

                
                print(error?.localizedDescription as  Any)
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
                
                if let newRoom = room.object(forKey: "newRoom") as? Bool {
                    
                    if newRoom == false  {
                        
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                        
                        entity.createdAt = room.createdAt as NSDate?
                        entity.objectId = friend.objectId
                        entity.lastUpdate = NSDate()
                        entity.newOrOld = true
                        entity.roomId = room.objectId
                        
                        do {
                            
                            try moc.save()
                            
                            self.displayText.text = "Added"
                            self.backgroundBlurView.isHidden = true
                            sender.setTitle("Added", for: .normal)

                            
                            
                            print("contact saved successfully")
                            
                            let notify = BmobObject(className: "NotificationCenter")
                            notify?.setObject(friend, forKey: "userToBeNotified")
                            notify?.setObject("Added you", forKey: "notificationReason")
                            notify?.setObject(friend.objectId, forKey: "postId")
                            notify?.setObject(false, forKey: "notified")
                            notify?.setObject(BmobUser.current(), forKey: "responder")
                            notify?.setObject(false, forKey: "userLikedIt")
                            notify?.setObject(true, forKey: "addRequest")
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
                        
                        entity2.createdAt = room.createdAt as NSDate?
                        entity2.objectId = friend.objectId
                        entity2.lastUpdate = NSDate()
                        entity2.newOrOld = false
                        entity2.roomId = room.objectId
                        
                        do {
                            
                            try moc.save()
                            
                            sender.setTitle("Added", for: .normal)
                            
                            self.displayText.text = "Added"
                            self.backgroundBlurView.isHidden = true
                            
                            print("contact saved successfully")
                            
                            let notify = BmobObject(className: "NotificationCenter")
                            notify?.setObject(friend, forKey: "userToBeNotified")
                            notify?.setObject("Added you", forKey: "notificationReason")
                            notify?.setObject(friend.objectId, forKey: "postId")
                            notify?.setObject(false, forKey: "notified")
                            notify?.setObject(BmobUser.current(), forKey: "responder")
                            notify?.setObject(false, forKey: "userLikedIt")
                            notify?.setObject(true, forKey: "addRequest")
                            notify?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("notified!!!")
                                }
                            })
                            
                            
                        }catch {
                            
                            self.backgroundBlurView.isHidden = true
                            
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                }
                
                
          
                
            }else{
                //User is a friend already
                self.backgroundBlurView.isHidden = true
  
                
            }
            
        } catch {
            self.backgroundBlurView.isHidden = true

            print("Error with request: \(error)")
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightAndWidth: CGFloat = 90
        
        return CGSize(width: heightAndWidth, height: heightAndWidth)
    }
    
    
    func processPhoneNumber(contact: CNContact)-> String{
        
      let phoneNumbers = contact.phoneNumbers[0]
      let finalNumber = (phoneNumbers.value ).stringValue
      let set = NSCharacterSet.decimalDigits.inverted
      let newNumber = finalNumber.components(separatedBy: set).joined(separator: "")
       return newNumber
        
    }
    
}
