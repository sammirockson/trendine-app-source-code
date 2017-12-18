//
//  TrendinCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Contacts
import CoreData

var allContactsArray = [Contacts]()

class TrendinCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    private let reuseIdentifier = "Cell"
    private let headerViewIdentifier = "headerId"
    private let loadMoreCellId = "loadMoreCellId"
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var refreshTrends: Bool = true
    
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    
    
    let loadingObjectsView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let loadingObjectsContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let loadingObjectsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.textAlignment = .left
        return label
        
    }()
    
    let loadingObjectsActivityIndicator: UIActivityIndicatorView = {
       
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        
    }()
    
  
    
    lazy var refresh: UIRefreshControl = {
       let RefreshC = UIRefreshControl()
        RefreshC.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return RefreshC
        
    }()
    
    
    let slideDownNotificationMenu: UIView = {
       let sView = UIView()
        sView.backgroundColor = .black
        sView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        return sView
        
    }()
    
    let itsPostingLabel: UILabel = {
       let lb = UILabel()
        lb.text = "Posting..."
        lb.textColor = .white
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
        
    }()
    
    let progressView: UIProgressView = {
       let pView = UIProgressView()
        pView.translatesAutoresizingMaskIntoConstraints = false
        return pView
        
    }()
    
    let postImageView: UIImageView = {
       let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.image = UIImage(named: "personplaceholder")
        im.translatesAutoresizingMaskIntoConstraints = false
        im.layer.cornerRadius = 20
        im.clipsToBounds = true
        return im
    
    }()
    
    let notificationView: UIView = {
        let sView = UIView()
        sView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        sView.layer.cornerRadius = 16
        sView.clipsToBounds = true
        return sView
        
    }()
    
    lazy var notificationButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("10 Notifications", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleNotificationButtonTapped), for: .touchUpInside)
        return btn
        
    }()
    
    
    lazy var verifyEmailView: UIView = {
        let Vview = UIView()
        Vview.translatesAutoresizingMaskIntoConstraints = false
        Vview.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        Vview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return Vview
        
    }()
    
    lazy var verifyButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = MessagesCollectionViewCell.blueColor
        btn.setTitle("Verify", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(handleVerifyEmailAccount), for: .touchUpInside    )
        return btn
        
    }()
    
    let emailTextField: UITextField = {
       let tf = UITextField()
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter email"
        tf.backgroundColor = UIColor.white
        tf.textAlignment = .center
        tf.layer.cornerRadius = 4
        tf.clipsToBounds = true
        return tf
        
    }()
    
    
    let displayText: UILabel = {
      let label = UILabel()
       label.text = "Post a new trend!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "newOrOld == %@", NSNumber(booleanLiteral: true))
        request.sortDescriptors =  [NSSortDescriptor(key: "lastUpdate", ascending: false)]
        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
    }()

    var isLoadingOldPosts: Bool = false
    
   var objects = [TrendinObject]()
    var slideTimer = Timer()

    var rightBarButton: UIBarButtonItem?
    var rightButton: UIButton?
    
//    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            try self.fetchedResultsControler.performFetch()
            
        }catch{}
        


        
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange), name: NSNotification.Name(ReachabilityDidChangeNotificationName), object: nil)
//        
//        _ = reachability?.startNotifier()
        
        let currentUser = BmobUser.current()
        if let deviceTokenData = UserDefaults.standard.object(forKey: "deviceTokenData") as? Data {
            
            let installation = BmobInstallation()
            installation.setDeviceTokenFrom(deviceTokenData)
            installation.setObject(currentUser, forKey: "user")
            installation.setObject(currentUser?.objectId, forKey: "userId")
            installation.saveInBackground(resultBlock: { (success, error) in
                if success{
                    
                    print("installation saved")
                    
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
                
                
            })
            
            
            
        }
        
    

        self.collectionView?.addSubview(refresh)
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(notificationView)
            notificationView.addSubview(notificationButton)
            
            
            notificationButton.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 14).isActive = true
            notificationButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor).isActive = true
            notificationButton.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor).isActive = true
            notificationButton.heightAnchor.constraint(equalTo: notificationView.heightAnchor).isActive = true
            
            window.addSubview(slideDownNotificationMenu)
            slideDownNotificationMenu.addSubview(postImageView)
            slideDownNotificationMenu.addSubview(progressView)
            slideDownNotificationMenu.addSubview(itsPostingLabel)
            
            itsPostingLabel.leftAnchor.constraint(equalTo: slideDownNotificationMenu.leftAnchor).isActive = true
            itsPostingLabel.rightAnchor.constraint(equalTo: slideDownNotificationMenu.rightAnchor).isActive = true
            itsPostingLabel.bottomAnchor.constraint(equalTo: slideDownNotificationMenu.bottomAnchor, constant: -4).isActive = true
            itsPostingLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
            
            progressView.leftAnchor.constraint(equalTo: postImageView.rightAnchor, constant: 8).isActive = true
            progressView.rightAnchor.constraint(equalTo: slideDownNotificationMenu.rightAnchor, constant: -5).isActive = true
            progressView.centerYAnchor.constraint(equalTo: slideDownNotificationMenu.centerYAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
            
            postImageView.leftAnchor.constraint(equalTo: slideDownNotificationMenu.leftAnchor, constant: 8).isActive = true
            postImageView.centerYAnchor.constraint(equalTo: slideDownNotificationMenu.centerYAnchor).isActive = true
            postImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            postImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            slideDownNotificationMenu.frame = CGRect(x: 0, y: -80, width: window.frame.width, height: 80)
            
            let width = self.view.frame.width / 2
            notificationView.frame = CGRect(x: -width, y: 80, width: width, height: 35)
            
            window.addSubview(verifyEmailView)
            
            verifyEmailView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            verifyEmailView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
            verifyEmailView.widthAnchor.constraint(equalTo: window.widthAnchor).isActive = true
            verifyEmailView.heightAnchor.constraint(equalTo: window.heightAnchor).isActive = true
            
            verifyEmailView.addSubview(verifyButton)
            
            verifyButton.centerXAnchor.constraint(equalTo: verifyEmailView.centerXAnchor).isActive = true
            verifyButton.centerYAnchor.constraint(equalTo: verifyEmailView.centerYAnchor).isActive = true
            verifyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            verifyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            verifyEmailView.addSubview(emailTextField)
            
            
            emailTextField.bottomAnchor.constraint(equalTo: verifyButton.topAnchor,constant: -15).isActive = true
            emailTextField.centerXAnchor.constraint(equalTo: verifyEmailView.centerXAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalTo: verifyEmailView.widthAnchor, constant: -40).isActive = true
            emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            self.verifyEmailView.isHidden = true
            
           

            
        }
        
    
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.title = "Trending"

        // Register cell classes
        self.collectionView!.register(TrendinCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(LoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: loadMoreCellId)
        self.collectionView?.register(ContestHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)

        // Do any additional setup after loading the view.
        
//        rightBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleRightBarButton))
        
        
        let image = UIImage(named: "camera")
//        rightBarButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleRightBarButton))
        
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        rightButton?.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
        rightButton?.setBackgroundImage(image, for: .normal)
        rightBarButton = UIBarButtonItem(customView: rightButton!)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleLeftBarButton))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        self.view.addSubview(displayText)
        
        displayText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        displayText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        displayText.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        displayText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
//        self.loadData()

    }
    
    
//    func reachabilityDidChange(notification: Notification){
//        
//        
//        guard let r = reachability else { return }
//        if r.isReachable  {
//            //            view.backgroundColor = UIColor.green
//            
//            
//            //network...
//        } else {
//            
//            
//            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
//
//            //no network
//            //            view.backgroundColor = UIColor.red
//        }
//        
//    }
    
    
    func alert(reason: String){
        
        let alert = UIAlertController(title: "No Internet!!", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    func checkReachability() {
//        
//        guard let r = reachability else { return }
//        if r.isReachable  {
//            //            view.backgroundColor = UIColor.green
//            
//            
//            //network...
//        } else {
//            
//            
//            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
//            
//            //no network
//            //            view.backgroundColor = UIColor.red
//        }
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let queryUser = BmobUser.query()
        let loggedInUser = BmobUser.current()
        queryUser?.whereObjectKey("friends", relatedTo: loggedInUser)
        
        let query = BmobQuery(className: "Trends")
        query?.includeKey("poster")
        query?.order(byDescending: "createdAt")
        query?.whereKey("poster", matchesQuery: queryUser)
        query?.clearCachedResult()
        
        
        let alert = UIAlertController(title: "Memory full", message: "You are running out of space. Free up space.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
        
    }
    
    func dismissKeyboard(){
        
        self.view.endEditing(true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
     
        if let friends = fetchedResultsControler.sections?[0].objects as? [Contacts] {
            
            if friends.count > 0 {
                
                allContactsArray.removeAll(keepingCapacity: true)
                
                for friend in friends {
                    
                    allContactsArray.append(friend)
                    
                    self.loadMessagesFromBackend(roomId: friend.roomId!, objectId: friend.objectId!)
                    
                    
                }
                
                
            }
            
        }
        

        
//        fetchAndSaveNotifications()
        

//        self.checkReachability()
        
         NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterNotifications), name: NSNotification.Name("reloadMessages"), object: nil)
        
       
    
        self.requestAccessToPhoneContacts()
        
//        self.loadAgainWhenViewReappear()

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
    


    
    
    func saveNotifications(roomId: String, numberOfNotifications: Int){
        
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "roomId == %@", roomId)
        fetch.fetchLimit = 1
        
        
        do {
            
            let foundContacts = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
            if let contact = foundContacts.first {
                    
            let originalNumber = Int(contact.numberOfNotifications)
                contact.numberOfNotifications = Int32(Int(originalNumber + numberOfNotifications))
                    
                    do {
                        
                        try moc.save()
                        
                    }catch{
                        
                        
                    }
                    
                    
                
                }
           
        }catch{
            
            
            
        }
        
    }
    
    
//    func loadNumberOfNotification(){
//
//        self.fetchAndSaveNotifications()
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
//                            let customNotification  = self.tabBarController
//                            for item in  (customNotification?.tabBar.items!)! {
//                                
//                                if let title = item.title {
//                                    
//                                    if title == "Chats" {
//                                        
//                                        print(title)
//                                        
//                                        item.badgeValue = "\(counts)"
//                                        item.badgeColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
//                                        
//                                        
//                                    }
//                                }
//                                
//                            }
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
    
    func handleVerifyEmailAccount(){
        
        if let currentUser = BmobUser.current(), let email = self.emailTextField.text {
            
            currentUser.verifyEmailInBackground(withEmailAddress: email, block: { (success, error) in
                if success{
                    
                    UIView.animate(withDuration: 0.75, animations: {
                        
                        self.verifyEmailView.alpha = 0
                        
                    })
                    
                    
                }else{
                    
                   
                    
                }
            })
            
        }
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.refreshTrends == true {
            
            self.loadData()
            
            
        }else{
            
            self.refreshTrends = true
            
            
        }
        
//        self.fetchAndSaveNotifications()
//        self.loadNumberOfNotification()
        self.loadNotificationFromBackend()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
        NotificationCenter.default.removeObserver(self)
        
        UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            let width = self.view.frame.width / 2
            self.notificationView.frame = CGRect(x: -width, y: 80, width: width, height: 35)
            
        }, completion: nil)
        
        
        slideTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(slideLeftNotificationView), userInfo: nil, repeats: false)
        
    }
    
    
    func requestAccessToPhoneContacts(){
        
        DispatchQueue.global(qos: .background).async {
            
            
            AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
                if accessGranted {
                    
                    print("Access granted. Can load Contacts")
                }
                
            })
            
            
        }
        
        
        
    }
    
    func handleRefresh(){
        
//    self.loadAgainWhenViewReappear()
        
     self.loadData()
        
    }
    
    func slideLeftNotificationView(){
        
        UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            let width = self.view.frame.width / 2
            self.notificationView.frame = CGRect(x: -width, y: 80, width: width, height: 35)
            
        }, completion: nil)
        
     
    }
    
    
    func handleNotificationButtonTapped(){
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let notificationVC = NotificationCenterCollectionViewController(collectionViewLayout: layout)
        let navCC = UINavigationController(rootViewController: notificationVC)
        notificationVC.incomignVC = self
        self.present(navCC, animated: true, completion: nil)
        
    }

    
    
        func loadData(){
            
            print("loading data...")
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            self.refresh.beginRefreshing()
            
            let queryUser = BmobUser.query()
            let loggedInUser = BmobUser.current()
            queryUser?.whereObjectKey("friends", relatedTo: loggedInUser)

        
            let query = BmobQuery(className: "Trends")
            query?.includeKey("poster")
            query?.order(byDescending: "createdAt")
            query?.limit = 30
            query?.whereKey("poster", matchesQuery: queryUser)
            query?.findObjectsInBackground { (results, error) -> Void in
                if error == nil {
                    
                    self.refresh.endRefreshing()

                    if (results?.count)! > 0 {
                        
                        self.objects.removeAll(keepingCapacity: true)

                        for result in results! {
                            
                            
                        self.processRetrievedObjects(result: result as! BmobObject)
    
    
                        }
    
                        DispatchQueue.main.async {
                               
                        self.collectionView?.reloadData()

                        }
                        

    
                    }
                
                }else{
                    
//                 
//                    DispatchQueue.main.async {
//                        
//                        
//                        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
//                            
//                            self.loadingObjectsActivityIndicator.isHidden = true
//                            self.loadingObjectsView.alpha = 0
//                            
//                        }, completion: nil)
//                        
//                    }
                    
                }
            
            
            }
            
        }

    
    
    func processRetrievedObjects(result: BmobObject){
        
        let trendObject = TrendinObject()
        trendObject.createdAt = result.createdAt as NSDate?
        trendObject.objectId = result.objectId
        
        
        
        if let videoDuration = result.object(forKey: "videoDuration") as? Int {
            
            trendObject.videoDuration = videoDuration
        }
        
        
        
        if let videoCaptionText = result.object(forKey: "videoCaptionText") as? String {
            
            trendObject.videoCaptionText = videoCaptionText
        }
        
        if let statusText = result.object(forKey: "statusText") as? String {
            
            trendObject.statusText = statusText
        }
        
        if let numberOfLikes = result.object(forKey: "numberOfLikes") as? Int {
            
            trendObject.numberOfLikes = numberOfLikes
        }
        
        if let numberOfComments = result.object(forKey: "numberOfComments") as? Int {
            
            trendObject.numberOfComments = numberOfComments
        }
        
        if let likersArray = result.object(forKey: "likersArray") as? [String] {
            
            trendObject.likersArray = likersArray
        }
        
        if let videoCaptionText = result.object(forKey: "videoPreviewFile") as? String {
            
            trendObject.videoCaptionText = videoCaptionText
        }
        
        if let imageWidth = result.object(forKey: "imageWidth") as? Int {
            
            trendObject.imageWidth = imageWidth
        }
        
        if let imageHeight = result.object(forKey: "imageHeight") as? Int {
            
            trendObject.imageHeight = imageHeight
        }
        
        
        if let imageFile = result.object(forKey: "imageFile") as? BmobFile {
            
            trendObject.imageUrl = NSURL(string: imageFile.url)
        }
        
        if let videoPreviewFile = result.object(forKey: "videoPreviewFile") as? BmobFile {
            
            trendObject.videoPreviewImageUrl = NSURL(string: videoPreviewFile.url)
        }
        
        if let videoFile = result.object(forKey: "videoFile") as? BmobFile {
            
            trendObject.videoUrl = NSURL(string: videoFile.url)
        }
        
        if let user = result.object(forKey: "poster") as? BmobUser {
            
            trendObject.user = user
        }
        
        
        if let captionText = result.object(forKey: "captionText") as? String {
            
            trendObject.captionText = captionText
        }
        
        self.objects.append(trendObject)
//       self.objects.insert(trendObject, at: 0)
        
        
    }
    
    
    func processLoadMoreData(result: BmobObject){
        
        let trendObject = TrendinObject()
        trendObject.createdAt = result.createdAt as NSDate?
        trendObject.objectId = result.objectId
        
        
        
        if let videoDuration = result.object(forKey: "videoDuration") as? Int {
            
            trendObject.videoDuration = videoDuration
        }
        
        
        
        if let videoCaptionText = result.object(forKey: "videoCaptionText") as? String {
            
            trendObject.videoCaptionText = videoCaptionText
        }
        
        if let statusText = result.object(forKey: "statusText") as? String {
            
            trendObject.statusText = statusText
        }
        
        if let numberOfLikes = result.object(forKey: "numberOfLikes") as? Int {
            
            trendObject.numberOfLikes = numberOfLikes
        }
        
        if let numberOfComments = result.object(forKey: "numberOfComments") as? Int {
            
            trendObject.numberOfComments = numberOfComments
        }
        
        if let likersArray = result.object(forKey: "likersArray") as? [String] {
            
            trendObject.likersArray = likersArray
        }
        
        if let videoCaptionText = result.object(forKey: "videoPreviewFile") as? String {
            
            trendObject.videoCaptionText = videoCaptionText
        }
        
        if let imageWidth = result.object(forKey: "imageWidth") as? Int {
            
            trendObject.imageWidth = imageWidth
        }
        
        if let imageHeight = result.object(forKey: "imageHeight") as? Int {
            
            trendObject.imageHeight = imageHeight
        }
        
        
        if let imageFile = result.object(forKey: "imageFile") as? BmobFile {
            
            trendObject.imageUrl = NSURL(string: imageFile.url)
        }
        
        if let videoPreviewFile = result.object(forKey: "videoPreviewFile") as? BmobFile {
            
            trendObject.videoPreviewImageUrl = NSURL(string: videoPreviewFile.url)
        }
        
        if let videoFile = result.object(forKey: "videoFile") as? BmobFile {
            
            trendObject.videoUrl = NSURL(string: videoFile.url)
        }
        
        if let user = result.object(forKey: "poster") as? BmobUser {
            
            trendObject.user = user
        }
        
        
        if let captionText = result.object(forKey: "captionText") as? String {
            
            trendObject.captionText = captionText
        }
        
//        self.objects.append(trendObject)
        //       self.objects.insert(trendObject, at: 0)
        
        
    }

    func handleLeftBarButton(){
        
        let shareTextVC = PreviewSelectedImageViewController()
        shareTextVC.incomingTrendingVC = self
        shareTextVC.incomingUserIsForTextOnly = true
        let nav = UINavigationController(rootViewController: shareTextVC)
        self.present(nav, animated: true, completion: nil)
        
        
    }
    
    
    
   private func loadOlderObjects(){
        

    if let lastDate = self.objects.last?.createdAt {
        
        self.isLoadingOldPosts = true


        
        let queryUser = BmobUser.query()
        let loggedInUser = BmobObject(outDataWithClassName: "_User", objectId: BmobUser.current().objectId)
        queryUser?.whereObjectKey("friends", relatedTo: loggedInUser)
        
        
        print("loading old objects...")
        
        let query = BmobQuery(className: "Trends")
        query?.includeKey("poster")
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.whereKey("poster", matchesQuery: queryUser)
 
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringFromDate = dateForm.string(from: lastDate as Date)
            
            let condiction1 = ["createdAt":["$lt":["__type": "Date", "iso": stringFromDate]]]
            let array =  [condiction1]
            query?.addTheConstraintByAndOperation(with: array)
 
            query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
               print("loaded")
                
                self.isLoadingOldPosts = false

                
                if (results?.count)! > 0 {
                    
//                    self.objects.removeAll(keepingCapacity: true)
                    
                    for result in results! {
                        
                        
                        self.processRetrievedObjects(result: result as! BmobObject)
                        
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                        
                    }
                    
                    
                    
                }
                
                
            }else{
                
                self.isLoadingOldPosts = false

                print("there was an error \(error?.localizedDescription)")
            }
            
            
        }
        
     }
    
    }
    
    func handleRightBarButton(){
    
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            
                picker.sourceType = .photoLibrary
//                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Video Library", style: .default, handler: { (action) in
            
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.delegate = self
            picker.videoQuality = .typeMedium
            self.present(picker, animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        if let presenter = alert.popoverPresentationController {
            
            presenter.sourceView = self.rightButton
            presenter.sourceRect = (self.rightButton?.bounds)!

            
        }
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let previewImageVC = PreviewSelectedImageViewController()
            previewImageVC.incomingTrendingVC = self
        let navVC = UINavigationController(rootViewController: previewImageVC)

 
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.dismiss(animated: true, completion: {
                
                let imageData = UIImageJPEGRepresentation(editedImage, 0.5)
                let dataSize = NSData(data: imageData!).length
                if dataSize  < 10000000  {
                    
                    previewImageVC.incomingImage = editedImage
                    self.present(navVC, animated: true, completion: nil)
                    
                }else{
                    
                    
                    let alert = UIAlertController(title: "", message: "We're sorry, the image file is too large.Try another image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
            })
            
            
        }

        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
        self.dismiss(animated: true, completion: {
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let dataSize = NSData(data: imageData!).length
            if dataSize  < 10000000  {
            
                previewImageVC.incomingImage = image
                self.present(navVC, animated: true, completion: nil)
            
            }else{
                
                
                let alert = UIAlertController(title: "", message: "We're sorry, the image file is too large.Try another image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }

            
            
            
        })
            
            
        }
        
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
            
            
            self.dismiss(animated: true, completion: { 
                
            
                let videoData = NSData(contentsOf:  videoUrl as URL)
                
                let dataSize = videoData?.length
                
                if dataSize!  < 10000000  {
                
                previewImageVC.incomingVideoUrl = videoUrl
                self.present(navVC, animated: true, completion: nil)
                
                
                }else{
                    
                let alert = UIAlertController(title: "", message: "We're sorry, the video file is too large.Try another video", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
            
                
                
            })
            
        }
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true, completion: nil)
    }
    
    
    func handlePopToComments(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point),let cell = collectionView?.cellForItem(at: indexPath) as? TrendinCollectionViewCell {

            let selectedItem = self.objects[indexPath.item]
//
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
        
            let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
            commentVC.hidesBottomBarWhenPushed = true
            commentVC.incomingTrendinVC = cell
            commentVC.commentId = selectedItem.objectId
            commentVC.TrendingVC = self
            self.navigationController?.pushViewController(commentVC, animated: true)
//            print(selectedItem.numberOfComments)
        }
        
    }
    
    func handleGesturePopToComment(gesture: UITapGestureRecognizer){
        
        if let label = gesture.view {
            
            let point = label.convert(label.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point),let cell = collectionView?.cellForItem(at: indexPath) as? TrendinCollectionViewCell  {
                let selectedItem = self.objects[indexPath.item]
                
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
                commentVC.incomingTrendinVC = cell
                commentVC.hidesBottomBarWhenPushed = true
                commentVC.commentId = selectedItem.objectId
                commentVC.TrendingVC = self
                self.navigationController?.pushViewController(commentVC, animated: true)

            
            }
        }
        
    }
    
    func updateLikesInfoInTheBackend(selectedItem: TrendinObject){
        let query = BmobQuery(className: "Trends")
        query?.getObjectInBackground(withId: selectedItem.objectId, block: { (object, error) in
            if error == nil {
                
                if var likersArray = object?.object(forKey: "likersArray") as? [String] {
                    var numberOfLikes = object?.object(forKey: "numberOfLikes") as? Int
                    numberOfLikes = numberOfLikes! + 1
                    
                    likersArray.append(BmobUser.current().objectId)
                    object?.setObject(likersArray, forKey: "likersArray")
                    object?.setObject(numberOfLikes, forKey: "numberOfLikes")
                    object?.updateInBackground(resultBlock: { (success, error) in
                        if success{
                            
                            print("updated successfully")
                            
                            self.loadData()
                            
                            if let poster = object?.object(forKey: "poster") as? BmobObject{
                                
                                if poster.objectId != BmobUser.current().objectId {
                                    
                                    let poster = BmobObject(outDataWithClassName: "_User", objectId: poster.objectId)
                                    
                                    let notify = BmobObject(className: "NotificationCenter")
                                    notify?.setObject(poster, forKey: "userToBeNotified")
                                    notify?.setObject("liked your trend", forKey: "notificationReason")
                                    notify?.setObject(object?.objectId, forKey: "postId")
                                    notify?.setObject(false, forKey: "notified")
                                    notify?.setObject(BmobUser.current(), forKey: "responder")
                                    notify?.setObject(true, forKey: "userLikedIt")
                                    notify?.setObject(false, forKey: "addRequest")
                                    notify?.setObject(false, forKey: "addPoints")
                                    notify?.setObject(false, forKey: "pointsAccepted")
                                    notify?.setObject(false, forKey: "requestAccepted")
                                    notify?.saveInBackground(resultBlock: { (success, error) in
                                        if success{
                                            
                                            print("notification sent successfully")
                                            
                                        }else{
                                            
                                            print(error?.localizedDescription as Any)
                                        }
                                    })
                                    
                                }
                                
                              
                                
                                
                            }
                            
                        }
                    })
                    
                }
                
                
            }else{
                
                print(error?.localizedDescription as Any)
                
            }
        })
    }
    
    func updateDislikesInfoInTheBackend(selectedItem: TrendinObject){
        
        let query = BmobQuery(className: "Trends")
        query?.getObjectInBackground(withId: selectedItem.objectId, block: { (object, error) in
            if error == nil {
                var newLikers = [String]()
                
                if let likersArray = object?.object(forKey: "likersArray") as? [String] {
                    var numberOfLikes = object?.object(forKey: "numberOfLikes") as? Int
                    
                    if numberOfLikes! > 0 {
                        
                        numberOfLikes = numberOfLikes! - 1
   
                        
                    }
                    
                    if let currentUserId = BmobUser.current().objectId{
                       
                        for liker in likersArray {
                            
                            if liker != currentUserId {
                                
                                newLikers.append(liker)
                            }
                        }
                        
                        
                    }
                   
                    object?.setObject(newLikers, forKey: "likersArray")
                    object?.setObject(numberOfLikes, forKey: "numberOfLikes")
                    object?.updateInBackground(resultBlock: { (success, error) in
                        if success{
                            
                            print("dislikes updated successfully")
                            
                        }
                    })
                    
                }
                
                
            }else{
                
                print(error?.localizedDescription as Any)
                
            }
        })
        
        
    }
    
    func handleLikeButtonTapped(sender: UIButton){
//        likeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //        var likeButtonHeightConstraint: NSLayoutConstraint?
        //        var likeButtonWidthConstraint: NSLayoutConstraint?
        
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point){
            
            if let cell = collectionView?.cellForItem(at: indexPath) as? TrendinCollectionViewCell {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                   cell.likeButtonHeightConstraint?.constant = 60
                   cell.likeButtonWidthConstraint?.constant = 150
                    
                }, completion: { (completed) in
                    
                    cell.likeButtonHeightConstraint?.constant = 30
                    cell.likeButtonWidthConstraint?.constant = 100
                })
                
               
            }
            
            let selectedItem = self.objects[indexPath.item]
            
            if sender.currentImage == UIImage(named: "Love"){
                
                if var currentTitle = Int(sender.currentTitle!){
                    
                    sender.setImage(UIImage(named:"RedHeart"), for: .normal)
                    currentTitle = currentTitle + 1
                    sender.setTitle("\(currentTitle)", for: .normal)
                    
                    self.updateLikesInfoInTheBackend(selectedItem: selectedItem)

                    
                }
                
                
            }else if sender.currentImage == UIImage(named: "RedHeart"){
                
                
                if var currentTitle = Int(sender.currentTitle!){
                    
                    if currentTitle > 0 {
                        
                        sender.setImage(UIImage(named:"Love"), for: .normal)
                        currentTitle = currentTitle - 1
                        sender.setTitle("\(currentTitle)", for: .normal)
                        
                        self.updateDislikesInfoInTheBackend(selectedItem: selectedItem)
                    }
                    
                    
                }
                
            }
          
        }
        
    
        
    }
    
    func handlePlayVideo(sender: UIButton){
        
        print("testing videoplayback")

        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point), let cell = collectionView?.cellForItem(at: indexPath)as? TrendinCollectionViewCell{
            
            let object = self.objects[indexPath.item]
            
            if let url = object.videoUrl {
                
                print("testing videoplayback")
                
                
                player = AVPlayer(url: url as URL)
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.bounds = cell.videoPlayerView.bounds
                cell.videoPlayerView.layer.addSublayer(playerLayer!)
                self.player?.play()
                
                
                
            }
        }
        
       
        
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Thank you", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
  
    }
    
    func handleOptionsButtonTapped(sender: UIButton){
       
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.objects[indexPath.item]
           
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.modalPresentationStyle = .popover
            alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
                
                let reportAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                
                reportAlert.addAction(UIAlertAction(title: "Copyright issues", style: .destructive, handler: { (action) in
                    
                    let reportPost = BmobObject(className: "Reports")
                    reportPost?.setObject(BmobUser.current(), forKey: "reporter")
                    reportPost?.setObject("Copyright issues", forKey: "Reasons")
                    reportPost?.setObject(selectedItem, forKey: "post")
                    reportPost?.setObject(selectedItem.objectId, forKey: "postId")
                    reportPost?.saveInBackground(resultBlock: { (success, error) in
                        if success {
                            
                            print("report saved")
                            
                            self.showAlert()
                            
                        }
                    })
                    
                }))
                
                reportAlert.addAction(UIAlertAction(title: "Inappropriate Content", style: .destructive, handler: { (action) in
                    
                    let report = BmobObject(className: "Reports")
                    report?.setObject(BmobUser.current(), forKey: "reporter")
                    report?.setObject("Inappropriate Content", forKey: "Reasons")
                    report?.setObject(selectedItem, forKey: "post")
                    report?.setObject(selectedItem.objectId, forKey: "postId")
                    report?.saveInBackground(resultBlock: { (success, error) in
                        if success {
                            
                         print("report saved")
                            
                        self.showAlert()
                            
                        }
                    })

                    
                }))
                
                reportAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(reportAlert, animated: true, completion: nil)


            }))
          
            if selectedItem.user?.objectId == BmobUser.current().objectId {
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    
                    self.objects.remove(at: indexPath.item)
                    self.collectionView?.reloadData()
                    
                    let query = BmobQuery(className: "Trends")
                    query?.getObjectInBackground(withId: selectedItem.objectId, block: { (object, error) in
                        if error == nil {
                            
                            object?.deleteInBackground({ (success, error) in
                                if success{
                                    
                                    print("deleted successfully")
                                    
                                    let queryNotification = BmobQuery(className: "NotificationCenter")
                                    queryNotification?.whereKey("postId", equalTo: object?.objectId)
                                    queryNotification?.findObjectsInBackground({ (results, error) in
                                        if error == nil {
                                            
                                            if (results?.count)! > 0 {
                                                
                                                for result in results!{
                                                
                                                    if let foundObject = result as? BmobObject{
                                                        
                                                        foundObject.deleteInBackground({ (success, error) in
                                                            if success {
                                                                
                                                                print("notification deleted successfully")
                                                            }
                                                        })
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                            }
                                        }
                                    })
                                    
                                  
                                    
                                    
                                }else{
                                    
                                    print(error?.localizedDescription as Any)
                                    
                                }
                            })
                            
                        }
                    })
                    
                }))
                
            }
            
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
                
            }
          self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
   
    let PopOutVideoScreenAndPlay = PopUpAndPlayVideo()
    
    func handlePopVideoToSecreenAndPlay(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.objects[indexPath.item]
            if let url = selectedItem.videoUrl {
                
                PopOutVideoScreenAndPlay.handlePopVideoToSecreenAndPlay(url: url , selectedObjectId: selectedItem.objectId!)
   
            }

        }
    }
    
    
    let popViewMainImage = PopDisplayImageView()
    
    func handlePopDisplayMainImageView(gesture: UITapGestureRecognizer){
        if let startingImageView = gesture.view as? UIImageView {
            
           popViewMainImage.acceptAndLoadDisplayImage(imageView: startingImageView)
//           popViewMainImage.acceptAndLoadDisplayImage(imageView: startingImageView, incomingViewController: self)
        }
        
        
    }
    
    
    
    
    func handleProfileImageViewTapped(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view as? UIImageView{
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point) {
                
                let selectedItem = self.objects[indexPath.item]
                
                if let user = selectedItem.user {
                    
                    let layout = UICollectionViewFlowLayout()
                    let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
                    myMomentsVC.incomingUser = user.objectId
                    myMomentsVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(myMomentsVC, animated: true)
                    
                }
                
            }

            
            
        }
        
        
    }
    
    func handleUsernameTapped(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view as? UILabel{
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point) {
                
                let selectedItem = self.objects[indexPath.item]
                
                if let user = selectedItem.user {
                    
                    let layout = UICollectionViewFlowLayout()
                    let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
                    myMomentsVC.incomingUser = user.objectId
                    myMomentsVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(myMomentsVC, animated: true)
                    
                }
                
            }
            
            
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    var timeStamp = ""


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.objects.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrendinCollectionViewCell
        
        
        if objects.count == indexPath.row{
            
            let loadMoreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: loadMoreCellId, for: indexPath) as! LoadMoreCollectionViewCell

            
            if self.isLoadingOldPosts == false {
                
                self.loadOlderObjects()
                
                loadMoreViewCell.activityIndicator.startAnimating()
                
                
            }
            
            
            return loadMoreViewCell
        }
        
        
       
        
        
        cell.backgroundColor = UIColor.white

        let object = self.objects[indexPath.item]
        cell.object = object
        
        cell.profileImage.isUserInteractionEnabled = true
        cell.usernameLabel.isUserInteractionEnabled = true
        
        cell.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageViewTapped)))
        cell.usernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapped)))
        
        
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy EEE h:mm a"
        dateFormatter.dateFormat = "MMM dd, yyyy, EEE h:mm a"
        let stringFromDate = dateFormatter.string(from: object.createdAt as! Date)
        
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour , .minute], from: (object.createdAt as! Date), to: NSDate() as Date)
        
        
        let days = diffDateComponents.day
        let dateByMins = diffDateComponents.minute
        let hourHand = diffDateComponents.hour
        
        
        
        if let day = days ,let hour = hourHand, let mins = dateByMins{
            
            if day == 0 {
                
                switch hour {
                    
                case 0:
                    
                    if mins == 0 {
                        
                        timeStamp = "Now"
                        
                        
                    }else if mins == 1{
                        
                        
                        timeStamp = "1 min ago"
                        
                    }else{
                        
                        timeStamp = "\(mins) mins ago"
   
                        
                    }
                    
                case 1:
                    
                    timeStamp = "1 hour ago"
                    
                    
                default:
                    
                    timeStamp = "\(hour) hours ago"
                }
                
                
                
            }else if day >= 1 {
                
                timeStamp = stringFromDate
                
            }
            
        }

        if let user = object.user,  let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile  {
            
            
            let attributedMutableText = NSMutableAttributedString(string: user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)])
            
            let atrributedText = NSAttributedString(string: "\n\(timeStamp)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.lightGray])
            attributedMutableText.append(atrributedText)
            
            let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
            
            attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
            
            cell.usernameLabel.attributedText = attributedMutableText
            
            cell.profileImage.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
            
        }
     
        
        if let numbOfComments = object.numberOfComments {
            
            cell.commentLabel.text = "\(numbOfComments) comments"
            
            
        }
        
        if let numbOfLikes = object.numberOfLikes {
            
            cell.likeButton.setTitle("\(numbOfLikes)", for: .normal)
            
        }
        
        if let likersArray = object.likersArray, let currentUserId = BmobUser.current().objectId {
            
            if likersArray.contains(currentUserId){
                
                cell.likeButton.setImage(UIImage(named: "RedHeart"), for: .normal)
                
            }else{
                
                
                cell.likeButton.setImage(UIImage(named: "Love"), for: .normal)

            }
        }
        
        self.setUpCell(object: object, cell: cell)
        
        cell.commentLabel.isUserInteractionEnabled = true
        cell.commentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesturePopToComment)))
        
        cell.commentImageButton.addTarget(self, action: #selector(handlePopToComments), for: .touchUpInside)
        
        cell.likeButton.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        
        cell.optionsButton.addTarget(self, action: #selector(handleOptionsButtonTapped), for: .touchUpInside)
        cell.playButton.addTarget(self, action: #selector(handlePopVideoToSecreenAndPlay), for: .touchUpInside)
        
        cell.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopDisplayMainImageView)))
        cell.displayImageView.isUserInteractionEnabled = true

        
        if let videoDurationInSeconds = object.videoDuration {
            
            let secondsString = String(format: "%02d", Int(videoDurationInSeconds % 60))
            let minutesString = String(format: "%02d", Int(videoDurationInSeconds / 60))
            
            cell.videoDurationLabel.text = "\(minutesString):\(secondsString)"
            
        }
      
        return cell
    }
    
    
    func setUpCell(object: TrendinObject, cell: TrendinCollectionViewCell){
        

        if let statusText = object.statusText {
            
            cell.statusTextView.text = statusText
            
            cell.statusTextView.isHidden = false
            cell.videoContainerView.isHidden = true
            cell.statusContainerView.isHidden = true
            
        }else {
            
            cell.statusTextView.isHidden = true
 
            
        }
        
        if let statusImageUrl = object.imageUrl , let h = object.imageHeight , let w = object.imageWidth {
            
//            cell.displayImageView.loadImageUsingCacheWithUrlString(urlString: statusImageUrl.absoluteString!)
            cell.displayImageView.sd_setImage(with: statusImageUrl as URL, placeholderImage: UIImage(named: "LoadingBackground"))
            
            if object.captionText != "" {
                
                cell.captionTextView.isHidden = false
            }
           
            cell.captionTextView.text = object.captionText

            
            let imageHeight = CGFloat(h) / CGFloat(w) * self.view.frame.width
            
            cell.statusImageViewHeightConstraint?.constant = imageHeight
            
            cell.videoContainerView.isHidden = true
            cell.statusContainerView.isHidden = false
            cell.statusTextView.isHidden = true
            
            
        }else{
            
            cell.captionTextView.isHidden = true
  
            
        }
        
        
        
        if let videoPreviewUrl = object.videoPreviewImageUrl {
            
            cell.videoContainerView.isHidden = false
            cell.statusContainerView.isHidden = true
            
            cell.statusTextView.isHidden = true
            
            if object.videoCaptionText != ""{
              
                cell.videoCaptionTextView.isHidden = false

            }
            
            cell.videoCaptionTextView.text = object.videoCaptionText
//            cell.videoPlayerView.loadImageUsingCacheWithUrlString(urlString: videoPreviewUrl.absoluteString!)
            cell.videoPlayerView.sd_setImage(with: videoPreviewUrl as URL, placeholderImage: UIImage(named: "LoadingBackground"))

            
            
        }else{
            
            cell.videoCaptionTextView.isHidden = true
 
            
        }
        
      
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 110
        var captionHeight: CGFloat = 0
        
        if objects.count  == indexPath.row {
            
            height = 50
            return CGSize(width: self.view.frame.width, height: height)

        }

        
        let object = objects[indexPath.item]

        
        if let statusText = object.statusText {
            
            let rect = self.estimatedRect(text: statusText)
            
            height = height + rect.height + 15
            
            return CGSize(width: self.view.frame.width, height: height)

            
        }
        
        if object.imageUrl != nil , let h = object.imageHeight , let w = object.imageWidth {
            
            let imageHeight = CGFloat(h) / CGFloat(w) * CGFloat(self.view.frame.width)
            
            if let captionText = object.captionText {
                
                captionHeight = self.estimatedRect(text: captionText).height + 15
            }
            
            height = imageHeight + height + captionHeight
            
            return CGSize(width: self.view.frame.width, height: height)

            

        }
        
        
        if object.videoPreviewImageUrl != nil && object.videoUrl != nil {
            
            if let videoCaption = object.videoCaptionText {
                
                captionHeight = self.estimatedRect(text: videoCaption).height + 15
            }
            
//            let vidHeight = self.view.frame.width * 9 / 16
            
            height = 400 + height + captionHeight
            
            return CGSize(width: self.view.frame.width, height: height)



        }
        
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
 
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: ContestHeaderView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath) as? ContestHeaderView
            
         headerView?.PopToSelfieContestImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTransitionToContestVC)))


            
        }
        
        return headerView!
    }
    
    func handleTransitionToContestVC(){
        
        
        let competionVC = CompetitionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        competionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(competionVC, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 70)  // Header size
  
    }
    
  
    
  
    func estimatedRect(text: String) -> CGRect {
        
        let width = self.view.frame.width - 20
        return NSString(string: text).boundingRect(with: CGSize(width: width , height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil)
        
        
    }
    
//    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView : UICollectionReusableView? = nil
//        
//        // Create header
//        if (kind == UICollectionElementKindSectionHeader) {
//            // Create Header
//            var headerView : PackCollectionSectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kCellheaderReuse, forIndexPath: indexPath) as PackCollectionSectionView
//            
//            reusableView = headerView
//        }
//        return reusableView!
//    }

}
