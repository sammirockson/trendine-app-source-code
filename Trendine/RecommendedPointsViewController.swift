//
//  RecommendedPointsViewController.swift
//  Trendine
//
//  Created by Rockson on 30/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class RecommendedPointsViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
       let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        return imageV
        
    }()
    
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.layer.cornerRadius = 40
        imageV.clipsToBounds = true
        imageV.image = UIImage(named: "personplaceholder")
        return imageV
        
    }()
    
    let backgroundCoverView: UIView = {
        let bgCover = UIView()
        bgCover.translatesAutoresizingMaskIntoConstraints = false
        bgCover.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        return bgCover
        
    }()
    
    
    let activityCoverView: UIView = {
        let bgCover = UIView()
        bgCover.translatesAutoresizingMaskIntoConstraints = false
        bgCover.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        return bgCover
        
    }()
    
    
    let displayFoundInfoView: UIView = {
        let bgCover = UIView()
        bgCover.translatesAutoresizingMaskIntoConstraints = false
        bgCover.backgroundColor = UIColor.white
        bgCover.layer.cornerRadius = 5
        bgCover.clipsToBounds = true
        return bgCover
        
    }()
    
    
    let thinVerticalLine: UIView = {
        let bgCover = UIView()
        bgCover.translatesAutoresizingMaskIntoConstraints = false
        bgCover.backgroundColor = UIColor.lightGray
        bgCover.clipsToBounds = true
        return bgCover
        
    }()
    
    let thinHorizontalLine: UIView = {
        let bgCover = UIView()
        bgCover.translatesAutoresizingMaskIntoConstraints = false
        bgCover.backgroundColor = UIColor.lightGray
        bgCover.clipsToBounds = true
        return bgCover
        
    }()
    
    
    let usernameTextField: UITextField = {
       let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.placeholder = "Username"
        textF.layer.borderWidth = 1
        textF.layer.borderColor = UIColor.lightGray.cgColor
        textF.layer.cornerRadius = 4
        textF.clipsToBounds = true
        textF.textColor = .white
        textF.textAlignment = .center
        return textF
        
        
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter the username of the person that recommended Trendine App to you."
        label.numberOfLines = 0
        label.textColor = .white
        return label
        
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "username"
        label.textAlignment = .center
        return label
        
    }()
    
    
    let displayInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Is this your friend?"
        label.numberOfLines = 0
        label.textColor = MessagesCollectionViewCell.blueColor
        label.textAlignment = .center
        return label
        
    }()
    
    
    lazy var searchUserButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Find User", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleFindUser), for: .touchUpInside)
        return button
        
    }()
    
    
    
       lazy var  confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.setTitleColor( MessagesCollectionViewCell.blueColor, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleconfirmButton), for: .touchUpInside)
        return button
        
    }()
    
    
    lazy var declineButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No", for: .normal)
        button.setTitleColor( MessagesCollectionViewCell.blueColor, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handledeclineButton), for: .touchUpInside)
        return button
        
    }()
    
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.setTitleColor( UIColor.white, for: .normal)
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true 
        return button
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    
        
//        navigationItem.title = "Award Points"
        
//        let rightButton = UIBarButtonItem(title: "Skip", style: .done, target: self, action: #selector())
//        self.navigationItem.setRightBarButton(rightButton, animated: true)
        
        self.setUpViews()

        self.view.backgroundColor = .red
        
        if let currentUser = BmobUser.current() {
            
                if let profileImageFile = currentUser.object(forKey: "profileImageFile") as? BmobFile {
                    
                    self.backgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                    
                    
                }
                
            
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(activityCoverView)
            
            activityCoverView.addSubview(activityIndicator)
            
            activityIndicator.centerXAnchor.constraint(equalTo: activityCoverView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: activityCoverView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            activityCoverView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            activityCoverView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
            activityCoverView.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
            activityCoverView.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
            
            activityCoverView.addSubview(displayFoundInfoView)
            
            displayFoundInfoView.centerXAnchor.constraint(equalTo: activityCoverView.centerXAnchor).isActive = true
            displayFoundInfoView.centerYAnchor.constraint(equalTo: activityCoverView.centerYAnchor).isActive = true
            displayFoundInfoView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            displayFoundInfoView.heightAnchor.constraint(equalToConstant: 400).isActive = true
            
            displayFoundInfoView.addSubview(thinVerticalLine)
            
            thinVerticalLine.bottomAnchor.constraint(equalTo: displayFoundInfoView.bottomAnchor).isActive = true
            thinVerticalLine.centerXAnchor.constraint(equalTo: displayFoundInfoView.centerXAnchor).isActive = true
            thinVerticalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
            thinVerticalLine.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            displayFoundInfoView.addSubview(thinHorizontalLine)
            
            thinHorizontalLine.rightAnchor.constraint(equalTo: displayFoundInfoView.rightAnchor, constant: -8).isActive = true
            thinHorizontalLine.bottomAnchor.constraint(equalTo: thinVerticalLine.topAnchor).isActive = true
            thinHorizontalLine.leftAnchor.constraint(equalTo: displayFoundInfoView.leftAnchor, constant: 8).isActive = true
            thinHorizontalLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            
            displayFoundInfoView.addSubview(profileImageView)
            
            profileImageView.centerXAnchor.constraint(equalTo: displayFoundInfoView.centerXAnchor).isActive = true
            profileImageView.centerYAnchor.constraint(equalTo: displayFoundInfoView.centerYAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            displayFoundInfoView.addSubview(confirmButton)
            
            confirmButton.rightAnchor.constraint(equalTo: displayFoundInfoView.rightAnchor).isActive = true
            confirmButton.topAnchor.constraint(equalTo: thinHorizontalLine.bottomAnchor).isActive = true
            confirmButton.leftAnchor.constraint(equalTo: thinVerticalLine.rightAnchor).isActive = true
            confirmButton.bottomAnchor.constraint(equalTo: displayFoundInfoView.bottomAnchor).isActive = true
            
            displayFoundInfoView.addSubview(declineButton)
            
            declineButton.rightAnchor.constraint(equalTo: thinVerticalLine.leftAnchor).isActive = true
            declineButton.topAnchor.constraint(equalTo: thinHorizontalLine.bottomAnchor).isActive = true
            declineButton.leftAnchor.constraint(equalTo: displayFoundInfoView.leftAnchor).isActive = true
            declineButton.bottomAnchor.constraint(equalTo: displayFoundInfoView.bottomAnchor).isActive = true
            
            displayFoundInfoView.addSubview(displayInfoLabel)
            
            displayInfoLabel.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -50).isActive = true
            displayInfoLabel.leftAnchor.constraint(equalTo: displayFoundInfoView.leftAnchor, constant: 10).isActive = true
            displayInfoLabel.rightAnchor.constraint(equalTo: displayFoundInfoView.rightAnchor, constant: -10).isActive = true
            displayInfoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            displayFoundInfoView.addSubview(usernameLabel)
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
            usernameLabel.centerXAnchor.constraint(equalTo: displayFoundInfoView.centerXAnchor).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            
            
            activityCoverView.isHidden = true
            displayFoundInfoView.isHidden = true
            
        }
    }
    
    func handledeclineButton(){
        
        self.activityCoverView.isHidden = true
 
        
    }
    var foundUser: BmobUser?
    
    func handleconfirmButton(){
        
        if let user = foundUser {
            
            
            self.displayFoundInfoView.isHidden = true
            self.activityCoverView.isHidden = false
            self.activityIndicator.startAnimating()
            
            
            let notifyAdd = BmobObject(className: "NotificationCenter")
            notifyAdd?.setObject(user, forKey: "userToBeNotified")
            notifyAdd?.setObject("Added you", forKey: "notificationReason")
            notifyAdd?.setObject(user.objectId, forKey: "postId")
            notifyAdd?.setObject(false, forKey: "notified")
            notifyAdd?.setObject(BmobUser.current(), forKey: "responder")
            notifyAdd?.setObject(false, forKey: "userLikedIt")
            notifyAdd?.setObject(true, forKey: "addRequest")
            notifyAdd?.setObject(false, forKey: "addPoints")
            notifyAdd?.setObject(false, forKey: "pointsAccepted")
            notifyAdd?.setObject(false, forKey: "requestAccepted")
            notifyAdd?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    
                    
                    
                }
            })
            
            
            let notify = BmobObject(className: "NotificationCenter")
            notify?.setObject(user, forKey: "userToBeNotified")
            notify?.setObject("You have earned 100 points!", forKey: "notificationReason")
            notify?.setObject(false, forKey: "userLikedIt")
            notify?.setObject(false, forKey: "addRequest")
            notify?.setObject(true, forKey: "addPoints")
            notify?.setObject(false, forKey: "pointsAccepted")
            notify?.setObject(BmobUser.current(), forKey: "responder")
            notify?.setObject(false, forKey: "notified")
            notify?.setObject(false, forKey: "requestAccepted")
            notify?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    
                    DispatchQueue.main.async {
                        
                        
                        let relation = BmobRelation()
                        
                        relation.add(user)
                        self.currentUser?.add(relation, forKey: "friends")
                        self.currentUser?.updateInBackground(resultBlock: { (success, error) in
                            if error == nil {
                                
                                print("added")
                                
                                let installationQuery = BmobInstallation.query()
                                installationQuery?.whereKey("userId", equalTo: user.objectId)
                                
                                if let name = self.currentUser?.username {
                                    
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
                                
                                
                             self.saveToRoom(selectedItem: user)
                                
                                
                            }else {
                                
                                self.activityCoverView.removeFromSuperview()
                                self.activityIndicator.stopAnimating()
                                
                                
                            }
                        })
                        
                        
                        
                        
                       
                        
                        let customVC = CustomTabbarController()
                        self.present(customVC, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                }else{
                    
                    self.activityCoverView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    
                    self.showAlert(reason: error?.localizedDescription as Any as! String)
                    
                }
            })

            
            
            
            
        }else{
            
            self.activityCoverView.isHidden = true
            self.activityIndicator.stopAnimating()
            
        }
        
      
        
    }
    
    let currentUser = BmobUser.current()
    
    func saveToRoom(selectedItem: BmobUser){
        
        let room = BmobObject(className: "Room")
        room?.setObject(selectedItem, forKey: "user1")
        room?.setObject(BmobUser.current(), forKey: "user2")
        room?.setObject(selectedItem.objectId, forKey: "user1Id")
        room?.setObject(BmobUser.current().objectId, forKey: "user2Id")
        room?.setObject(true, forKey: "newRoom")
        room?.saveInBackground(resultBlock: { (success, error) in
            if error == nil {
                
                print("room saved...")
                
//                let backendMessage = BmobObject(className: "Messages")
//                backendMessage?.setObject(self.currentUser, forKey: "sender")
//                backendMessage?.setObject("Nice to meet you...", forKey: "textMessage")
//                backendMessage?.setObject(room?.objectId, forKey: "roomId")
//                backendMessage?.setObject(self.currentUser?.objectId, forKey: "uniqueId")
//                backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
//                backendMessage?.saveInBackground(resultBlock: { (success, error) in
//                    if success {
//                        
//                        let roomQuery = BmobQuery(className: "Room")
//                        roomQuery?.cachePolicy = kBmobCachePolicyCacheElseNetwork
//                        roomQuery?.getObjectInBackground(withId: room?.objectId, block: { (roomObject, error) in
//                            if error == nil {
//                                
//                                roomObject?.setObject(false, forKey: "newRoom")
//                                roomObject?.updateInBackground(resultBlock: { (success, error) in
//                                    if success {
//                                        
//                                        print("room Updated")
//                                        
//                                    }else{
//                                        
//                                        print(error?.localizedDescription as Any)
//                                    }
//                                })
//                                
//                                
//                                
//                            }
//                        })
//                        
                
                        
//                        let unreadMessage = BmobObject(className: "UnreadMesssages")
//                        unreadMessage?.setObject(selectedItem.objectId, forKey: "incomingUserId")
//                        unreadMessage?.setObject(room?.objectId, forKey: "roomId")
//                        unreadMessage?.saveInBackground(resultBlock: { (success, error) in
//                            if success{
//                                
//                                print("unread message sent successfully")
//                                
//                            }else{
//                                
//                                print(error?.localizedDescription as Any)
//                            }
//                        })
//                        
//                    }
//                })
                
                self.savedContactToCoreData(friend: selectedItem, room: room!)
                
            }else{
                
                self.activityCoverView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                
                
                
            }
        })
        
        
        
    }
    
    
    
    func handleFindUser(){
        
        self.activityCoverView.isHidden = false
        self.activityIndicator.startAnimating()
        self.displayFoundInfoView.isHidden = true

        
        if self.usernameTextField.text != "" {
            
            let username = self.usernameTextField.text
            
            if username != BmobUser.current().username {
                
                
                let userQuery = BmobUser.query()
                userQuery?.whereKey("username", equalTo: username)
                userQuery?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        
                        if (results?.count)! > 0 {
                            
                            for result in results! {
                                
                                if let user = result as? BmobUser {
                                    
                                    self.foundUser = user

                                    
                                    DispatchQueue.main.async {
                                        
                                        self.displayFoundInfoView.isHidden = false
                                        self.activityIndicator.stopAnimating()
                                        
                                        
                                        if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                                            
                                            self.usernameLabel.text = user.username
                                            self.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }else if results?.count == 0{
                            
                            //user not found
                            
                            self.activityCoverView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            
                            //alert
                            
                            self.showAlert(reason: "User not found!")
                            
                            
                        }
                        
                        
                    }else{
                        
                        self.activityCoverView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        
                        
                        self.showAlert(reason: error?.localizedDescription as Any as! String)
                        
                        
                    }
                })
                
                
                
                
            }else{
               
                self.activityCoverView.isHidden = true
                self.activityIndicator.stopAnimating()
                showAlert(reason: "Skip")

                
            }
          
            
            
            
        }else{
            
            self.activityCoverView.isHidden = true
            self.activityIndicator.stopAnimating()

            
            showAlert(reason: "TextField cannot be empty")

            
            //empty textfield
        }
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)

        
    }
    
    
    func showAlert(reason: String ){
        
        let alert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleRightBarButton(){
        
      let customVC = CustomTabbarController()
      self.present(customVC, animated: true, completion: nil)
        
        
    }

    func setUpViews(){
        
      self.view.addSubview(backgroundImageView)
      self.view.addSubview(backgroundCoverView)
      self.view.addSubview(usernameTextField)
      self.view.addSubview(infoLabel)
      self.view.addSubview(searchUserButton)
      self.view.addSubview(skipButton)
        
        
        skipButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        skipButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
     searchUserButton.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor, constant: 50).isActive = true
     searchUserButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
     searchUserButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
     searchUserButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
     
     infoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
     infoLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
     infoLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -50).isActive = true
     infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
      usernameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
      usernameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
      usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
      usernameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
      
      backgroundCoverView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
      backgroundCoverView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      backgroundCoverView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
      backgroundCoverView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
      
      backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
      backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
      backgroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        
        
    }
    
    
    func savedContactToCoreData(friend: BmobUser , room: BmobObject){
        let AppDel = UIApplication.shared.delegate as! AppDelegate
        let moc = AppDel.persistentContainer.viewContext
        
        // Query coreData first if the user doesn't exists already
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", friend.objectId)
        
        do {
            let searchResults = try moc.fetch(request)
            
            if searchResults.count == 0  {
            
                    let entity2 = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                        
                        entity2.createdAt = room.createdAt as NSDate?
                        entity2.objectId = friend.objectId
                        entity2.lastUpdate = NSDate()
                        entity2.newOrOld = false
                        entity2.roomId = room.objectId
                        
                        do {
                            
                            try moc.save()
                        
                            self.activityCoverView.removeFromSuperview()
                            self.activityIndicator.stopAnimating()
                            
                            
                            
                        }catch {
                            
                        self.activityCoverView.removeFromSuperview()
                        self.activityIndicator.stopAnimating()
                            
                   
                }
                
                
                
            }else{
                
                self.activityCoverView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                
//                self.blurView.isHidden = true
                
                
            }
            
        } catch {
            
//            self.blurView.isHidden = true
            
            self.activityCoverView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
            
            print("Error with request: \(error)")
        }
        
        
    }

}
