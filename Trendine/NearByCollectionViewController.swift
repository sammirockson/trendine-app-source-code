//
//  NearByCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 03/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class NearByCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    private let reuseIdentifier = "Cell"
    
    var peopleAroundYou = [BmobUser]()
    var userLocation: CLLocation?
    let isLoadingOldPosts: Bool = false
    
    let locationManager = CLLocationManager()
    
    let addingUserBlurView: UIView = {
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
    
    


    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        bView.isHidden = false
        return bView
        
    }()
    
    

    
    let pulsingContainerView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.white
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.clipsToBounds = true
        bView.isHidden = false
        return bView
        
    }()

    let pulsingBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    var pulseTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pulsingContainerView)
        
        pulsingContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pulsingContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        pulsingContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        pulsingContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        pulsingContainerView.addSubview(pulsingBackgroundImageView)
        
        pulsingBackgroundImageView.centerYAnchor.constraint(equalTo: pulsingContainerView.centerYAnchor).isActive = true
        pulsingBackgroundImageView.centerXAnchor.constraint(equalTo: pulsingContainerView.centerXAnchor).isActive = true
        pulsingBackgroundImageView.heightAnchor.constraint(equalTo: pulsingContainerView.heightAnchor).isActive = true
        pulsingBackgroundImageView.widthAnchor.constraint(equalTo: pulsingContainerView.widthAnchor).isActive = true
        
        pulsingContainerView.backgroundColor = .white
        
        pulsingContainerView.addSubview(blurView)
        
        blurView.centerYAnchor.constraint(equalTo: pulsingContainerView.centerYAnchor).isActive = true
        blurView.centerXAnchor.constraint(equalTo: pulsingContainerView.centerXAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: pulsingContainerView.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: pulsingContainerView.widthAnchor).isActive = true
        
        
        blurView.addSubview(centerImageView)
        
        centerImageView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
        centerImageView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        if let currentUser = BmobUser.current(), let profileImageFile = currentUser.object(forKey: "profileImageFile") as? BmobFile{
           
             self.pulsingBackgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
            self.centerImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
        }
        
   
     
        
        collectionView?.backgroundColor = .black
        navigationItem.title = "Around Me"
        
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        self.collectionView!.register(NearByCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        displayActivityInProgressView()
        
        
        if self.locationManager.location != nil {
            
            self.pulseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handlePulsing), userInfo: nil, repeats: true)
            
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleStartLoading), userInfo: nil, repeats: false)
            
            
        }else{
            
            
            self.displayAlert(reason: "Trendin failed to access your location. Check Privacy Settings")
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayActivityInProgressView(){
        
        
        if let motherView = self.view {
            
            motherView.addSubview(backgroundBlurView)
            
            
            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            backgroundBlurView.addSubview(addingUserBlurView)
            
            addingUserBlurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
            addingUserBlurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
            addingUserBlurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            addingUserBlurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            addingUserBlurView.addSubview(activityIndicator)
            addingUserBlurView.addSubview(displayText)
            
            displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
            displayText.leftAnchor.constraint(equalTo: addingUserBlurView.leftAnchor).isActive = true
            displayText.rightAnchor.constraint(equalTo: addingUserBlurView.rightAnchor).isActive = true
            displayText.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            activityIndicator.startAnimating()
            
            activityIndicator.centerXAnchor.constraint(equalTo: addingUserBlurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: addingUserBlurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            self.backgroundBlurView.isHidden = true
            
        }
        
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        

        
    }
    
    func handleStartLoading(){
        
        if let currentLocation = self.locationManager.location {
            
            self.loadPeopleNearby(currentLocation: currentLocation)

        }
        
    }
    
    func handlePulsing(){
        
        let pulse = Pulsing(numberOfPulses: 1, radius: 200, position: centerImageView.center)
        pulse.animationDuration = 2.0
        pulse.backgroundColor = UIColor.red.cgColor
        
        self.view.layer.insertSublayer(pulse, below: centerImageView.layer)
        
    }

    
    
    func displayAlert(reason: String){
        
        let alert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    func updateCurrentUserLocation(){
        
        if let currentLocation = self.locationManager.location {
            let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
            
            let currentUser = BmobUser.current()
            currentUser?.setObject(geoPoint, forKey: "userLocation")
            currentUser?.updateInBackground(resultBlock: { (success, error) in
                if success{
                    
                    
                    print("current User location Updated successfully")
                }
            })
            
        }
        
    }
    
    
    func loadPeopleNearby(currentLocation: CLLocation){
        
        let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
            
            let query = BmobQuery(className: "_User")
            query?.whereKey("userLocation", nearGeoPoint: geoPoint)
            let array = [["FindByNearBy": true]]
            query?.addTheConstraintByAndOperation(with: array)
            query?.limit = 1000
            query?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        UIView.animate(withDuration: 0.75, animations: { 
                            
                            self.pulseTimer.invalidate()
                            self.pulsingContainerView.isHidden = true
                            
                        })
                        
                    }
                    
                    
                    self.peopleAroundYou.removeAll(keepingCapacity: true)
                    self.updateCurrentUserLocation()
 
                    if (results?.count)! > 0 {
                        
                        for result in results!{
                            
                            if let user = result as? BmobUser{
                                if user.objectId != "712b4069b8" && user.objectId != "2e897823de" {
                                
                                    if user.objectId != BmobUser.current().objectId {
                                        
                                        self.peopleAroundYou.append(result as! BmobUser)
                                        
                                        
                                    }
                                
                                }

                                
                            }

                            
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            self.collectionView?.reloadData()
                        }
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                     
                        self.pulseTimer.invalidate()
                        self.pulsingContainerView.isHidden = true
                        
                    }
                    
                    
                    self.displayAlert(reason: error?.localizedDescription as Any as! String)
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
                        
                    
                        
                        //////
                        
                        do {
                            
                            try moc.save()
                            
                            sender.setTitle("Friends", for: .normal)
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
                            notify?.setObject(false, forKey: "addPoints")
                            notify?.setObject(false, forKey: "pointsAccepted")
                            notify?.setObject(false, forKey: "requestAccepted")
                            notify?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("notified!!!")
                                }
                            })
                            
                        }catch {
                            
                            self.backgroundBlurView.isHidden = true

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
                            
                            sender.setTitle("Friends", for: .normal)
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
                            notify?.setObject(false, forKey: "addPoints")
                            notify?.setObject(false, forKey: "pointsAccepted")
                            notify?.setObject(false, forKey: "requestAccepted")
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
                
                self.backgroundBlurView.isHidden = true

                
            }
            
        } catch {
            
            self.backgroundBlurView.isHidden = true

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
                        
                    
                
                
                self.savedContactToCoreData(friend: selectedItem, room: room!, sender: sender)
                
            }else{
                
                self.backgroundBlurView.isHidden = true

                
                

            }
        })
        
        
        
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
                            
                            self.backgroundBlurView.isHidden = true

                            

                            
                        }
                    })
                    
                    
                    
                }else if results?.count == 1{
                    
                    //there's room
                    
                    
                    self.savedContactToCoreData(friend: selectedItem, room: results?.first as! BmobObject, sender: sender)
                    
                    
                }
                
            }else{
                
                self.backgroundBlurView.isHidden = true

            }
        })
        
    }

    
    func handleAddUserButtonTapped(sender: UIButton){

    
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.peopleAroundYou[indexPath.row]
            
            if sender.currentTitle == "Add" {
                self.backgroundBlurView.isHidden = false

                
                self.displayText.text = "Adding..."

                
                let relation = BmobRelation()
                let currentUser = BmobUser.current()
                
                relation.add(selectedItem)
                currentUser?.add(relation, forKey: "friends")
                currentUser?.updateInBackground(resultBlock: { (success, error) in
                    if error == nil {
                        
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
                        
                       
                        
                        
                        print("added")
                        
                        self.prepareToSaveRoom(selectedItem: selectedItem, sender: sender)
                        
                    }else {
                        
                        self.backgroundBlurView.isHidden = true

                        

                    }
                })
                
                
            }else if sender.currentTitle == "Friends"{
                
               
                let layout = UICollectionViewFlowLayout()
                let myMomentsVC = MyMomentsCollectionViewController(collectionViewLayout: layout)
                myMomentsVC.incomingUser = selectedItem.objectId
                myMomentsVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myMomentsVC, animated: true)
                
                
            }
        }

        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.peopleAroundYou.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NearByCollectionViewCell
        cell.backgroundColor = .blue
        // Configure the cell
        
        let user = self.peopleAroundYou[indexPath.item]
        
        if self.isLoadingOldPosts == false {
            
//            self.loadOlderObjects()
            
            
            
        }
        
        
        cell.usernameLabel.text = user.username
        
        if let profileImage = user.object(forKey: "profileImageFile") as? BmobFile {
            
            cell.profileImageView.sd_setImage(with: NSURL(string: profileImage.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
            cell.BackgroundImageView.sd_setImage(with: NSURL(string: profileImage.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))

            if let userLoca = user.object(forKey: "userLocation") as? BmobGeoPoint {
                
                if let currentLocation = self.locationManager.location {
                    
                    let location = CLLocation(latitude: userLoca.latitude, longitude: userLoca.longitude)
                    let distance = Int(location.distance(from: currentLocation))
                    
                    let distanceInMeters = String(format: "%01d", Int(distance % 1000))
                    let distanceInKilometers = String(format: "%01d", Int(distance / 1000))
                    
//                    cell.videoDurationLabel.text = "\(minutesString):\(secondsString)"
                    
                    
                    let attributed = NSMutableAttributedString(string: "\(distanceInKilometers).\(distanceInMeters)km away", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)])
                    
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "locationIcon")
                    attachment.bounds = CGRect(x: 2, y: -2, width: 8, height: 12)
                    attributed.append(NSAttributedString(attachment: attachment))
                    cell.distanceLabel.attributedText = attributed
                    
                    
                    
                }
                
                    
            }
             
        
            
        }
        
       
        
        
        let AppDel = UIApplication.shared.delegate as! AppDelegate
        let moc = AppDel.persistentContainer.viewContext
        
        let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        fetch.predicate = NSPredicate(format: "objectId == %@", user.objectId)
        fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
        
        
        do {
            
            let results = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
            
            if results.count ==  0 {
                
                
                cell.AddUserButton.setTitle("Add", for: .normal)
                
            }else if results.count > 0 {
                
                cell.AddUserButton.setTitle("Friends", for: .normal)
                
                
            }
            
        }catch{
            
            print(error)
        }
        
        cell.AddUserButton.addTarget(self, action: #selector(handleAddUserButtonTapped), for: .touchUpInside)
    
        return cell
    }
    
 
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = self.view.frame.width / 2 - 1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
        
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    

 

}
