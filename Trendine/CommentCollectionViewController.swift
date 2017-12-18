//
//  CommentCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 10/7/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class CommentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    private let reuseIdentifier = "Cell"
    private let headerViewIdentifier = "headerID"
    
    
    var commentId: String?
    var headerView: CommentHeaderView?
    
    var headerViewHeight: CGFloat = 0
    
    var comments = [CommentObject]()
    var incomingTrendinVC: TrendinCollectionViewCell?
    var incomingCompetionVC: CompetitionCollectionViewCell?
    var incomingMyMomentsVC: MyMomentsCollectionViewCell?
    var incomingContestStatusVC: ContestStatusCollectionViewCell?
    var incomingPublicVC: PublicTrendsCollectionViewCell?
    var TrendingVC: TrendinCollectionViewController?
    
    
        lazy var refresh: UIRefreshControl = {
            let RefreshC = UIRefreshControl()
            RefreshC.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            return RefreshC
    
        }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.clipsToBounds = true
        return bView
        
    }()

    
    lazy var sendCommentButton: UIButton = {
       let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleSendCommentButton), for: .touchUpInside)
        return button
        
    }()
    
    lazy var dismissKeyboardButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "keyboard"), for: .normal)
        btn.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        return btn
        
    }()
    
    
    lazy var commentTextView: UITextView = {
        let capText = UITextView()
        capText.text = self.addCaptionString
        capText.font = UIFont.systemFont(ofSize: 16)
        capText.backgroundColor = .clear
        capText.translatesAutoresizingMaskIntoConstraints = false
        capText.layer.cornerRadius = 4
        capText.clipsToBounds = true
        capText.textColor = UIColor.white
        return capText
        
    }()
    
    let addCaptionString = "Write comment..."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        
        
       self.collectionView?.addSubview(refresh)
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "Love"), style: .plain, target: self, action: #selector(handleRightBarButton))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        
        if self.incomingTrendinVC != nil {
            
            loadComments(className: "TrendinComments")
            
            self.countComments()
            
        }else if self.incomingCompetionVC != nil {
            
            loadComments(className: "ContestComments")
            rightBarButton.isEnabled = false
            
        }
    
        if self.incomingMyMomentsVC != nil {
            
            loadComments(className: "TrendinComments")
 
        }
        
        if self.incomingContestStatusVC != nil {
            
            loadComments(className: "ContestComments")
            rightBarButton.isEnabled = false
            
        }
        
        if self.incomingPublicVC != nil {
            
            loadComments(className: "TrendinComments")
 
            
        }
        
        collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.title = "Comments"
        self.commentTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        setUpViews()

        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        collectionView?.backgroundColor = UIColor.white
        // Register cell classes
        self.collectionView!.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView?.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    func handleRefresh(){
       
        if self.incomingTrendinVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "TrendinComments")
   
        }else if self.incomingCompetionVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "ContestComments")
 
            
        }
        
        if self.incomingMyMomentsVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "TrendinComments")
 
        }
        
        if self.incomingContestStatusVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "ContestComments")

            
        }
        
        if self.incomingPublicVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "TrendinComments")
            
            
        }
        
        
    }
    
    
    func dismissKeyboard(){
        
        self.view.endEditing(true)
    }
    
    var keepCount = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let VC = self.TrendingVC{
            
            VC.refreshTrends = false
  
            
        }
        
        if let cell = self.incomingTrendinVC {
            
            cell.commentLabel.text = "\(keepCount) comments"
        }
        
        if let cell = self.incomingCompetionVC {
            
            cell.commentsCountLabel.text = "\(self.comments.count)"
        }
        
        if let cell = self.incomingMyMomentsVC {
            
            cell.commentLabel.text = "\(self.comments.count) comments"

        }
        
        if let cell = self.incomingContestStatusVC {
            
            cell.commentsCountLabel.text = "\(self.comments.count)"
            
            
        }

    }
    
    
    func handleRightBarButton(){
        
        if let postId = self.commentId {
            
            let likeUsersVC = LikedUsersTableViewController()
            likeUsersVC.postId = postId
            self.navigationController?.pushViewController(likeUsersVC, animated: true)
            
        }
     
        
    }
    
    func handleSendCommentButton(){
    
        
        if self.incomingTrendinVC != nil {
            
            self.commentsFromTrendinVC()
            
        }else if self.incomingCompetionVC != nil {
            
            
           self.commentsFromContestVC()
            
        }
        
        if self.incomingMyMomentsVC != nil{
            
            self.commentsFromTrendinVC()

            
        }
        
        if self.incomingContestStatusVC != nil{
            
            self.commentsFromContestVC()
 
            
        }
        
        if self.incomingPublicVC != nil {
            
            self.commentsFromTrendinVC()
 
            
        }

        
    }
    
    func commentsFromTrendinVC(){
        
        
        if self.commentTextView.text != self.addCaptionString && self.commentTextView.text != "" {
            
            if let objId = self.commentId, let commentText = self.commentTextView.text {
                
                self.keepCount = keepCount + 1
                

                
                let comObject = CommentObject()
                comObject.comment = self.commentTextView.text
                comObject.commenter = BmobUser.current()
                comObject.commentId = BmobUser.current().objectId
                comObject.createdAt = NSDate()
                
                self.comments.append(comObject)
                self.collectionView?.reloadData()
                
                if self.comments.count > 0 {
                    
                   let indexPath = NSIndexPath(item: self.comments.count  - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
                
                self.view.endEditing(true)
                self.commentTextView.text = self.addCaptionString

                
                
                let TrendinComment = BmobObject(className: "TrendinComments")
                TrendinComment?.setObject(BmobUser.current(), forKey: "commenter")
                TrendinComment?.setObject(commentText, forKey: "comment")
                TrendinComment?.setObject(objId, forKey: "commentId")
                TrendinComment?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        print("comment saved")
                        
                      self.updatePost(className: "Trends",  objId: objId, commentText: commentText)
                        
                   
                        
                   
                        
                    }else {
                        
                        
                        print(error?.localizedDescription as Any)
                    }
                })
                
                
            }
        }else{
            
            
            //textview can't be nil
        }
       
        

    }

    
    func commentsFromContestVC(){
        
        if let objId = self.commentId , let commentText = self.commentTextView.text {
            
            let comObject = CommentObject()
            comObject.comment = commentText
            comObject.commenter = BmobUser.current()
            comObject.commentId = objId
            comObject.createdAt = NSDate()
            
            self.comments.append(comObject)
            self.collectionView?.reloadData()
            
            if self.comments.count > 0 {
                
                let indexPath = NSIndexPath(item: self.comments.count  - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
            
            self.view.endEditing(true)
            self.commentTextView.text = self.addCaptionString
            
            
            
            let TrendinComment = BmobObject(className: "ContestComments")
            TrendinComment?.setObject(BmobUser.current(), forKey: "commenter")
            TrendinComment?.setObject(commentText, forKey: "comment")
            TrendinComment?.setObject(objId, forKey: "commentId")
            TrendinComment?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    
                    print("comment saved")
                    self.updatePost(className: "Contest", objId: objId,commentText: "")
                    
                    
                }else {
                    
                    
                    print(error?.localizedDescription as Any)
                }
            })
            
            
        }else{
            
            
            // textfield can't be nil
        }
       
        
        
    }
//
   
    func loadMoreCommentsAfterRefresh(className: String){
        
        self.refresh.beginRefreshing()
        
        if let commentId = self.commentId {
            if let lastDate = self.comments.first?.createdAt {
                
                let query = BmobQuery(className: className)
                query?.order(byDescending: "createdAt")
                query?.whereKey("createdAt", lessThan: lastDate)
                query?.includeKey("commenter")
                let array = [["commentId": commentId]]
                query?.addTheConstraintByAndOperation(with: array)
                query?.limit = 30
                query?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        self.refresh.endRefreshing()

                        if (results?.count)! > 0 {
                            
                            
                            for result in results!{
                                
                                self.processLoadMoreCommentsReceived(result: result as! BmobObject)
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.collectionView?.reloadData()
                            }
                            
                            
                        }
                        
                    }else{
                        
                        self.refresh.endRefreshing()

                        print(error?.localizedDescription as Any)
                    }
                })
                
                
            }
            
 
        }
        
    }
    
    func countComments(){
        
        let query = BmobQuery(className: "TrendinComments")
        query?.whereKey("commentId", equalTo: commentId)
        query?.includeKey("commenter")
        query?.order(byDescending: "createdAt")
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.countObjectsInBackground({ (counted, error) in
            if error == nil {
                
                
                    self.keepCount = self.keepCount + Int(counted)
                
                
            }
        })
        
    }
    
    func loadComments(className: String){
        
        if let commentId = self.commentId {
            
            let query = BmobQuery(className: className)
            query?.whereKey("commentId", equalTo: commentId)
            query?.includeKey("commenter")
            query?.order(byDescending: "createdAt")
            query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
            query?.limit = 30
            query?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    
//                    if (results?.count)! > 10 {
//                        
//                        self.headerViewHeight = 40
//                    }
//                    
                    
                    if (results?.count)! > 0 {
                    self.comments.removeAll(keepingCapacity: true)
                        
                        
                        for result in results!{
                            
                          self.processCommentsReceived(result: result as! BmobObject)
                            
                        }
                        
                        DispatchQueue.main.async {
                            
//                            self.headerView?.loadMoreButton.isHidden = false
                            self.collectionView?.reloadData()
                        }
                        
                        
                    }
                    
                }else{
                    
                    
                    self.headerView?.loadMoreButton.isHidden = false
                    print(error?.localizedDescription as Any)
                }
            })
            
  
            
        }
        
    }
    
    
    
    
    func updatePost(className: String , objId: String, commentText: String){
        sendCommentButton.isEnabled = false

        
        let query = BmobQuery(className: className)
//        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query?.getObjectInBackground(withId: self.commentId, block: { (Post, error) in
            if error == nil {
                
               
                if let trendinPost = Post, let numberOfCommnets = trendinPost.object(forKey: "numberOfComments") as? Int  {
                    
                    let newNumOfComments = numberOfCommnets + 1
                    
                    Post?.setObject(newNumOfComments, forKey: "numberOfComments")
                    Post?.updateInBackground(resultBlock: { (success, error) in
                        if success {
                            
                            if let postedUser = Post?.object(forKey: "poster") as? BmobObject{
                                
                               
                                
                                        let installationQuery = BmobInstallation.query()
                                        installationQuery?.whereKey("userId", equalTo: postedUser.objectId)
                                
                                            let push = BmobPush()
                                            push.setQuery(installationQuery)
                                            push.setMessage("")
                                            push.sendInBackground({ (success, error) in
                                                if error == nil {
                                                    
                                                    print("push has been sent")
                                                    
                                                    
                                                }else{
                                                    
                                                    print(error?.localizedDescription as Any)
                                                    
                                                }
                                            })
                                            
                                            
                        
                                if self.incomingTrendinVC != nil || self.incomingMyMomentsVC != nil {
                                  
                                    if postedUser.objectId != BmobUser.current().objectId {
                                        
                                        let poster = BmobObject(outDataWithClassName: "_User", objectId: postedUser.objectId)
                                        
                                        
                                        let notify = BmobObject(className: "NotificationCenter")
                                        notify?.setObject(poster, forKey: "userToBeNotified")
                                        notify?.setObject(commentText, forKey: "notificationReason")
                                        notify?.setObject(Post?.objectId, forKey: "postId")
                                        notify?.setObject(false, forKey: "userLikedIt")
                                        notify?.setObject(false, forKey: "addRequest")
                                        notify?.setObject(false, forKey: "addPoints")
                                        notify?.setObject(false, forKey: "pointsAccepted")
                                        notify?.setObject(false, forKey: "requestAccepted")


                                        
                                        if poster?.objectId == BmobUser.current().objectId {
                                            
                                            notify?.setObject(true, forKey: "notified")
                                            
                                        }else{
                                            
                                            notify?.setObject(false, forKey: "notified")
                                            
                                        }
                                        notify?.setObject(BmobUser.current(), forKey: "responder")
                                        if let imageHeight = Post?.object(forKey: "imageHeight") as? Int {
                                            
                                            notify?.setObject(imageHeight, forKey: "imageHeight")
                                            
                                        }
                                        
                                        if let imageWidth = Post?.object(forKey: "imageWidth") as? Int {
                                            
                                            notify?.setObject(imageWidth, forKey: "imageWidth")
                                            
                                        }
                                        
                                        if let statusText = Post?.object(forKey: "statusText") as? String {
                                            
                                            let textHeight = Int(self.estimatedRect(text: statusText).height)
                                            notify?.setObject(textHeight, forKey: "statusTextHeight")
                                            
                                        }
                                        
                                        if let captionText = Post?.object(forKey: "captionText") as? String {
                                            
                                            let textHeight = Int(self.estimatedRect(text: captionText).height)
                                            notify?.setObject(textHeight, forKey: "captionTextHeight")
                                            
                                        }
                                        
                                        if let videoCaptionText = Post?.object(forKey: "videoCaptionText") as? String {
                                            
                                            let videoCaptionText = Int(self.estimatedRect(text: videoCaptionText).height)
                                            notify?.setObject(videoCaptionText, forKey: "videoCaptionText")
                                            
                                        }
                                        
                                        if Post?.object(forKey: "videoFile") as? BmobFile != nil {
                                            
                                            notify?.setObject(300, forKey: "videoFileHeight")
                                            
                                        }
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
                            
                            
                            print("object updated successfully  ")
                        }
                    })
                    
                }
                
            }
        })
        
        
        
    }
    
    func processLoadMoreCommentsReceived(result: BmobObject){
        
        let commentObj = CommentObject()
        commentObj.createdAt = result.createdAt as NSDate?
        commentObj.commentId = result.objectId
        
        if let commenter = result.object(forKey: "commenter") as? BmobUser {
            
            commentObj.commenter = commenter
            
        }
        
        if let comment = result.object(forKey: "comment") as? String {
            
            commentObj.comment = comment
            
        }
        
        self.comments.insert(commentObj, at: 0)

        
//        self.comments.append(commentObj)
//        self.comments.insert(commentObj, at: self.comments.count)
        
    }
    
    func processCommentsReceived(result: BmobObject){
        
        let commentObj = CommentObject()
        commentObj.createdAt = result.createdAt as NSDate?
        commentObj.commentId = result.objectId
        
        if let commenter = result.object(forKey: "commenter") as? BmobUser {
            
            commentObj.commenter = commenter
            
        }
        
        if let comment = result.object(forKey: "comment") as? String {
            
            commentObj.comment = comment
            
        }
        
        self.comments.insert(commentObj, at: 0)

        
//        self.comments.append(commentObj)
        
        
    }
    

    func loadContesComments(){
        
        
        if let objId = self.commentId , let commentText = self.commentTextView.text {
            
            let TrendinComment = BmobObject(className: "ContestComments")
            TrendinComment?.setObject(BmobUser.current(), forKey: "commenter")
            TrendinComment?.setObject(commentText, forKey: "comment")
            TrendinComment?.setObject(objId, forKey: "commentId")
            
            
        }
        
        
    }
    
    func keyboardWillShowNotification(notification: NSNotification){
        
        if let keyboardInfo = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraints?.constant = -(keyboardInfo.height)
        }
        
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
        
        
    }
    
    func keyboardWillHideNotification(notification: NSNotification){
        
        
        self.bottomConstraints?.constant = 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        sendCommentButton.isEnabled = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        
            let height = estimatedRect(text: self.commentTextView.text).height
            
            if height > 50 && height <= 150{
                
                self.blurViewHeightConstraint?.constant = height
                
                
            }
            
        
        return true
        
    }
    
    var blurViewHeightConstraint: NSLayoutConstraint?
    var bottomConstraints: NSLayoutConstraint?
    
    func setUpViews(){
        
        self.view.addSubview(blurView)
        blurView.addSubview(dismissKeyboardButton)

        blurView.addSubview(sendCommentButton)
        blurView.addSubview(commentTextView)
        
        
        dismissKeyboardButton.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 5).isActive = true
        dismissKeyboardButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 5).isActive = true
        dismissKeyboardButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissKeyboardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        commentTextView.rightAnchor.constraint(equalTo: sendCommentButton.leftAnchor, constant: -5).isActive = true
        commentTextView.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: dismissKeyboardButton.rightAnchor, constant: 5).isActive = true
        commentTextView.heightAnchor.constraint(equalTo: blurView.heightAnchor).isActive = true
        
        
        sendCommentButton.rightAnchor.constraint(equalTo: self.blurView.rightAnchor, constant: -8).isActive = true
        sendCommentButton.topAnchor.constraint(equalTo: self.blurView.topAnchor, constant: 5).isActive = true
        sendCommentButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendCommentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
        self.bottomConstraints = blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraints?.isActive = true
        
        blurView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        blurViewHeightConstraint = blurView.heightAnchor.constraint(equalToConstant: 40)
        blurViewHeightConstraint?.isActive = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         NotificationCenter.default.addObserver(self, selector: #selector(loadCommentsFromBackend), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        if self.comments.count > 0{
            
            let indexPath = NSIndexPath(item: self.comments.count  - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true   )
        }
    }
    
    
    func loadCommentsFromBackend(){
        
    
        if self.incomingTrendinVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "TrendinComments")

            
        }else if self.incomingCompetionVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "ContestComments")

            
            
        }
        
        if self.incomingMyMomentsVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "TrendinComments")
            
        }
        
        if self.incomingContestStatusVC != nil {
            
            self.loadMoreCommentsAfterRefresh(className: "ContestComments")
            
        }
        
    }
    
    var commentToBeDeleted: CommentObject?
    
    func handleLongPressDeleteComment(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .ended {
            
            if let label = gesture.view as? UILabel{
                let point = label.convert(label.bounds.origin, to: self.collectionView)
                if let indexPath = collectionView?.indexPathForItem(at: point) {
                    
                    let selectedItem = self.comments[indexPath.item]
                     self.commentToBeDeleted = selectedItem
                    
                    if let commenter = selectedItem.commenter {
                        if commenter.objectId == BmobUser.current().objectId {
                            
                            let alert = UIAlertController(title: "Delete comment", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ignore", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                                
                                self.comments.remove(at: indexPath.item)
                                self.collectionView?.reloadData()
                                
                                if let objectId = self.commentToBeDeleted?.commentId {
                                   
                                    if self.incomingTrendinVC != nil {
                                        
                                        
                                    self.deleteComment(className: "TrendinComments", objectId: objectId)
                                        
                                    }else if self.incomingCompetionVC != nil {
                                        
                                    self.deleteComment(className: "ContestComments", objectId: objectId)

                                     
                                        
                                    }
                                    
                                    if self.incomingMyMomentsVC != nil {
                                        
                                        self.deleteComment(className: "TrendinComments", objectId: objectId)
                                        
                                    }
                                    
                                    if self.incomingContestStatusVC != nil {
                                        
                                    self.deleteComment(className: "ContestComments", objectId: objectId)

                                     
                                        
                                    }
                                    
                                }
                                
                              
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
                
            }
            
            
            
        }
        
        
    }

    
    
    func deleteComment(className: String, objectId: String){
        
        let query = BmobQuery(className: className)
        query?.getObjectInBackground(withId: objectId, block: { (object, error) in
            if error == nil {
                
                
            object?.deleteInBackground({ (success, errror) in
                if success {
                    
                    print("comment deleted")
                    
                let queryTrendine = BmobQuery(className: "Trends")
                queryTrendine?.getObjectInBackground(withId: self.commentId, block: { (trend, error) in
                    if error == nil {
                     
                        if var numberOfComments = trend?.object(forKey: "numberOfComments") as? Int {
                            
                            numberOfComments = numberOfComments - 1
                            trend?.setObject(numberOfComments, forKey: "numberOfComments")
                            trend?.updateInBackground(resultBlock: { (success, error) in
                                if success {
                                    
                                    print("comment updated")
   
                                    
                                }else{
                                    
                                    print(error?.localizedDescription as Any)
   
                                    
                                }
                            })
                            
                        }
                        
                        
                    }else{
                        
                        
                        print(error?.localizedDescription as Any)
   
                    }
                })
                    
                    
                    
                    
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
            })
                
                
                
                
            }else{
                
                print(error?.localizedDescription as Any)
  
                
            }
        })
        
        
    }
    

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCollectionViewCell
       cell.backgroundColor = .white
        // Configure the cell
        
        cell.commentLabel.isUserInteractionEnabled = true
        cell.commentLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressDeleteComment)))
        
        let comment = self.comments[indexPath.item]
        
        if let commenter = comment.commenter, let commentContent = comment.comment {
            
            cell.commentLabel.text = commentContent
            
            cell.usernameLabel.text = commenter.username
            cell.usernameLabel.textColor = MessagesCollectionViewCell.blueColor
            
            if let profileImageFile = commenter.object(forKey: "profileImageFile") as? BmobFile {
                
                
            cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))

            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy EEE h:mm a"
        let stringFromDate = dateFormatter.string(from: comment.createdAt as! Date)
        
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour , .minute], from: (comment.createdAt as! Date), to: NSDate() as Date)
        
        
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
                        
                        
                        cell.timeStampLabel.text = "1 min"
                        
                    }else{
                        
                        cell.timeStampLabel.text = "\(mins) mins"
                        
                        
                    }
                    
                case 1:
                    
                    cell.timeStampLabel.text = "1 hour"
                    
                    
                default:
                    
                    cell.timeStampLabel.text = "\(hour) hours"
                }
                
                
                
            }else if day >= 1 {
                
                cell.timeStampLabel.text = stringFromDate
                
            }
            
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 10
        
        let comment = self.comments[indexPath.item]
        
        if let commentString = comment.comment {
            
            height = self.estimatedRect(text: commentString).height + 30
            
            return CGSize(width: self.view.frame.width, height: height)

        }
     
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    
    

    
    func handleLoadMoreComments(){
        
     print("hello there... prepping to load more...")
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commenter = self.comments[indexPath.item].commenter
        
        if let username = commenter?.username {
          
            let text = "@\(username): "
            
            self.commentTextView.text = text
            self.commentTextView.becomeFirstResponder()
            
        }
       
        
    }

    
    
    func estimatedRect(text: String) -> CGRect {
        
        let width = self.view.frame.width - 40
        
        return NSString(string: text).boundingRect(with: CGSize(width: width , height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
        
    }

    
    
}
