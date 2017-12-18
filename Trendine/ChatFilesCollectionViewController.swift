//
//  ChatFilesCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 23/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData


class ChatFilesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    var incomingUser: Contacts?
    
    
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
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()

    
//    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
//        
//        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
//        request.predicate = NSPredicate(format: "roomId == %@", (self.incomingUser?.roomId)!)
//        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
//        request.fetchLimit = 1000
//      
//        
//        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
//    }()
    
    var messages = [MessageObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Files"
        
        
//        do {
//            
//            try self.fetchedResultsControler.performFetch()
//            
//            if let fetchedContacts = self.fetchedResultsControler.fetchedObjects as? [Messages] {
//                
//                if fetchedContacts.count > 0 {
//                    
//                    
//                    self.messages.removeAll(keepingCapacity: true)
//                    
//                    for message in fetchedContacts {
//                        
//                        if message.imageMessageURL != nil || message.imageMessage != nil {
//                            
//                            let messageObject = MessageObject()
//                            
//                            messageObject.objectId = message.objectId
//                            messageObject.createdAt = message.createdAt
//                            messageObject.senderId =  message.senderId
//                            messageObject.senderName = message.senderName
//                            messageObject.imageMessageURL = message.imageMessageURL
//                            messageObject.imageMessage  = message.imageMessage
////                            messageObject.audioData = message.audioMessage
////                            messageObject.nameCardId = message.nameCardId
//                            
//                            self.messages.insert(messageObject, at: 0)
//                            
//                            
//                            
//                        }
//                        
//                   
//                        
//                        
//                    }
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.collectionView?.reloadData()
//                        
//                        if self.messages.count > 0 {
//                            
//                            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
//                            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
//                            
//                        }
//                        
//                        
//                    }
//                   
//                    
//                    
//                    
//                    
//                    
//                    
//                    
//                }
//                
//            }
//            
//            
//            
//        }catch {
//            
//            print(error)
//        }

    
        // Register cell classes
        self.collectionView!.register(ChatFilesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundView = backgroundV
        
        self.backgroundV.addSubview(BackgroundImageView)
        
        BackgroundImageView.topAnchor.constraint(equalTo: backgroundV.topAnchor).isActive = true
        BackgroundImageView.leftAnchor.constraint(equalTo: backgroundV.leftAnchor).isActive = true
        BackgroundImageView.heightAnchor.constraint(equalTo: backgroundV.heightAnchor).isActive = true
        BackgroundImageView.widthAnchor.constraint(equalTo: backgroundV.widthAnchor).isActive = true
        
        
        self.backgroundV.addSubview(blurView)
        
        
        blurView.topAnchor.constraint(equalTo: backgroundV.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: backgroundV.leftAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: backgroundV.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: backgroundV.widthAnchor).isActive = true
        
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
            
            BackgroundImageView.image = UIImage(data: profileImageData as Data)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    let tapToPopUpImage = PopDisplayImageView()


    func handlePopDisplayImage(gesture: UITapGestureRecognizer){
        
        if let imageView = gesture.view as? UIImageView {
            
            tapToPopUpImage.acceptAndLoadDisplayImage(imageView: imageView)
//            tapToPopUpImage.acceptAndLoadDisplayImage(imageView: imageView, incomingViewController: self)
 
            
            
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatFilesCollectionViewCell
        
        cell.displayImageView.isUserInteractionEnabled = true
        cell.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopDisplayImage)))
        
        let message = self.messages[indexPath.item]
        
        if let imageData = message.imageMessage {
            
            cell.displayImageView.image = UIImage(data: imageData as Data)
            
            
        }else if let imageURL = message.imageMessageURL {
            
           cell.displayImageView.sd_setImage(with: NSURL(string: imageURL) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
        }
         
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = self.view.frame.width / 3 - 1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
 


}
