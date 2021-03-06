//
//  MyMomentsCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 04/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class MyMomentsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    private let loadMoreCellId = "loadMoreCellId"
    private let headerViewIdentifier = "Cell"

    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
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
    
    var isLoadingOldPosts: Bool = false
    
    var objects = [TrendinObject]()
    
    var incomingUser: String?
    var rightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView?.addSubview(refresh)
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(slideDownNotificationMenu)
            slideDownNotificationMenu.addSubview(postImageView)
            slideDownNotificationMenu.addSubview(progressView)
            
            
            progressView.leftAnchor.constraint(equalTo: postImageView.rightAnchor, constant: 8).isActive = true
            progressView.rightAnchor.constraint(equalTo: slideDownNotificationMenu.rightAnchor, constant: -5).isActive = true
            progressView.centerYAnchor.constraint(equalTo: slideDownNotificationMenu.centerYAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
            
            postImageView.leftAnchor.constraint(equalTo: slideDownNotificationMenu.leftAnchor, constant: 8).isActive = true
            postImageView.centerYAnchor.constraint(equalTo: slideDownNotificationMenu.centerYAnchor).isActive = true
            postImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            postImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            slideDownNotificationMenu.frame = CGRect(x: 0, y: -80, width: window.frame.width, height: 80)
            
        }
        
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        if let comingID = incomingUser {
            
            if comingID == BmobUser.current().objectId {
             
                navigationItem.title = "My trends"

                
            }else{
                
                navigationItem.title = "Trends"
 
                
            }
        }
        
        
        let image = #imageLiteral(resourceName: "options")
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
        rightButton.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
        rightButton.setBackgroundImage(image, for: .normal)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        
//        options
        // Register cell classes
        self.collectionView!.register(MyMomentsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(LoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: loadMoreCellId)
        self.collectionView?.register(MyPageHeaderViewView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)


        
        // Do any additional setup after loading the view.
        
      
        if let userId = incomingUser{
            
            self.loadData(userId: userId)
  
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func handleRefresh(){
       
        if let userId = incomingUser{
            
            self.loadData(userId: userId)
            
        }
        
    }
    
    
    
    func prepareForChatRoom(){
        
        let AppDel = UIApplication.shared.delegate as! AppDelegate
        let moc = AppDel.persistentContainer.viewContext
        
        if let userId = self.incomingUser {
            
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            request.predicate = NSPredicate(format: "objectId == %@", userId)
            request.fetchLimit = 1
            
            do {
                let searchResults = try moc.fetch(request)
                
                if searchResults.count > 0  {
                
                    let query = BmobQuery(className: "_User")
                    query?.whereKey("objectId", equalTo: userId)
                    query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                    query?.findObjectsInBackground({ (users, error) in
                        if error == nil {
                            if (users?.count)! > 0 {
                                
                                for user in users! {
                                    
                                    if let newUser = user as? BmobUser {
                                        
                                        DispatchQueue.main.async {
                                            
                                            let layout = UICollectionViewFlowLayout()
                                            layout.minimumLineSpacing = 4
                                            let messagesVC = MessagesCollectionViewController(collectionViewLayout: layout)
                                            messagesVC.hidesBottomBarWhenPushed = true
                                            messagesVC.incomingUser = searchResults.first
                                            
                                            messagesVC.navigationItem.title = newUser.username
                                            
                                            if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
                                                
                                                messagesVC.incomingUserProfileImageURL = profileImageFile.url
                                            }
                                            
                                            self.navigationController?.pushViewController(messagesVC, animated: true)
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                        }else{
                            
                            
                        }
                    })
                
                
                }
                
                
            }catch{
                
                print(error)
            }
            
            
        }
        
        
    }
    
    
    func handleRightBarButton(){
      
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
//        alert.addAction(UIAlertAction(title: "Chat", style: .default, handler: { (action) in
//            
//           
//         self.prepareForChatRoom()
//            
//            ///////////////
//            
//        }))
        
        if let userId = self.incomingUser {
            
            if userId != BmobUser.current().objectId {
                
                alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (action) in
                    
                 
                  self.prepareToBlockUserInBackground(userId: userId)
                    
                    
                }))
                
                
                
            }
            
            
        }
        
        
        if let presenter = alert.popoverPresentationController {
            
            presenter.sourceView = self.rightButton
            presenter.sourceRect = self.rightButton.bounds
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func prepareToBlockUserInBackground(userId: String){
        
        let userToBeBlocked = BmobObject(outDataWithClassName: "_User", objectId: userId)
        let relation = BmobRelation()
        let currentUser = BmobUser.current()
        
        relation.remove(userToBeBlocked)
        currentUser?.add(relation, forKey: "friends")
        currentUser?.updateInBackground(resultBlock: { (success, error) in
            if success{
                
                print("successfully removed")
                
                let blockRelation = BmobRelation()
                blockRelation.add(userToBeBlocked)
                currentUser?.add(blockRelation, forKey: "blockedLists")
                currentUser?.updateInBackground(resultBlock: { (success, error) in
                    if success{
                        
                        print("blocklist updated")
                        
                        self.queryChatRoom(userId: userId)
                        
                        
                    }else{
                        
                        //                                    self.blockBlurView.isHidden = true
                        //                                    self.blockActivityIndicator.stopAnimating()
                        print(error?.localizedDescription as Any)
                        
                    }
                })
                
                
            }else{
                
                
                //                            self.blockBlurView.isHidden = true
                //                            self.blockActivityIndicator.stopAnimating()
                
                print(error?.localizedDescription as Any)
            }
        })
        
        
    }
    let currrentUser = BmobUser.current()
    
    func queryChatRoom(userId: String){
        
        let query1 = BmobQuery(className: "Room")
        let array1 = [["user1Id": self.currrentUser?.objectId] ,["user2Id": userId]]
        query1?.addTheConstraintByAndOperation(with: array1)
        query1?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query1?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                
                if results?.count == 0 {
                    //no room yet
                    
                    self.secondQuery(userId: userId)
                    
                    
                }else if (results?.count)! > 0 {
                    
                    for result in results!{
                        
                        self.finallyDeleteFoundRoom(roomObject: result as! BmobObject, userId: userId)
                        
                    }
                    
                }
                
            }else{
                
                //                self.blockBlurView.isHidden = true
                //                self.blockActivityIndicator.stopAnimating()
                
                //error
                
            }
        })
        
        
        
    }
    
    
    func secondQuery(userId: String){
        
        let query = BmobQuery(className: "Room")
        let array2 = [["user1Id": userId],  ["user2Id": currrentUser?.objectId]] as [Any]
        query?.addTheConstraintByAndOperation(with: array2)
        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query?.findObjectsInBackground({ (secondResults, error) in
            if error == nil {
                
                if (secondResults?.count)! > 0 {
                    
                    
                    for secondResult in secondResults!{
                        
                        self.finallyDeleteFoundRoom(roomObject: secondResult as! BmobObject, userId: userId)
                        
                        
                        
                    }
                    
                }else{
                    
                    //                    self.blockBlurView.isHidden = true
                    //                    self.blockActivityIndicator.stopAnimating()
                }
                
                
            }else{
                
                //                self.blockBlurView.isHidden = true
                //                self.blockActivityIndicator.stopAnimating()
                print(error?.localizedDescription as Any)
                
            }
        })
        
        
    }
    
    
    
    func finallyDeleteFoundRoom(roomObject: BmobObject, userId: String){
        
        roomObject.deleteInBackground({ (success, error) in
            if success{
                
                print("room deleted")
                
                
                let AppDel = UIApplication.shared.delegate as! AppDelegate
                let moc = AppDel.persistentContainer.viewContext
                
                let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", userId)
                
                do {
                    let searchResults = try moc.fetch(request)
                    
                    if searchResults.count > 0  {
                        
                        for result in searchResults {
                            
                            moc.delete(result)
                            
                            do {
                                
                                try moc.save()
                                print("user deleted from CoreData as well")
                                
                                //                                self.blockBlurView.isHidden = true
                                //                                self.blockActivityIndicator.stopAnimating()
                                
                                
                            }catch{
                                
                                print(error)
                            }
                            
                        }
                        
                    }
                    
                } catch {
                    
                    //                    self.blockBlurView.isHidden = true
                    //                    self.blockActivityIndicator.stopAnimating()
                    print("Error with request: \(error)")
                }
                
                
                
                
                
                
                
            }else{
                
                //
                //                self.blockBlurView.isHidden = true
                //                self.blockActivityIndicator.stopAnimating()
                
                print("Error deleting room \(error?.localizedDescription as Any)")
            }
        })
    }
    
    func loadData(userId: String){
        
        self.refresh.beginRefreshing()
        

            
            let user = BmobObject(outDataWithClassName: "_User", objectId: userId)
            
            let query = BmobQuery(className: "Trends")
            query?.includeKey("poster")
            query?.order(byDescending: "createdAt")
            query?.limit = 20
            query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
            query?.whereKey("poster", equalTo: user)
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
                    
                    
                    UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
                        
                        self.loadingObjectsLabel.alpha = 0
                        self.loadingObjectsActivityIndicator.isHidden = true
                        self.loadingObjectsView.alpha = 0
                        
                    }, completion: nil)
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
        
        
    }
    
    func handleLeftBarButton(){
        
        let shareTextVC = PreviewSelectedImageViewController()
//        shareTextVC.incomingTrendingVC = self
        shareTextVC.incomingUserIsForTextOnly = true
        let nav = UINavigationController(rootViewController: shareTextVC)
        self.present(nav, animated: true, completion: nil)
        
        
    }
    
    func loadOlderObjects(){
        
        self.isLoadingOldPosts = true
        
        
        print("loading old objects...")
        
        let query = BmobQuery(className: "Trends")
        query?.includeKey("poster")
        query?.order(byDescending: "createdAt")
        query?.limit = 20
        query?.whereKey("poster", equalTo: BmobUser.current())
        
        if let lastDate = self.objects.last?.createdAt {
            
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringFromDate = dateForm.string(from: lastDate as Date)
            
            let condiction1 = ["createdAt":["$lt":["__type": "Date", "iso": stringFromDate]]]
            let array =  [condiction1]
            query?.addTheConstraintByAndOperation(with: array)
            
        }
        
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
                print("loaded")
                self.isLoadingOldPosts = false
                
                if (results?.count)! > 0 {
                    
                    
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

    
 
 
    
    func handlePopToComments(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point),let cell = collectionView?.cellForItem(at: indexPath) as? MyMomentsCollectionViewCell {
            
            let selectedItem = self.objects[indexPath.item]
            //
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            
            let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
            commentVC.hidesBottomBarWhenPushed = true
            commentVC.incomingMyMomentsVC = cell
            commentVC.commentId = selectedItem.objectId
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
        
    }
    
    func handleGesturePopToComment(gesture: UITapGestureRecognizer){
        
        if let label = gesture.view {
            
            let point = label.convert(label.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point),let cell = collectionView?.cellForItem(at: indexPath) as? MyMomentsCollectionViewCell  {
                let selectedItem = self.objects[indexPath.item]
                
                let layout = UICollectionViewFlowLayout()
                layout.minimumLineSpacing = 0
                let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
                commentVC.incomingMyMomentsVC = cell
                commentVC.hidesBottomBarWhenPushed = true
                commentVC.commentId = selectedItem.objectId
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
                            
                        }
                    })
                    
                }
                
                
            }else{
                
                
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
                
                
            }
        })
        
        
    }
    
    func handleLikeButtonTapped(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point){
            
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
    
    var postToBeDeleted: TrendinObject?
    func handleOptionsButtonTapped(sender: UIButton){
        print("its ok......")
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.objects[indexPath.item]
            postToBeDeleted = selectedItem
            
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

              alert.modalPresentationStyle = .popover
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    
                    self.objects.remove(at: indexPath.item)
                    self.collectionView?.reloadData()
                    
                    let query = BmobQuery(className: "Trends")
                    query?.getObjectInBackground(withId: self.postToBeDeleted?.objectId, block: { (object, error) in
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
                
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let presenter = alert.popoverPresentationController {
                
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
                
                
            }
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    let PopOutVideoScreenAndPlay = PopUpAndPlayVideo()
    
    
    func popUpAndPlayVideoButtonTapped(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.objects[indexPath.item]
            if let url = selectedItem.videoUrl {
                
                PopOutVideoScreenAndPlay.handlePopVideoToSecreenAndPlay(url: url, selectedObjectId: selectedItem.objectId!)
                
            }
            
        }
        
    }
    
    
    let popAndShowImage = PopDisplayImageView()
 
    
    func handlePopImageView(gesture: UITapGestureRecognizer){
        
        if let imageView = gesture.view as? UIImageView {
            
            popAndShowImage.acceptAndLoadDisplayImage(imageView: imageView)
//            popAndShowImage.acceptAndLoadDisplayImage(imageView: imageView, incomingViewController: self)
            
            
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
        return self.objects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyMomentsCollectionViewCell
        cell.backgroundColor = UIColor.white
        
        let object = self.objects[indexPath.item]
        
        
        if objects.count == indexPath.row{
            
//            let loadMoreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: loadMoreCellId, for: indexPath) as! LoadMoreCollectionViewCell
//            
//            
            if self.isLoadingOldPosts == false {
                
                self.loadOlderObjects()
                
//                loadMoreViewCell.activityIndicator.startAnimating()
                
                
            }
//
//            
//            return loadMoreViewCell
        }
    
        
        
        
        cell.object = object
        self.setUpCell(object: object, cell: cell)

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy EEE h:mm a"
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
        
        cell.playButton.addTarget(self, action: #selector(popUpAndPlayVideoButtonTapped), for: .touchUpInside)
        
        cell.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopImageView)))
        cell.displayImageView.isUserInteractionEnabled = true
        
        
        
        if let videoDurationInSeconds = object.videoDuration {
            
            let secondsString = String(format: "%02d", Int(videoDurationInSeconds % 60))
            let minutesString = String(format: "%02d", Int(videoDurationInSeconds / 60))
            
            cell.videoDurationLabel.text = "\(minutesString):\(secondsString)"
            
        }

        
       return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 110
        var captionHeight: CGFloat = 0
        
//        if objects.count  == indexPath.row {
//            
//            height = 50
//            return CGSize(width: self.view.frame.width, height: height)
//            
//        }
        
        
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
            
            height = 300 + height + captionHeight
            
            return CGSize(width: self.view.frame.width, height: height)
            
            
            
        }
        
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: MyPageHeaderViewView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath) as? MyPageHeaderViewView
            
            if let pageView = headerView {
             
                if self.incomingUser == BmobUser.current().objectId {
                    
                   pageView.statusTextView.isEditable = true
                   pageView.statusTextView.isUserInteractionEnabled = true
                   pageView.statusTextView.isSelectable = true
                    
                }else{
                    
                    pageView.statusTextView.isEditable = false
                    pageView.statusTextView.isUserInteractionEnabled = false
                    pageView.statusTextView.isSelectable = false
                    
                    
                }
                
                
               
                
                self.setUpPageView(cell: pageView)

                
            }
            
//            headerView?.PopToSelfieContestImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTransitionToContestVC)))
            
            
            
        }
        
        return headerView!
    }
    
    func setUpPageView(cell: MyPageHeaderViewView){
        
        if let userId = self.incomingUser{
            
            let query = BmobUser.query()
            query?.limit = 1
            query?.whereKey("objectId", equalTo: userId)
            query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
            query?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    if let user = results?.first as? BmobUser {
                        
                        DispatchQueue.main.async {
                            
                            if let OnMind = user.object(forKey: "OnMind") as? String {
                                
                                cell.statusTextView.text = OnMind
                                
                            }
                            
                            if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                                
                                cell.backgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                            }
                            
                            if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                                
                                let attributedMutableText = NSMutableAttributedString(string: (user.username)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white])
                                
                                if let phoneNumber = user.object(forKey: "phoneNumber") as? String {
                                    
                                    let atrributedText = NSAttributedString(string: "\n\(phoneNumber)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.gray])
                                    attributedMutableText.append(atrributedText)
                                    
                                }else{
                                    
                                    if let email = user.email {
                                      
                                        let atrributedText = NSAttributedString(string: "\n\(email)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.gray])
                                        attributedMutableText.append(atrributedText)
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.lineSpacing = 4
                                
                                attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
                                
                                cell.userInformationLabel.attributedText = attributedMutableText
                                
                                cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                }
            })
            
            
            
        }
        
    

        
    }
    
//    func handleTransitionToContestVC(){
//        
//        
//        let competionVC = CompetitionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        competionVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(competionVC, animated: true)
//        
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 180)  // Header size
        
    }
    
    func setUpCell(object: TrendinObject, cell: MyMomentsCollectionViewCell){
        
        
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
            cell.displayImageView.sd_setImage(with: statusImageUrl as URL, placeholderImage: UIImage(named: "personplaceholder"))
            
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
            cell.videoPlayerView.sd_setImage(with: videoPreviewUrl as URL, placeholderImage: UIImage(named: "personplaceholder"))
            
            
            
        }else{
            
            cell.videoCaptionTextView.isHidden = true
            
            
        }
        
        
        
        
        
    }

    
       
    
    func estimatedRect(text: String) -> CGRect {
        
        let width = self.view.frame.width - 20
        return NSString(string: text).boundingRect(with: CGSize(width: width , height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        
    }



}
