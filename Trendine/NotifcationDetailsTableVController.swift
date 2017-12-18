//
//  NotifcationDetailsTableVController.swift
//  Trendin
//
//  Created by Rockson on 26/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation

class NotifcationDetailsTableVController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextViewDelegate {
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    let reuseIdentifier = "reuseIdentifier"
    var incomingObject: BmobObject?
    var incomingHeaderViewHeight: CGFloat?
    var userWhoCommented: BmobUser?

    var comments = [CommentObject]()
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    
 
    
    let headerView: UIView = {
       let hv = UIView()
        hv.backgroundColor = .white
//        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
        
    }()
    
    let imageContainerView: UIView = {
        let hv = UIView()
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
        
    }()
    
    lazy var dismissKeyboardButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "keyboard"), for: .normal)
        btn.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        return btn
        
    }()
    
    
    lazy var playVideoButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "PlayButton"), for: .normal)
        btn.addTarget(self, action: #selector(handlePlayVideoButton), for: .touchUpInside)
        return btn
        
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personplaceholder")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Rockson"
        label.textColor = .black
        label.numberOfLines = 2
        return label
        
    }()
    
    
    
    
    let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personplaceholder")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let CaptionLabel: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        label.isSelectable = false
        label.isScrollEnabled = false
        return label
    }()
    
    let videoPlayerView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.white
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 2
        bView.clipsToBounds = true
        return bView
        
    }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 2
        bView.clipsToBounds = true
        return bView
        
    }()
    
    
    lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleSendCommentButton), for: .touchUpInside)
        return button
        
    }()
    
    
     let commentTextView: UITextView = {
        let capText = UITextView()
        capText.font = UIFont.systemFont(ofSize: 16)
        capText.backgroundColor = .clear
        capText.translatesAutoresizingMaskIntoConstraints = false
        capText.layer.cornerRadius = 4
        capText.clipsToBounds = true
        capText.textColor = UIColor.white
        return capText
        
    }()
    
    let backgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.clipsToBounds = true
        bView.isHidden = true
        return bView
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
    }()
    
    
    var headerViewHeightConstraint: NSLayoutConstraint?
    
    func dismissKeyboard(){
        
       self.view.endEditing(true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadObject()
        
        self.sendCommentButton.isEnabled = false
        self.commentTextView.delegate = self
        


        tableView.contentInset = UIEdgeInsetsMake(0, 0, 56, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 56, 0)
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
//        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
        
        
        setUpViews()
        setUpCommentInPutViews()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationItem.title = "Post Details"

        if let height = incomingHeaderViewHeight {
            
            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
            tableView.tableHeaderView = headerView

            
        }
        
      tableView.register(NotifcationDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.comments.count > 0{
           let indexPath = NSIndexPath(item: self.comments.count  - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if self.player != nil {
//            
//            self.player.pause()
//            self.playerLayer.removeFromSuperlayer()
//        }
    }
    var postID: String?
    let popPlayVideo = PopUpAndPlayVideo()
    
    func handlePlayVideoButton(){
        
        if let url = self.videoURL, let postId = self.postID{
            
          popPlayVideo.handlePopVideoToSecreenAndPlay(url: NSURL(string: url)!, selectedObjectId: postId)
            
            
        }
        
        
        
        
    }
    
    
    func handleDismissKeyboard(){
        
        self.view.resignFirstResponder()
    }
    
    var commentMessage: String?
    
    func handleSendCommentButton(){
        
        if self.commentTextView.text != ""{
            
            if let commentText = self.commentTextView.text, let objId = self.incomingObject?.object(forKey: "postId") as? String {
                
                let comObject = CommentObject()
                comObject.comment = self.commentTextView.text
                comObject.commenter = BmobUser.current()
                comObject.commentId = objId
                comObject.createdAt = NSDate()
                
                self.comments.append(comObject)
                self.tableView.reloadData()
                
                if self.comments.count > 0 {
                    
                    let indexPath = NSIndexPath(item: self.comments.count  - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
                
                self.commentMessage = commentText
                self.commentTextView.text = ""
                self.view.endEditing(true)
                
                let TrendinComment = BmobObject(className: "TrendinComments")
                TrendinComment?.setObject(BmobUser.current(), forKey: "commenter")
                TrendinComment?.setObject(self.commentMessage, forKey: "comment")
                TrendinComment?.setObject(objId, forKey: "commentId")
                TrendinComment?.saveInBackground(resultBlock: { (success, error) in
                    if success{
                        
                        print("comment saved successfully")
                        
                        self.updatePost(className: "Trends", objId: objId, commentText: commentText)
                        
                    }else{
                        
                        print(error?.localizedDescription as Any)
                    }
                })
                
                
                
            }else{
                
                //Text field is empty....
            }  
            
        }
        
    }
    
    
    
    
    
    func updatePost(className: String , objId: String, commentText: String){
        sendCommentButton.isEnabled = false
        print("why1...")
        
        if let postId = self.incomingObject?.object(forKey: "postId") as? String {
            
            let query = BmobQuery(className: className)
//            query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
            query?.getObjectInBackground(withId: postId, block: { (Post, error) in
                if error == nil {
                    print("why...")
                    
                    if let trendinPost = Post, let numberOfCommnets = trendinPost.object(forKey: "numberOfComments") as? Int  {
                        
                        
                        print("why.444..")

                        let newNumOfComments = numberOfCommnets + 1
                        
                        Post?.setObject(newNumOfComments, forKey: "numberOfComments")
                        Post?.updateInBackground(resultBlock: { (success, error) in
                            if success {
                                
                                if let username = BmobUser.current().username,  let postedUser = self.userWhoCommented{
                                    
                                                                  
                                    if self.incomingObject != nil {
                                        
                                        if postedUser.objectId != BmobUser.current().objectId {
                                        
                                            
                                            
                                            let notify = BmobObject(className: "NotificationCenter")
                                            notify?.setObject(postedUser, forKey: "userToBeNotified")
                                            notify?.setObject("\(username) also commented on", forKey: "notificationReason")
                                            notify?.setObject(Post?.objectId, forKey: "postId")
                                            notify?.setObject(false, forKey: "userLikedIt")
                                            notify?.setObject(false, forKey: "addRequest")
                                            notify?.setObject(false, forKey: "addPoints")
                                            notify?.setObject(false, forKey: "pointsAccepted")
                                            notify?.setObject(false, forKey: "requestAccepted")
                                            
                                            
                                            notify?.setObject(false, forKey: "notified")
                                                
                                            
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
                            }else{
                                
                                print("update err...")
                                print(error?.localizedDescription as Any)
  
                            }
                        })
                        
                    }
                    
                }else{
                    
                    print("err...")

                    print(error?.localizedDescription as Any)
                }
            })
            
        }
        
        
    }
 
    
    
    
    
    
    
    func loadObject(){
  
        if let postId = self.incomingObject?.object(forKey: "postId") as? String{
            
            self.loadComments(postId: postId)
            self.backgroundBlurView.isHidden = false
            self.activityIndicator.startAnimating()

            
            let query = BmobQuery(className: "Trends")
            query?.includeKey("poster")
            query?.whereKey("objectId", equalTo: postId)
            query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
            query?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    self.backgroundBlurView.isHidden = true
                    self.activityIndicator.stopAnimating()
                   
                    DispatchQueue.main.async {
                      
                        
                        if results?.count  == 1 {
                            
                            
                            let object = results?.first as! BmobObject

                            self.processReceivedObject(object: object)
                            
                            if let poster = object.object(forKey: "poster") as? BmobUser {
                                
                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "MM-dd-yyyy EEE h:mm a"
                                dateFormatter.dateFormat = "MMMM dd, yyyy, EEEE h:mm a"

                                let stringFromDate = dateFormatter.string(from: object.createdAt as Date)
                                
                                let attributedMutableText = NSMutableAttributedString(string: poster.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)])
                                
                                let atrributedText = NSAttributedString(string: "\n\(stringFromDate)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.lightGray])
                                attributedMutableText.append(atrributedText)
                                
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.lineSpacing = 4
                                
                                attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
                                
                                self.usernameLabel.attributedText = attributedMutableText
                                
                                if let profileImageFile = poster.object(forKey: "profileImageFile") as? BmobFile {
                                    
                                self.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }else{
                    
                    self.backgroundBlurView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    
                }
            })
            
            
        }
        
        
    }
    
    
    func processReceivedObject(object: BmobObject){
        
       self.postID = object.objectId
        
        if object.object(forKey: "captionText") == nil && object.object(forKey: "imageFile") != nil {
            
            if let imageFile = object.object(forKey: "imageFile") as? BmobFile {
             
                if let h = object.object(forKey: "imageHeight") as? Float ,let w = object.object(forKey: "imageWidth") as? Float{
                    
                    let imageHeight = CGFloat(h) / CGFloat(w) * self.view.frame.width
                    self.displayImageHeightConstraint?.constant = imageHeight

                    
                }
                

                self.CaptionLabel.isHidden = true
                self.displayImageView.isHidden = false
                self.playVideoButton.isHidden = true


                   self.displayImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                
            }
            
          
            
        }else if object.object(forKey: "captionText") != nil && object.object(forKey: "imageFile") != nil {
            
            let text =  object.object(forKey: "captionText") as? String
            self.CaptionLabel.isHidden = false
            self.CaptionLabel.text = text
            self.playVideoButton.isHidden = true

            
            
            if let h = object.object(forKey: "imageHeight") as? Float ,let w = object.object(forKey: "imageWidth") as? Float{
                
                let imageHeight = CGFloat(h) / CGFloat(w) * self.view.frame.width
                self.displayImageHeightConstraint?.constant = imageHeight
                
                
            }

            
            self.displayImageView.isHidden = false

            
            if let imageFile = object.object(forKey: "imageFile") as? BmobFile {

            self.displayImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            }
            
        }
        
        if let statusText = object.object(forKey: "statusText") as? String {
            
            self.displayImageHeightConstraint?.constant = 0
            self.CaptionLabel.isHidden = false
            self.displayImageView.isHidden = true
            self.CaptionLabel.text = statusText
            self.playVideoButton.isHidden = true

            
            
        }
        
        //video
        
       if let videoFile = object.object(forKey: "videoFile") as? BmobFile {
        
        self.videoURL = videoFile.url
        
        self.playVideoButton.isHidden = false
        self.backgroundBlurView.isHidden = true
        self.displayImageView.isHidden = false
        
        self.displayImageHeightConstraint?.constant = 300


        
            if let text =  object.object(forKey: "videoCaptionText") as? String {
                
                self.CaptionLabel.isHidden = false
                self.CaptionLabel.text = text
            }
           
        if let videoPreview = object.object(forKey: "videoPreviewFile") as? BmobFile{
        
             self.displayImageView.sd_setImage(with: NSURL(string: videoPreview.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
            
            
        }
      
            
        }
        
    }
    
    var videoURL: String?
    func playVideo(url: NSURL, screen: UIImageView){
        
            self.player = AVPlayer(url: url as URL)
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer?.frame = screen.bounds
            screen.layer.addSublayer(playerLayer!)
            self.player?.play()
            
        
            
        
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
        
//        self.comments.append(commentObj)
        self.comments.insert(commentObj, at: 0)
        
    }
    
    
    
    func loadComments(postId: String){
       
        let query = BmobQuery(className: "TrendinComments")
        query?.order(byDescending: "createdAt")
        query?.whereKey("commentId", equalTo: postId)
        query?.includeKey("commenter")
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                    self.comments.removeAll(keepingCapacity: true)
                    
                    
                    for result in results!{
                        
                        self.processCommentsReceived(result: result as! BmobObject)
                        
                    }
                    
                    DispatchQueue.main.async {
                        

                        
                        self.tableView.reloadData()

                    }
                    
                    
                }
                
            }else{
                
                
                print(error?.localizedDescription as Any)
            }
        })
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    var displayImageHeightConstraint: NSLayoutConstraint?
    
    func setUpViews(){
        
        
//        self.view.addSubview(headerView)
//        
//        headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
//        headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 300)
//        headerViewHeightConstraint?.isActive = true
        
        self.view.addSubview(self.tableView)
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    
        

        headerView.addSubview(profileImageView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(imageContainerView)

        
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        profileImageView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true


        
      
       
        imageContainerView.addSubview(CaptionLabel)
        imageContainerView.addSubview(displayImageView)
        imageContainerView.addSubview(backgroundBlurView)
        imageContainerView.addSubview(playVideoButton)
        
        
        playVideoButton.centerXAnchor.constraint(equalTo: displayImageView.centerXAnchor).isActive = true
        playVideoButton.centerYAnchor.constraint(equalTo: displayImageView.centerYAnchor).isActive = true
        playVideoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playVideoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundBlurView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        backgroundBlurView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        backgroundBlurView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backgroundBlurView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        backgroundBlurView.addSubview(activityIndicator)
        
        activityIndicator.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        
        
        imageContainerView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        imageContainerView.topAnchor.constraint(equalTo:  usernameLabel.bottomAnchor).isActive = true
        imageContainerView.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        imageContainerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        
        CaptionLabel.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor).isActive = true
        CaptionLabel.topAnchor.constraint(equalTo:  imageContainerView.topAnchor).isActive = true
        CaptionLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        CaptionLabel.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor).isActive = true
        
        
        displayImageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor).isActive = true
        displayImageHeightConstraint = displayImageView.heightAnchor.constraint(equalToConstant: 0)
        displayImageHeightConstraint?.isActive = true
        
        
    }
    
    var blurViewHeightConstraint: NSLayoutConstraint?
    var bottomConstraints: NSLayoutConstraint?
    
    func setUpCommentInPutViews(){
        
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
        self.sendCommentButton.isEnabled = true
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let height = estimatedRect(text: self.commentTextView.text).height
        
        if height > 50 && height <= 150{
            
            self.blurViewHeightConstraint?.constant = height
            
            
        }
        
        
        return true
        
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotifcationDetailsTableViewCell
        
         let comment = self.comments[indexPath.row]
        
        
            cell.usernameLabel.text = comment.commenter?.username
            cell.usernameLabel.textColor = MessagesCollectionViewCell.blueColor
            cell.commentLabel.text = comment.comment
            
            if let profileImageFile = comment.commenter?.object(forKey: "profileImageFile") as? BmobFile {
                
            cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                    
                
            }
            
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy, EEEE h:mm a"
        let stringFromDate = dateFormatter.string(from: comment.createdAt as! Date)
        
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour , .minute], from: (comment.createdAt as? Date)!, to: NSDate() as Date)
        
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 10
        
        let object = self.comments[indexPath.row]
        if let comment = object.comment{
            
        height = self.estimatedRect(text: comment).height + 30
 
            
        }
        
    
        return height
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let commenter = self.comments[indexPath.row].commenter
        
            if let username = commenter?.username {
            self.commentTextView.becomeFirstResponder()

                
                let text = "@\(username): " + " "
                
                self.commentTextView.text = text
                
            }
            
            
        
    }
 
 

    func estimatedRect(text: String) -> CGRect {
        
        let width = self.view.frame.width - 40
        
        return NSString(string: text).boundingRect(with: CGSize(width: width , height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
        
    }

}
