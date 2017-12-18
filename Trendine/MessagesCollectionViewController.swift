//
//  MessagesCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 9/27/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation




class MessagesCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout , UITextViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, NSFetchedResultsControllerDelegate{
    
    private let reuseIdentifier = "Cell"
    
     var messageObjects = [MessageObject]()
    let currentUser = BmobUser.current()
    var incomingUser: Contacts!
    var incomingImage: UIImage?
    
    var selectedNameCard: String?

    
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var audioRecorderSettings = [String: Int]()
    
    
    lazy var refresh: UIRefreshControl = {
        let RefreshC = UIRefreshControl()
        RefreshC.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return RefreshC
        
    }()
    
    lazy var previewSelectedImageView: UIImageView = {
       let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 5
        im.clipsToBounds = true
        im.isUserInteractionEnabled = true
        im.isHidden = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePreviewImageTapped)))
        return im
        
    }()
    
    
     let previewViewContainer: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let stickersPreviewViewContainer: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.isHidden = false
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var preListenToAudioImageView: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFill
        im.layer.cornerRadius = 5
        im.clipsToBounds = true
        im.isUserInteractionEnabled = true
        im.image = UIImage(named: "Volume")
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleListenToRecordedAudioTapped)))
        return im
        
    }()
    
    lazy var audioPreviewViewContainer: UIView = {
        let  view = UIView()
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleListenToRecordedAudioTapped)))
        return view
        
    }()
    
    lazy var deleteAudioButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(handleDeleteRecorderAudio), for: .touchUpInside)
        return btn
        
    }()
    
    
  

    let inputViewContainer: UIView = {
        let  view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let sendButtonAndAudioContainerView: UIView = {
        let  view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let textInputView: UITextView = {
        let view = UITextView()
        view.isEditable = true
        view.isSelectable = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.font = UIFont.systemFont(ofSize: 16)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var bottomConstraints: NSLayoutConstraint?
    
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = false
        button.isHidden = true
        button.backgroundColor = .clear
        return button
        
    }()
    
    
    lazy var attachmentButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAttachment)))
        return imageView
        
    }()
    
    
    lazy var stickersButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image =  #imageLiteral(resourceName: "RedHeart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStickerButtonTapped)))
        return imageView
        
    }()
   
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let actionCompletedlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let tapNameCardBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
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
        lb.text = "Adding..."
        return lb
        
    }()
    
    
    let tapToSendAudioLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.textAlignment = .center
        lb.text = "Tap to send"
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleListenToRecordedAudioTapped)))
        return lb
        
    }()
    
    let displayActionCompletedText: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.text = "Saved"
        return lb
        
    }()
    
    let blurViewRecordingMicrophone: UIImageView = {
        let ac = UIImageView()
        ac.contentMode = .scaleAspectFill
        ac.image = UIImage(named: "WhiteMicrophone")
        ac.translatesAutoresizingMaskIntoConstraints = false
        return ac
        
    }()
    
    let recordingLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
        
    }()
    

    
    lazy var tapToPopUpAudioRecorder: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "microphone")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handlePopUpMicrophone)))
        return imageView
        
    }()
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        request.predicate = NSPredicate(format: "roomId == %@", (self.incomingUser?.roomId)!)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        
        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResults.delegate  = self
        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
    }()
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        
//    }
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        if type == .insert {
//            
//            
//            
//        }
//    }
    
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    
    var recordingTimer:  Timer = {
        let timer = Timer()
        return timer
        
    }()
    
    var incomingUserProfileImageURL: String?
    var loadMore = false

//    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()

    
    func handleDeleteRecorderAudio(){
        
        print("delete...")
        
        if self.audioRecorder != nil {
            
            if self.audioPlayer != nil {
                
                self.audioPlayer.stop()
  
                
            }
            self.audioPreviewViewContainer.isHidden = true
            
            self.audioRecorder.deleteRecording()


        }
        
    }


    
    lazy var  scrollView: UIScrollView = {
       let sc = UIScrollView()
        sc.delegate = self
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.alpha = 0
        sc.minimumZoomScale = 1.0
        sc.maximumZoomScale = 6.0
        return sc
        
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()


//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange), name: NSNotification.Name(ReachabilityDidChangeNotificationName), object: nil)
//        
//        _ = reachability?.startNotifier()
//        
        
        

        
        
        self.collectionView?.addSubview(refresh)
        
        
        if let keyWindow = self.view {
            
            keyWindow.addSubview(blurView)
            
            
            blurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 140).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 140).isActive = true
            
            
            blurView.addSubview(blurViewRecordingMicrophone)
            blurView.addSubview(recordingLabel)

            
            
            blurViewRecordingMicrophone.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            blurViewRecordingMicrophone.heightAnchor.constraint(equalToConstant: 30).isActive = true
            blurViewRecordingMicrophone.widthAnchor.constraint(equalToConstant: 30).isActive = true
            blurViewRecordingMicrophone.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            
            
            
            recordingLabel.bottomAnchor.constraint(equalTo: blurViewRecordingMicrophone.topAnchor, constant: -8).isActive = true
            recordingLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            recordingLabel.widthAnchor.constraint(equalTo: blurView.widthAnchor).isActive = true
            recordingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            
            blurView.isHidden = true
            
            keyWindow.addSubview(tapNameCardBlurView)
            tapNameCardBlurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            tapNameCardBlurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            tapNameCardBlurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            tapNameCardBlurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            tapNameCardBlurView.addSubview(activityIndicator)
            
            activityIndicator.centerXAnchor.constraint(equalTo: tapNameCardBlurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: tapNameCardBlurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            tapNameCardBlurView.addSubview(displayText)
            
            displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 0).isActive = true
            displayText.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            displayText.widthAnchor.constraint(equalTo: blurView.widthAnchor).isActive = true
            displayText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            tapNameCardBlurView.isHidden = true
            
            
            
            
        }
        
        if let mainAppWindow = UIApplication.shared.keyWindow {
            
            mainAppWindow.addSubview(self.scrollView)
            scrollView.leftAnchor.constraint(equalTo: mainAppWindow.leftAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo:  mainAppWindow.topAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalTo: mainAppWindow.heightAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: mainAppWindow.widthAnchor).isActive = true
            
        }
        
        
        self.view.addSubview(actionCompletedlurView)
        
        actionCompletedlurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        actionCompletedlurView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        actionCompletedlurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        actionCompletedlurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        actionCompletedlurView.addSubview(displayActionCompletedText)
        
        displayActionCompletedText.centerXAnchor.constraint(equalTo: actionCompletedlurView.centerXAnchor).isActive = true
        displayActionCompletedText.centerYAnchor.constraint(equalTo: actionCompletedlurView.centerYAnchor).isActive = true
        displayActionCompletedText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        displayActionCompletedText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        actionCompletedlurView.isHidden = true
        
        self.textInputView.delegate = self
        
        if let incompleteText = UserDefaults.standard.object(forKey: (self.incomingUser?.roomId)!) as? String {
            
            self.textInputView.text = incompleteText
            
            
        }
        
        
        if self.textInputView.text != "" {
            
            self.sendButton.isHidden = false
            self.tapToPopUpAudioRecorder.isHidden = true
            
        }else{
            
            self.sendButton.isHidden = true
            self.sendButton.isEnabled = true
            self.tapToPopUpAudioRecorder.isHidden = false
            
        }
        
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 56, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 56, right: 0)
        collectionView?.alwaysBounceVertical = true
        
        if let backgroundImageData = UserDefaults.standard.object(forKey: "chatBackgroundImage") as? NSData {
            
            collectionView?.backgroundView = UIImageView(image: UIImage(data: backgroundImageData as Data))
            
        }
        
        
        collectionView?.backgroundView?.contentMode = .scaleAspectFill
        collectionView?.backgroundColor = UIColor.white
        self.collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismiss)))
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named:"IncomingUserInfo"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleRightBarButton)), animated: true)
        
        self.collectionView?.register(MessagesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.setUpInputViews()
    
      
    }

    
    var slideUpAndDown = false
    
    func handleStickerButtonTapped(){
       
        
        if slideUpAndDown == false {
            
            handleSlideShowStickers()
  
            
        }else if slideUpAndDown == true {
            
            handleSlideDismissStickers()
  
            
        }
        

        
        
        
    }
    
    
    
    
//    func reachabilityDidChange(notification: Notification){
//        
//        guard let r = reachability else { return }
//        if r.isReachable  {
//            
//            
//            //network...
//        } else {
//            
//            
//            self.alert(reason: "No internet connection detected or you're probably on a very slow network")
//            
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
    func handleSlideShowStickers(){
        
        self.scrollCollectionVToTheTop()

        
        self.slideUpAndDown = true
        self.textInputView.endEditing(true)
        self.bottomConstraints?.constant = 0
        
       

      
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        self.view.addSubview(stickersPreviewViewContainer)
        self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: view.frame.height - 8, width: view.frame.width, height: 200)

//        handleKeyboardDismiss()
        
        
//
//        
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            
//          
//            
//            
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
            
            self.bottomConstraints?.constant = -(200)
            self.view.layoutIfNeeded()
            
            
            
        }) { (completed) in
            
           
            
        }
        
        
      
        
    }
    
    func handleSlideDismissStickers(){

        
        self.slideUpAndDown = false

    
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 240)
            
            self.bottomConstraints?.constant = 0
            self.view.layoutIfNeeded()
                
                
            }, completion: nil)
        
        
    }
    
        func deleteNotifications(){
        
            if let roomId = self.incomingUser.roomId {
                
                let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
                let array = [["roomId": roomId], ["incomingUserId": BmobUser.current().objectId]]
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
                        
                    }else{
                        
                        print(error?.localizedDescription as Any)
                    }
                })
                
                
            }
            
            
            
            
        }
        
  
    
    func handleRefresh(){
        
//        self.loadData()
        
//        roomId == %@ ,
        if self.messageObjects.count > 0  {
            
            let lastMessage = self.messageObjects.first
          
            
            if let roomdId = lastMessage?.roomId , let lastdDate = lastMessage?.createdAt {
                
                let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
                fetch.predicate = NSPredicate(format: "roomId == %@ && createdAt < %@", roomdId, lastdDate)
                fetch.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                fetch.fetchLimit = 15
                
                
                do {
                    
                    let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                    print("found this... \(results.count)")
                    self.refresh.endRefreshing()
                    
                    if results.count > 0 {
                        
                        for result in results {
                            
                            
                            self.processLoadMoreMessages(message: result)
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            self.collectionView?.reloadData()
                        }
                        
                    }
                    
                }catch{
                    self.refresh.endRefreshing()

                    print(error.localizedDescription as Any)
                }
  
                
            }
            
            
            
        }
        
    }
    
    
    func handleListenToRecordedAudioTapped(){
        
        
        if self.audioPlayer != nil {
            
            self.audioPlayer.stop()
            self.audioPreviewViewContainer.isHidden = true
            let secsInCMT = CMTime(seconds: self.audioPlayer.duration, preferredTimescale: CMTimeScale.max)
            let durationInSeconds = Int(CMTimeGetSeconds(secsInCMT))
            
            
            
            
            let audioURL = self.directoryURL()
            let uniqueId = NSUUID().uuidString
            
            
            let messageObj = MessageObject()
            messageObj.createdAt = NSDate()
            messageObj.lastUpdate = NSDate()
            messageObj.senderId = self.currentUser?.objectId
            messageObj.roomId = self.incomingUser.roomId
            messageObj.senderName = self.currentUser?.username
            messageObj.delivered = true
            messageObj.objectId = uniqueId
            messageObj.audioURL = audioURL as NSURL?
            messageObj.audioDuration = Float(durationInSeconds)
            
            if let data = NSData(contentsOf: audioURL as URL) {
                
                messageObj.audioData = data
                
                self.messageObjects.append(messageObj)
                self.collectionView?.reloadData()
                
                let indexPath = NSIndexPath(row: self.messageObjects.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                
                
                
                self.saveAudioPermanentlyToCoreData(uniqueId: uniqueId, audioData: data, audioDuration: durationInSeconds)
                
                let audioFile = BmobFile(fileName: "audioMessage.mp3", withFileData: data as Data!)
                audioFile?.save(inBackground: { (success, error) in
                    if success{
                        
                        let backendMessage = BmobObject(className: "Messages")
                        backendMessage?.setObject(self.currentUser, forKey: "sender")
                        backendMessage?.setObject(durationInSeconds, forKey: "audioDuration")
                        backendMessage?.setObject(audioFile, forKey: "audioMessage")
                        backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                        backendMessage?.setObject(uniqueId, forKey: "uniqueId")
                        backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                        backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

                        
                        
                        let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
                        let currentUser = BmobUser.current()
                        
                        
                        let AccessControl = BmobACL()
                        AccessControl.setReadAccessFor(currentUser)
                        AccessControl.setReadAccessFor(receivingUser)
                        AccessControl.setWriteAccessFor(currentUser)
                        AccessControl.setWriteAccessFor(receivingUser)
                        
                        backendMessage?.acl = AccessControl
                        
                        
                        backendMessage?.saveInBackground(resultBlock: { (success, error) in
                            if success{
                                
                                print("audio message sent successfully")
//                                self.loadWhenSent()

                                let roomQuery = BmobQuery(className: "Room")
                                roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                                roomQuery?.findObjectsInBackground({ (results, error) in
                                    if error == nil {
                                        
                                        if (results?.count)! > 0 {
                                            
                                            
                                            if let name =  BmobUser.current().username {
                                                
                                                let installationQuery = BmobInstallation.query()
                                                installationQuery?.order(byDescending: "createdAt")
                                                installationQuery?.limit = 1
                                                installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                                
                                                
                                                let data = ["alert": "\(name) sent you an audio file", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                                
                                                
                                                let push = BmobPush()
                                                push.setQuery(installationQuery)
                                                push.setData(data)
                                                push.sendInBackground({ (success, error) in
                                                    if error == nil {
                                                        self.deleReadMessages()
                                                        
                                                        print("push has been sent")
                                                        
                                                        
                                                    }else{
                                                        
                                                        
                                                        print(error?.localizedDescription as Any)
                                                        
                                                    }
                                                })
                                                
                                                
                                            }
                                            
                                            
                                            let unreadMessage = BmobObject(className: "UnreadMesssages")
                                            unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                                            unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                                            unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                                if success{
                                                    
                                                    print("unread message sent successfully")
                                                    
                                                }else{
                                                    
                                                    print(error?.localizedDescription as Any)
                                                }
                                            })
                                            
                                            
                                            self.deleteNotifications()
                                            
                                        }else if results?.count == 0 {
                                            
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.showAlert()
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                })
  
                                
                               
                                
                                
                                
                                
                               
                                
                                
                                
                                
                            }else{
                                
                                
                                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                                request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                                
                                do {
                                    let searchResults = try self.moc.fetch(request)
                                    
                                    if let result = searchResults.first {
                                        
                                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                        
                                        try self.moc.save()
                                        print("user info updated")
                                        
                                    }
                                    
                                } catch {
                                    print("Error with request: \(error)")
                                }
                                
                                print(error?.localizedDescription as Any)
                            }
                        })
                        
                        
                        
                        
                    }else{
                        
                        print(error?.localizedDescription as Any)
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                        
                    }
                })
                
                
                
                
            }
            
            
            
            
            
            
            
            
        }
        
        
    }

    
    func directoryURL() -> URL {
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
        let stringFromDate = dateFormatter.string(from: currentDate as Date)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("\(stringFromDate).m4a")
        
        return soundURL! as URL
        
    }
    
    func handleRecordingTimer(){
        
        if self.startCount < 60 {
            
            self.startCount = startCount + 1
            
            let secondsString = String(format: "%02d", Int(startCount % 60))
            let minutesString = String(format: "%02d", Int(startCount / 60))
            
            self.recordingLabel.text = "\(minutesString):\(secondsString)"
            
            if self.startCount > 49 {
                
                self.recordingLabel.textColor = .red
            }
  
            
        }else if startCount == 60 {
            
          self.recordingTimer.invalidate()
          self.audioRecorder.stop()
            
            self.blurView.isHidden = true
            self.audioPreviewViewContainer.isHidden = false
            
            
            if self.audioRecorder != nil {
                
                
                self.textInputView.isHidden = false
                
                
            }

            
        }
        
    }
    var startCount: Int = 0
    
    func startRecordingAudio(){
        
        
        self.recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleRecordingTimer), userInfo: nil, repeats: true)
         self.recordingLabel.text = "00:00"
         self.startCount = 0

        recordingSession = AVAudioSession.sharedInstance()
        
        
        do {
            
        self.audioRecorder = try AVAudioRecorder(url: self.directoryURL(), settings: self.audioRecorderSettings)
            
            
        try self.recordingSession.setActive(true)
            self.audioRecorder.prepareToRecord()
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
            
        }catch{
            
            print(error.localizedDescription as Any)
        }
        
    }
    
    
    func setUpToRecordAudio(){
        
        
        self.audioRecorderSettings = [
            
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            
            
        ]
        
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try self.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.recordingSession.setActive(true)
            
            self.recordingSession.requestRecordPermission({ (allowed) in
                
                if allowed{
                    
                    //ready to record

                    self.blurView.isHidden = false

                    self.startRecordingAudio()

                    
                    
                }else{
                    
                    
                    // user decline microphone access
                }
                
            })
            
        }catch{
            
            print(error.localizedDescription as Any)
        }
        
        
    }
    
    
    
    
    
    func HandleAudioRecordingSession(longTap: UILongPressGestureRecognizer){
        
     
        
    }
    
    func finishedAudioRecording(url: NSURL){
        
        

            if !self.audioRecorder.isRecording {
                
              
                do {
                    
                  self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
                  self.audioPlayer.prepareToPlay()
                  self.audioPlayer.delegate = self
                  self.audioPlayer.volume = 1
                  self.audioPlayer.play()
                    
                    
                }catch{
                    
                    
                    print(error.localizedDescription as Any)
                }
                
                
            }
            
        

    }
    
    func handlePopUpMicrophone(longTap: UILongPressGestureRecognizer){
        
        self.handleKeyboardDismiss()
        
        if longTap.state == .began {
            
            self.setUpToRecordAudio()
            
        }else if longTap.state == .ended{
            
            self.blurView.isHidden = true
 
            
            if self.audioRecorder != nil {
                
                
                self.audioRecorder.stop()
                
                
            }
            
            
            
            
        }else if longTap.state == .failed {
           
            //hold the recorder down
            
            
        }

        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        do {
            
            try self.recordingSession.setCategory(AVAudioSessionCategoryPlayback)
  
            
        }catch{
            
            
            print(error.localizedDescription as Any)
        }
        
        self.recordingTimer.invalidate()
        self.recordingLabel.text = "00:00"
        self.startCount = 0
        
        
      

    
        
        if flag{
            
            
          

            self.finishedAudioRecording(url: directoryURL() as NSURL)
            
            if self.audioPlayer != nil {
                
                let secsInCMT = CMTime(seconds: self.audioPlayer.duration, preferredTimescale: CMTimeScale.max)
                let durationInSeconds = Int(CMTimeGetSeconds(secsInCMT))
                
                if durationInSeconds > 0 {
                    
                    self.audioPreviewViewContainer.isHidden = false
                    
                    
                }
                
            }
           

            
            if self.audioRecorder != nil {
                
                
                self.textInputView.isHidden = false
                
                
            }
 
        }
        
        
    }
    
    
    func saveAudioPermanentlyToCoreData(uniqueId: String, audioData: NSData,audioDuration: Int){
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)
        
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
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.audioMessage = audioData
        entity.roomId = self.incomingUser?.roomId
        entity.senderId = self.currentUser?.objectId
        entity.senderName = self.currentUser?.username
        entity.lastUpdate = NSDate()
        entity.createdAt = NSDate()
        entity.objectId = uniqueId
        entity.audioDuration = Float(audioDuration)

        
        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
            
            
        }catch {
            
            fatalError("error \(error)")
        }
  
        
    }
    
    var newImage: UIImage?
    
    func handlePreviewImageTapped(){
        

        
        if let previewImage = self.previewSelectedImageView.image {
            
           self.newImage = previewImage
            
            self.previewSelectedImageView.isHidden = true
            self.previewViewContainer.isHidden = true
        }
        
        if let image = self.newImage {
            
         
            let imageData = UIImageJPEGRepresentation(image, 0.2)
            
            let uniqueId = NSUUID().uuidString
            
            
            let messageObj = MessageObject()
            messageObj.senderId = self.currentUser?.objectId
            messageObj.createdAt = NSDate()
            messageObj.lastUpdate = NSDate()
            messageObj.imageHeight = Float(image.size.height)
            messageObj.imageWidth =  Float(image.size.width)
            messageObj.imageMessage = imageData as NSData?
            messageObj.objectId = uniqueId
            messageObj.delivered = true
            
            
            self.messageObjects.append(messageObj)
            self.collectionView?.reloadData()
            
            
            let indexPath = IndexPath(item: self.messageObjects.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath , at: .centeredVertically, animated: true)
          
            
            
            self.previewSelectedImageView.isHidden = true
            
//            cell?.activityIndicator.isHidden = false
//            cell?.activityIndicator.startAnimating()
            
//            let cell = self.collectionView?.cellForItem(at: indexPath) as? MessagesCollectionViewCell
//            cell?.activityIndicator.isHidden = true
    
                self.saveImageMessagePermanently(imageData: NSData(data: imageData!) as Data, uniqueId: uniqueId, imageSize: image.size)
            
            
                let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData)
                imageFile?.saveInBackground(byDataSharding: { (success, error) in
                    if success{
                        
                        print("file saved")
                        
                        
                        
                        let imageMessage = BmobObject(className: "Messages")
                        imageMessage?.setObject(self.currentUser, forKey: "sender")
                        imageMessage?.setObject(imageFile, forKey: "imageMessage")
                        imageMessage?.setObject(self.incomingUser?.roomId, forKey: "roomId")
                        imageMessage?.setObject(uniqueId, forKey: "uniqueId")
                        imageMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                        imageMessage?.setObject(image.size.height, forKey: "imageHeight")
                        imageMessage?.setObject(image.size.width, forKey: "imageWidth")
                        imageMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

                        
                        let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
                        let currentUser = BmobUser.current()

                        
                        let AccessControl = BmobACL()
                        AccessControl.setReadAccessFor(currentUser)
                        AccessControl.setReadAccessFor(receivingUser)
                        AccessControl.setWriteAccessFor(currentUser)
                        AccessControl.setWriteAccessFor(receivingUser)
                        
                        imageMessage?.acl = AccessControl
                        
                        
                        imageMessage?.saveInBackground(resultBlock: { (success, error) in
                            if success {

                                
                                let roomQuery = BmobQuery(className: "Room")
                                roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                                roomQuery?.findObjectsInBackground({ (results, error) in
                                    if error == nil {
                                        
                                        if (results?.count)! > 0 {
                                            
                                            if let name =  BmobUser.current().username {
                                                
                                                let installationQuery = BmobInstallation.query()
                                                installationQuery?.order(byDescending: "createdAt")
                                                installationQuery?.limit = 1
                                                installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                                
                                                let data = ["alert": "\(name) sent you an image", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                                
                                                
                                                let push = BmobPush()
                                                push.setQuery(installationQuery)
                                                push.setData(data)
                                                push.sendInBackground({ (success, error) in
                                                    if error == nil {
                                                        
                                                        print("push has been sent")
                                                        self.deleReadMessages()
                                                        
                                                        
                                                    }else{
                                                        
                                                        
                                                        print(error?.localizedDescription as Any)
                                                        
                                                    }
                                                })
                                                
                                                
                                          }
                                            
                                            
                                            
                                        let unreadMessage = BmobObject(className: "UnreadMesssages")
                                        unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                                        unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                                        unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                            if success{
                                                    
                                                    print("unread message sent successfully")
                                                    
                                                }else{
                                                    
                                                    print(error?.localizedDescription as Any)
                                                }
                                            })
                                            
                                            
                                            self.deleteNotifications()
                                            
                                            if let roomObject = results?.first as? BmobObject {
                                                
                                                roomObject.setObject(false, forKey: "newRoom")
                                                roomObject.updateInBackground(resultBlock: { (success, error) in
                                                    if success {
                                                        
                                                        print("room Updated")
                                                        
                                                    }else{
                                                        
                                                        print(error?.localizedDescription as Any)
                                                    }
                                                })
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }else if results?.count == 0 {
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.showAlert()

                                                
                                            }
    
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                })
                                
                              
                                
                                
                                
//                                cell?.activityIndicator.isHidden = true
//                                cell?.activityIndicator.stopAnimating()
                                
                               
                                print("image message sent succesfully")
                                
                               
                                
                                
                                
                            }else{
                            
                                
                                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                                request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                                
                                do {
                                    let searchResults = try self.moc.fetch(request)
                                    
                                    if let result = searchResults.first {
                                        
                                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                        
                                        try self.moc.save()
                                        print("user info updated")
                                        
                                    }
                                    
                                } catch {
                                    print("Error with request: \(error)")
                                }
                                
                                
                                
                                
                                
                                
                                print(error?.localizedDescription as Any)
                            }
                        })
                        
                    }else{
                        
                        
                        
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        print(error?.localizedDescription as Any)
                    }
                })
            
            }
            
        
        
    }

//    func processMessages(message: Messages){
//        
//        let messageObject = MessageObject()
//        
//        messageObject.objectId = message.objectId
//        messageObject.createdAt = message.createdAt
//        messageObject.senderId =  message.senderId
//        messageObject.delivered = message.sentOrFailed
//        messageObject.textMessage = message.textMessage
//        messageObject.senderName = message.senderName
//        messageObject.imageWidth = message.imageWidth
//        messageObject.imageHeight = message.imageHeight
//        messageObject.imageMessageURL = message.imageMessageURL
//        messageObject.imageMessage  = message.imageMessage
//        messageObject.audioData = message.audioMessage
//        messageObject.audioDuration = message.audioDuration
//        messageObject.nameCardId = message.nameCardId
//        messageObject.audioListened = message.audioListened
//        messageObject.roomId = message.roomId
//        
////        self.messageObjects.insert(messageObject, at: 0)
//        
//        self.messageObjects.append(messageObject)
//        
////        let count = self.messageObjects.count  - 1
////        let indexPath = NSIndexPath(row: count, section: 0)
////        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
//
//    }
    
    func processLoadMoreMessages(message: Messages){
        
//        let messageObject = MessageObject()
        
//        messageObject.objectId = message.objectId
//        messageObject.createdAt = message.createdAt
//        messageObject.senderId =  message.senderId
//        messageObject.delivered = message.sentOrFailed
//        messageObject.textMessage = message.textMessage
//        messageObject.senderName = message.senderName
//        messageObject.imageWidth = message.imageWidth
//        messageObject.imageHeight = message.imageHeight
//        messageObject.imageMessageURL = message.imageMessageURL
//        messageObject.imageMessage  = message.imageMessage
//        messageObject.audioData = message.audioMessage
//        messageObject.audioDuration = message.audioDuration
//        messageObject.nameCardId = message.nameCardId
//        messageObject.audioListened = message.audioListened
//        messageObject.roomId = message.roomId
        
        
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
        
        
//        self.messageObjects.insert(messageObject, at: 0)
        self.messageObjects.insert(messageObject, at: 0)
        
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

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
                
            }else{
                
                print(error?.localizedDescription as Any)
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.checkReachability()

        self.deleteNotifications()
        
        
        let addStickersView = AddStickersView()
        addStickersView.incomingVC = self
        addStickersView.translatesAutoresizingMaskIntoConstraints = false
        self.stickersPreviewViewContainer.addSubview(addStickersView)
        
        addStickersView.rightAnchor.constraint(equalTo: stickersPreviewViewContainer.rightAnchor).isActive = true
        addStickersView.leftAnchor.constraint(equalTo: stickersPreviewViewContainer.leftAnchor).isActive = true
        addStickersView.heightAnchor.constraint(equalTo: stickersPreviewViewContainer.heightAnchor).isActive = true
        addStickersView.centerYAnchor.constraint(equalTo: stickersPreviewViewContainer.centerYAnchor).isActive = true
        
        stickersPreviewViewContainer.backgroundColor = UIColor(white: 0.9, alpha: 1)
        addStickersView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(loadMessagesFromBackend), name: NSNotification.Name("reloadMessages"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       
        

        
//        if UserDefaults.standard.object(forKey: (self.incomingUser?.roomId)!) as? String != "" {
//            
//            self.textInputView.becomeFirstResponder()
//            
//        }
        
        self.loadMore = true
        
        self.loadMessagesFromBackend()


    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("reloadMessages"), object: nil)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//       self.srollView.isHidden = true
        
        if let incompleteText = self.textInputView.text, let roomId = self.incomingUser?.roomId {
            
            UserDefaults.standard.setValue(incompleteText, forKey: roomId)
        }
        
    }
    
    
    func addNameCard(selectedUser: Contacts){
        
        let currentUser = BmobUser.current()
        let uniqueId = NSUUID().uuidString

        
        let messageObj = MessageObject()
        
        messageObj.createdAt = NSDate()
        messageObj.objectId = selectedUser.objectId
        messageObj.senderName = currentUser?.username
        messageObj.roomId = selectedUser.roomId
        messageObj.delivered = true
        messageObj.senderId = currentUser?.objectId
        messageObj.lastUpdate = NSDate()
        messageObj.nameCardId = selectedUser.objectId
        if let phoneNum = selectedUser.phoneNumber {
        
            messageObj.phoneNumber = phoneNum
  
            
        }
        if let profileData = selectedUser.profileImageData {
            
            messageObj.nameCardProfilemageData = profileData
            
        }
        
        if let username = selectedUser.username{
            
            messageObj.username = username
            
        }
        
        self.messageObjects.append(messageObj)
        self.collectionView?.reloadData()
        
        let indexPath = NSIndexPath(item: self.messageObjects.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        
        self.saveNameCardPermanently(nameCard: selectedUser, uniqueId: uniqueId)

        let namedCard = BmobObject(className: "Messages")
        namedCard?.setObject(self.currentUser, forKey: "sender")
        namedCard?.setObject(selectedUser.objectId, forKey: "nameCardId")
        namedCard?.setObject(self.incomingUser.roomId, forKey: "roomId")
        namedCard?.setObject(uniqueId, forKey: "uniqueId")
        namedCard?.setObject(self.currentUser?.objectId, forKey: "senderId")
        namedCard?.setObject(selectedUser.username, forKey: "nameCardName")
        namedCard?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

        if let phoneNumb = selectedUser.phoneNumber {
          
            namedCard?.setObject(phoneNumb, forKey: "nameCardPhoneNumber")

            
        }
        
//        if let nameCardName = object.object(forKey: "nameCardName") as? String{
//            
//            entity.nameCardName = nameCardName
//            message.username = nameCardName
//            
//        }
//        
//        if let nameCardPhoneNumber = object.object(forKey: "nameCardPhoneNumber") as? String{
//            
//            entity.nameCardPhoneNumber = nameCardPhoneNumber
//            message.phoneNumber = nameCardPhoneNumber
//            
//        }
//        
        
        let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
        
        
        let AccessControl = BmobACL()
        AccessControl.setReadAccessFor(currentUser)
        AccessControl.setReadAccessFor(receivingUser)
        AccessControl.setWriteAccessFor(currentUser)
        AccessControl.setWriteAccessFor(receivingUser)
        
        namedCard?.acl = AccessControl
        
        namedCard?.saveInBackground(resultBlock: { (success, error) in
            if success{
               
//                self.loadWhenSent()
                
                
                let roomQuery = BmobQuery(className: "Room")
                roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                roomQuery?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                    
                        if (results?.count)! > 0 {
                            
                            if let name =  currentUser?.username {
                                
                                let installationQuery = BmobInstallation.query()
                                installationQuery?.order(byDescending: "createdAt")
                                installationQuery?.limit = 1
                                installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                
                                
                                let data = ["alert": "\(name) shared a contact", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                
                                
                                let push = BmobPush()
                                push.setQuery(installationQuery)
                                push.setData(data)
                                push.sendInBackground({ (success, error) in
                                    if error == nil {
                                        
                                        print("push has been sent")
                                        
                                        self.deleReadMessages()
                                        
                                        
                                        
                                    }else{
                                        
                                        
                                        print(error?.localizedDescription as Any)
                                        
                                    }
                                })
                                
                                
                            }
                            
                            
                            
                            let unreadMessage = BmobObject(className: "UnreadMesssages")
                            unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                            unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                            unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("unread message sent successfully")
                                    
                                }else{
                                    
                                    print(error?.localizedDescription as Any)
                                }
                            })
                            
                            print("nameCard saved successfully")
                            
                            
                            
                        }else if results?.count == 0 {
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                self.showAlert()
                                
                                
                            }
                            
                            
                          
                        }
                        
                        
                        
                    }
                })

              
                
                
                


                
                
              
                
            }else{
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                print(error?.localizedDescription as Any)
            }
        })
        

        
    }
    
    
    func saveNameCardPermanently(nameCard: Contacts, uniqueId: String){
        //Message got delivered to the backend so save it to coreData permanently
        //Cheers!!
        
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)
        
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
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.nameCardId = nameCard.objectId
        entity.nameCardProfileData = nameCard.profileImageData
        entity.nameCardName = nameCard.username
        if let phoneNumber = nameCard.phoneNumber {
            
          entity.nameCardPhoneNumber = phoneNumber
  
            
        }
        entity.roomId = self.incomingUser?.roomId
        entity.senderId = self.currentUser?.objectId
        entity.senderName = self.currentUser?.username
        entity.lastUpdate = NSDate()
        entity.createdAt = NSDate()
        entity.objectId = uniqueId
        
        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
            
            
        }catch {
            
            fatalError("error \(error)")
        }
        
    }
    
    
    func handleAttachment(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view {
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.modalPresentationStyle = .popover
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Share Contact", style: .default, handler: { (action) in
                
                
                let NameCardVC = NameCardTableViewController()
                NameCardVC.incomingViewController = self
                let navVC = UINavigationController(rootViewController: NameCardVC)
                self.present(navVC, animated: true, completion: nil)
                
                
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
                
            }
            self.present(alert, animated: true, completion: nil)
            
        }
    
    
        
    }
    
    
    
    func textViewDidChange(textView: UITextView) {
        
        if textView.text != "" {
            
            self.sendButton.isEnabled = true
            self.sendButton.isHidden = false
            self.tapToPopUpAudioRecorder.isHidden = true
            
        }else{
            
            self.sendButton.isEnabled = false
            self.sendButton.isHidden = true
            self.tapToPopUpAudioRecorder.isHidden = false
            
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        let height = estimatedRect(statusText: self.textInputView.text, fontSize: 17).height + 8
        
        if  height <= 150{
            
            self.inputContainerViewHeightConstraint?.constant = height
            
            
        }
        
        
        return  true
        
    }
    
  
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.previewSelectedImageView.image = image
            self.previewViewContainer.isHidden = false
            self.previewSelectedImageView.isHidden = false

            
        
        }
        
        self.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

//    var temArray = [MessageObject]()
    func processAndSaveReceivedObjectFromBackend(object: BmobObject){
        
        let message = MessageObject()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)
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
            
            message.objectId = uniqueId

        }
        
        if let sender = object.object(forKey: "sender") as? BmobUser {
            
            entity.senderId = sender.objectId
            entity.senderName = sender.username
            
            message.senderId = sender.objectId
            message.senderName = sender.username

 
        }
        
        
        if let roomId = object.object(forKey: "roomId") as? String {
            
            entity.roomId = roomId
            
            message.roomId = roomId

        }
        
        
        if let nameCardId = object.object(forKey: "nameCardId") as? String {
            
            entity.nameCardId = nameCardId
            
            message.nameCardId = nameCardId
            
            if let nameCardName = object.object(forKey: "nameCardName") as? String{
                
                  entity.nameCardName = nameCardName
                  message.username = nameCardName
                
            }
            
            if let nameCardPhoneNumber = object.object(forKey: "nameCardPhoneNumber") as? String{
                
                   entity.nameCardPhoneNumber = nameCardPhoneNumber
                   message.phoneNumber = nameCardPhoneNumber
                
            }
 
        }
        
        
        if let textMessage = object.object(forKey: "textMessage") as? String {
           
            entity.textMessage = textMessage
            
            message.textMessage = textMessage

            
        }

        
        if let imageFile = object.object(forKey: "imageMessage") as? BmobFile {
            
            let imageHeight = object.object(forKey: "imageHeight") as? Float
            let imageWidth = object.object(forKey: "imageWidth") as? Float
//            let imageData = NSData(contentsOf: NSURL(string: imageFile.url) as! URL)
            
//            entity.imageMessage = imageData as NSData?
            entity.imageHeight = imageHeight!
            entity.imageWidth = imageWidth!
            entity.imageMessageURL = imageFile.url

            message.imageMessageURL = imageFile.url
            message.imageWidth = imageWidth
            message.imageHeight = imageHeight

        }
        
        if let audioFile = object.object(forKey: "audioMessage") as? BmobFile {
          
            let audioDuration = object.object(forKey: "audioDuration") as? Int
            let audioData = NSData(contentsOf: NSURL(string: (audioFile.url)!) as! URL)
//            let audioURL = audioFile.url
            
            entity.audioMessage = audioData
            entity.audioDuration = Float(audioDuration!)
//            entity.audioURL = audioURL
            
            message.audioData = audioData
            message.audioDuration = Float(audioDuration!)
//            message.audioURL = NSURL(string: audioURL!)

            
        }
        
        
        if let stickerFile = object.object(forKey: "stickerFile") as? BmobFile {
            
            if let stickerId = object.objectId {
                
                entity.stickerId = stickerId
                
                message.stickerId = stickerId
                
            }
            
            if let width = object.object(forKey: "stickerWidth") as? Float {
                
                entity.stickerWidth = width
                
                message.stickerWidth = width
                
            }
            
            if let height = object.object(forKey: "stickerHeight") as? Float {
                
                entity.stickerHeight = height
                
                message.stickerHeight = height
            }
            
            if let stickerData = NSData(contentsOf: NSURL(string: stickerFile.url) as! URL){
            
                entity.stickerData = stickerData
                
                message.stickerData = stickerData
                
//                entity.stickerURL = stickerFile.url
//                message.stickerURL = stickerFile.url

                
            }
        
        }
        
        
//        let backendMessage = BmobObject(className: "Messages")
//        backendMessage?.setObject(self.currentUser, forKey: "sender")
//        backendMessage?.setObject(file, forKey: "stickerFile")
//        backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
//        backendMessage?.setObject(uniqueId, forKey: "uniqueId")
//        backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
//        backendMessage?.setObject(Int(size.width), forKey: "stickerWidth")
//        backendMessage?.setObject(Int(size.height) , forKey: "stickerHeight")
        
        
        message.delivered = true
        message.lastUpdate =  NSDate()
        message.createdAt = NSDate()
        
//        self.messageObjects.insert(message, at: 0)
//        self.messageObjects.append(message)
//        self.temArray.append(message)
        
//        var blockOperations = [BlockOperation]()
        
//        blockOperations.append(BlockOperation(block: { 
            self.messageObjects.append(message)
        
        
        

//        }))
        
        
//        self.messageObjects.insert(message, at: self.messageObjects.count)
        
        
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.lastUpdate =  NSDate()
        entity.createdAt = NSDate()
        
        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
        
            
        }catch {
            
            fatalError("error \(error)")
        }
        
    }
    
    var scrollToTheTop = false
    var objectsToBeReversed = [BmobObject]()

    func loadMessagesFromBackend(){
        
//    self.temArray.removeAll(keepingCapacity: true)

        
        let roomId = self.incomingUser.roomId
        
        
        let query = BmobQuery(className: "Messages")
        query?.limit = 20
        query?.order(byDescending: "createdAt")
        query?.includeKey("sender")
        let array  = [["roomId": roomId], ["receiverId": BmobUser.current().objectId]] as [Any]
        query?.addTheConstraintByAndOperation(with: array)
//        backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

        
//        if let lastObject = self.messageObjects.last {
//            
//        let lastDate = lastObject.lastUpdate
//        query?.whereKey("createdAt", greaterThan: lastDate)
//       
//
//
//       }
        query?.findObjectsInBackground { (results, error) in
            if error == nil {
                
                self.deleReadMessages()
                self.objectsToBeReversed.removeAll(keepingCapacity: true)
                


                if (results?.count)! > 0 {
                    
                    self.objectsToBeReversed = results as! [BmobObject]
                   let returnedObjects =  self.objectsToBeReversed.reversed()
                    
                    for result in returnedObjects {
                        
                         let object = result as BmobObject
                        let uniqueId = object.object(forKey: "uniqueId") as? String
                        
                            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                            request.fetchLimit = 100
                            request.predicate = NSPredicate(format: "objectId == %@", uniqueId!)
                            
                            do {
                                let searchResults = try self.moc.fetch(request)
                                
                                if searchResults.count == 0 {
                                    //check if message already exists or not
                                    
                                 self.scrollToTheTop = true
                                    
                                self.processAndSaveReceivedObjectFromBackend(object: object)
                                    
                                    
                                self.deleteMessageAfterReceive(object: object)
                                    
                                    
                                }
                                
                                
                            } catch {
                                print("Error with request: \(error)")
                            }
                            
                       
                            
                        
                        
                    }
                    
                    
                    //reload collectionView here
                    
                    DispatchQueue.main.async {
                        
                        
                        if self.scrollToTheTop == true {
                          self.scrollToTheTop = false
                            
//                            self.temArray.reverse()
//                            for tem in self.temArray {
//                                
//                                if !self.messageObjects.contains(tem) {
//                                    
//                                    self.messageObjects.append(tem)
//
//                                    
//  
//                                    
//                                }
//                                
//                            }
//                            self.messageObjects.reversed()
                            self.collectionView?.reloadData()
//                            self.temArray.removeAll(keepingCapacity: true)

                            
                            if self.messageObjects.count > 0 {
                                
                                let indexPath = NSIndexPath(row: self.messageObjects.count - 1, section: 0)
                                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                                
                            }
                            
                        }
   
                       
                        
                        
                    }
                    
                    
                        
                    }
                    
                
                
            }else{
                
                
                self.deleReadMessages()

                print(error?.localizedDescription as Any)
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
    
    func deleReadMessages(){
        
        if let roomId = self.incomingUser.roomId, let currentUserId = BmobUser.current().objectId {
            
            let unreadMessageQuery = BmobQuery(className: "UnreadMesssages")
            let array = [["roomId": roomId], ["incomingUserId": currentUserId]]
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
                    
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
            })
            
        }
       
        
    }
    
  
    
    func loadWhenSent(){
        

        
        print("sendt loading now...")
        
        let roomId = self.incomingUser.roomId
    
        
        let query = BmobQuery(className: "Messages")
        query?.limit = 30
        query?.order(byDescending: "createdAt")
        query?.includeKey("sender")
//        query?.whereKey("senderId", equalTo: self.incomingUser.objectId!)
        let array  = [["roomId": roomId], ["senderId": self.incomingUser!.objectId!]] as [Any]
        query?.addTheConstraintByAndOperation(with: array)
        query?.findObjectsInBackground { (results, error) in
            if error == nil {
               
                self.deleReadMessages()

                if (results?.count)! > 0 {
                    
                    for result in results! {
                        
                        if let object = result as? BmobObject , let uniqueId = object.object(forKey: "uniqueId") as? String{
                            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                            request.fetchLimit = 100
                            request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                            
                            do {
                                let searchResults = try self.moc.fetch(request)
                                
                                if searchResults.count == 0 {
                                    //check if message already exists or not
                                    
                                    self.scrollToTheTop = true
                                    
                                    self.processAndSaveReceivedObjectFromBackend(object: object)
                                    
                                    
                                }
                                
                                
                            } catch {
                                print("Error with request: \(error)")
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    //reload collectionView here
                    
                    DispatchQueue.main.async {
                        
                        
                        if self.scrollToTheTop == true {
                            self.scrollToTheTop = false
                     
                            self.collectionView?.reloadData()

                            
                            if self.messageObjects.count > 0 {
                                
                                let indexPath = NSIndexPath(row: self.messageObjects.count - 1, section: 0)
                                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }else{
                
                print(error?.localizedDescription as Any)
            }
        }
        
        
        
        
        
    }
    
    var fetchedImage: UIImage?

    func fetchImageOnlineWithStringURL(urlString: String) -> UIImage?{

        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return cachedImage
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                return
            }
            
            
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.fetchedImage = downloadedImage
                }
                
            
            
        }).resume()
        
        
        

        return nil

        
    }
    
    func sendSticker(stickerData: NSData, size: CGSize){
        
        let uniqueId = NSUUID().uuidString

        
        
        let localMessage = MessageObject()
        localMessage.senderId = currentUser?.objectId
        localMessage.stickerData = stickerData
        localMessage.delivered = true
        localMessage.createdAt = NSDate()
        localMessage.objectId = uniqueId
        localMessage.stickerWidth = Float(size.width)
        localMessage.stickerHeight = Float(size.height)
        
        self.messageObjects.append(localMessage)
        
        
        
        self.collectionView?.reloadData()
        
        let indexPath = NSIndexPath(item: self.messageObjects.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        
        
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)
        
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
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages

      
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.roomId = self.incomingUser?.roomId
        entity.senderId = self.currentUser?.objectId
        entity.senderName = self.currentUser?.username
        entity.stickerData = stickerData
        entity.lastUpdate = NSDate()
        entity.createdAt = NSDate()
        entity.objectId = uniqueId
        entity.stickerHeight = Float(size.height)
        entity.stickerWidth = Float(size.width)
        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
            
            
        }catch {
            
            fatalError("error \(error)")
        }
        

       
        
        let file = BmobFile(fileName: "image.GIF", withFileData: stickerData as Data!)
         file?.save(inBackground: { (success, error) in
            if error == nil {
                print("file saved...")
                
                let backendMessage = BmobObject(className: "Messages")
                backendMessage?.setObject(self.currentUser, forKey: "sender")
                backendMessage?.setObject(file, forKey: "stickerFile")
                backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                backendMessage?.setObject(uniqueId, forKey: "uniqueId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                backendMessage?.setObject(Int(size.width), forKey: "stickerWidth")
                backendMessage?.setObject(Int(size.height) , forKey: "stickerHeight")
                backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")



                
                let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
                
                let AccessControl = BmobACL()
                AccessControl.setReadAccessFor(self.currentUser)
                AccessControl.setReadAccessFor(receivingUser)
                AccessControl.setWriteAccessFor(self.currentUser)
                AccessControl.setWriteAccessFor(receivingUser)
                
                backendMessage?.acl = AccessControl
                backendMessage?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        //sent
//                        self.loadWhenSent()
                        
                        
                        if  let name =  BmobUser.current().username {
                            
                            let installationQuery = BmobInstallation.query()
                            installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                            
                            
                            let data = ["alert": "\(name) sent you a sticker", "badge": 1, "sound": "notification.caf"] as [String : Any]
                            
                            
                            let push = BmobPush()
                            push.setQuery(installationQuery)
                            push.setData(data)
                            push.sendInBackground({ (success, error) in
                                if error == nil {
                                    
                                    print("push has been sent")
                                    self.deleReadMessages()
                                    
                                    
                                }else{
                                    
                                    
                                    print(error?.localizedDescription as Any)
                                    
                                }
                            })
                            
                            
                        }
                        
                        
                        
                        let unreadMessage = BmobObject(className: "UnreadMesssages")
                        unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                        unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                        unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                            if success{
                                
                                print("unread message sent successfully")
                                
                            }else{
                                
                                print(error?.localizedDescription as Any)
                            }
                        })
                        
                        
                        let roomQuery = BmobQuery(className: "Room")
                        roomQuery?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                        roomQuery?.getObjectInBackground(withId: self.incomingUser.roomId, block: { (roomObject, error) in
                            if error == nil {
                                
                                roomObject?.setObject(false, forKey: "newRoom")
                                roomObject?.updateInBackground(resultBlock: { (success, error) in
                                    if success {
                                        
                                        print("room Updated")
                                        
                                    }else{
                                        
                                        print(error?.localizedDescription as Any)
                                    }
                                })
                                
                                
                                
                            }
                        })
                        
                    }else{
                        
                        //error
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                        
                        
                    }
                })
                
                
                
            }else{
                
                
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                
                
            }
         })
        
        

        
    }
    
    func handleSend(){
        
        
//        if UserDefaults.standard.object(forKey: (self.incomingUser?.roomId!)!) != nil {
//            
//            UserDefaults.standard.removeObject(forKey: (self.incomingUser?.roomId)!)
//        }
        
        self.sendButton.isEnabled = false
        self.sendButton.isHidden = true
        self.tapToPopUpAudioRecorder.isHidden = false
        self.inputContainerViewHeightConstraint?.constant = 50
     
        if let textMessage = self.textInputView.text {
            
            let localMessage = MessageObject()
//
//            //send messages button tapped
//            //Prepare and append the message into the messages array for user experience.. Save message to backend after that
                let uniqueId = NSUUID().uuidString
//
                localMessage.textMessage = textMessage
                localMessage.senderId = currentUser?.objectId
                localMessage.delivered = true
                localMessage.createdAt = NSDate()
                localMessage.lastUpdate = NSDate()
                localMessage.objectId = uniqueId
            
                self.messageObjects.append(localMessage)
                self.collectionView?.reloadData()
                self.textInputView.text = ""
//
//            
                let indexPath = NSIndexPath(item: self.messageObjects.count - 1, section: 0)
                collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
          
            
//                cell?.activityIndicator.isHidden = false
//                cell?.activityIndicator.startAnimating()

                
            
            self.saveMessagePermanently(textMessage: textMessage, uniqueId: uniqueId)
            
            let backendMessage = BmobObject(className: "Messages")
            backendMessage?.setObject(self.currentUser, forKey: "sender")
            backendMessage?.setObject(textMessage, forKey: "textMessage")
            backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
            backendMessage?.setObject(uniqueId, forKey: "uniqueId")
            backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
            backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

            
            let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
            
            let AccessControl = BmobACL()
            AccessControl.setReadAccessFor(currentUser)
            AccessControl.setReadAccessFor(receivingUser)
            AccessControl.setWriteAccessFor(currentUser)
            AccessControl.setWriteAccessFor(receivingUser)
            
            backendMessage?.acl = AccessControl
            backendMessage?.saveInBackground { (success, error) in
                if error == nil {
                    
//                    self.loadWhenSent()
   

                    print("Message delivered to the backend")
                    
                   
                    let roomQuery = BmobQuery(className: "Room")
                    roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                    roomQuery?.findObjectsInBackground({ (results, error) in
                        if error == nil {
                            
                            if (results?.count)! > 0 {
                                
                                if  let name =  BmobUser.current().username {
                                    
                                    let installationQuery = BmobInstallation.query()
                                    installationQuery?.order(byDescending: "createdAt")
                                    installationQuery?.limit = 1
                                    installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                    
                                    
                                    let data = ["alert": "\(name): \(textMessage)", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                    
                                    
                                    let push = BmobPush()
                                    push.setQuery(installationQuery)
                                    push.setData(data)
                                    push.sendInBackground({ (success, error) in
                                        if error == nil {
                                            
                                            print("push has been sent")
                                            self.deleReadMessages()
                                            
                                            
                                        }else{
                                            
                                            
                                            print(error?.localizedDescription as Any)
                                            
                                        }
                                    })
                                    
                                    
                                }
                                
                                
                                
                                let unreadMessage = BmobObject(className: "UnreadMesssages")
                                unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                                unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                                unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                    if success{
                                        
                                        print("unread message sent successfully")
                                        
                                    }else{
                                        
                                        print(error?.localizedDescription as Any)
                                    }
                                })
                                
                                
                                self.deleteNotifications()
                                
                                
                                if let roomObject = results?.first as? BmobObject {
                                    
                                    roomObject.setObject(false, forKey: "newRoom")
                                    roomObject.updateInBackground(resultBlock: { (success, error) in
                                        if success {
                                            
                                            print("room Updated")
                                            
                                        }else{
                                            
                                            print(error?.localizedDescription as Any)
                                        }
                                    })
                                    
                                    
                                    
                                }
                                
                                
                            }else if results?.count == 0 {
                                
                                DispatchQueue.main.async {
                                    
                                    
                                self.showAlert()
                                  //////
                                }
                                
                                
                            }
                            
                        }
                    })
                  
                    
                    
                    
//                    cell?.activityIndicator.isHidden = true
//                    cell?.activityIndicator.stopAnimating()
                    
            
                    
                }else{
                    
                    
                    let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                    request.predicate = NSPredicate(format: "objectId == %@", uniqueId)
                    
                    do {
                        let searchResults = try self.moc.fetch(request)
                        
                        if let result = searchResults.first {
                            
                            result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                            
                            try self.moc.save()
                            print("user info updated")
                            
                        }
                        
                    } catch {
                        print("Error with request: \(error)")
                    }
                    
                    
                    //Error sending TextMessage
                    
                }
            }
            
        }
        
        
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Message rejected!", message: "Message was sent but it's been rejected. User might have blocked the chat", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveMessagePermanently(textMessage: String, uniqueId: String){
        //Message got delivered to the backend so save it to coreData permanently
        //Cheers!!
    
        
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)

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
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.textMessage = textMessage
        entity.roomId = self.incomingUser?.roomId
        entity.senderId = self.currentUser?.objectId
        entity.senderName = self.currentUser?.username
        entity.lastUpdate = NSDate()
        entity.createdAt = NSDate()
        entity.objectId = uniqueId

        
        do {
            
            try self.moc.save()
            print("successfully saved to coreData permanently")
            
            
            
        }catch {
            
            fatalError("error \(error)")
        }
        
    }
    
    
    func saveImageMessagePermanently(imageData: Data, uniqueId: String , imageSize: CGSize){
        //Message got delivered to the backend so save it to coreData permanently
        //Cheers!!
        
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.predicate = NSPredicate(format: "objectId == %@", (self.incomingUser?.objectId)!)
        
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
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: self.moc) as! Messages
        
        entity.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
        entity.imageMessage = imageData as NSData?
        entity.roomId = self.incomingUser?.roomId
        entity.senderId = self.currentUser?.objectId
        entity.senderName = self.currentUser?.username
        entity.lastUpdate = NSDate()
        entity.createdAt = NSDate()
        entity.objectId = uniqueId
        entity.imageHeight = Float(imageSize.height)
        entity.imageWidth = Float(imageSize.width)
        
        
        do {
            
            try self.moc.save()
            print("image Message successfully saved to coreData permanently")
            
            
            
        }catch {
            
            fatalError("error \(error)")
        }
        
    }
    
    
    func handleRightBarButton(){
        
        
      
        if let user  = self.incomingUser {
            
            let chatDetailsVC = ChatDetailsTableViewController(style: .grouped)
            chatDetailsVC.incomingUser = user
            self.navigationController?.pushViewController(chatDetailsVC, animated: true)
        }
      
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.scrollCollectionVToTheTop()
        
        
    }
    
    func scrollCollectionVToTheTop(){
        
        if self.messageObjects.count > 0 {
            
            let indexPath = NSIndexPath(item: self.messageObjects.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .centeredVertically, animated: true)
        }
        
        
    }
    
    func handleKeyboardDismiss(){
        
        handleSlideDismissStickers()
        

        
        self.textInputView.endEditing(true)
        self.bottomConstraints?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.hasText == true {
            
            self.sendButton.isEnabled = true
            self.sendButton.isHidden = false
            self.tapToPopUpAudioRecorder.isHidden = true
            
        }else{
            
            self.sendButton.isEnabled = false
            self.sendButton.isHidden = true
            self.tapToPopUpAudioRecorder.isHidden = false
            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let height = estimatedRect(statusText: self.textInputView.text, fontSize: 16).height
        
                if height > 50 && height <= 150{
        
                    self.inputContainerViewHeightConstraint?.constant = height
        
        
                }
                
                
                return  true
    }

    
    func handleKeyboardWillShowNotification(notification: NSNotification){
        
        if let keyboardInfo = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            handleSlideDismissStickers()

            
            self.bottomConstraints?.constant = -(keyboardInfo.height)
        }

            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
                }, completion: nil)
            
            
        
        
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification){

        
        self.bottomConstraints?.constant = 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    func hideImageSavedDisplay(){
        
        self.actionCompletedlurView.isHidden = true
  
        
    }
    
//    func handleImageSaved(){
//        
//      print("image saved successfully")
//        
//        self.actionCompletedlurView.isHidden = false
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(hideImageSavedDisplay), userInfo: nil, repeats: false)
//
//        
//    }
    
    func handleSaveImageLongTap(gesture: UILongPressGestureRecognizer){
        
        if let imageView = gesture.view as? UIImageView {
         
            if gesture.state == .began {
                
                if let image = imageView.image {
                    
                    self.slideAlert.setUpSlideView(image: image)
//                    self.slideAlert.setUpSlideView(image: image, presentingViewControla: self)

                    
                }

  
            }

            
        }
  
        
    }
    
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return zoomingImageView
        
    }
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var zoomingImageView: UIImageView?

    
//    var scrollView: UIScrollView = {
//       let scv = UIScrollView()
//        return scv
//    }()
//    
    
    let slideAlert = SlideUpActionSheet()
    
    func handleImageTap(gesture: UITapGestureRecognizer){
        if let startingImageView = gesture.view as? UIImageView {
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView?.contentMode = .scaleAspectFit
            zoomingImageView?.image = startingImageView.image
            zoomingImageView?.isUserInteractionEnabled = true
            zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            zoomingImageView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleSaveImageLongTap)))
            
           
//            scrollView.delegate = self
            

        
            if let keyWindow = UIApplication.shared.keyWindow {
                
//                blackBackgroundView = UIView(frame: keyWindow.frame)
//                self.scrollView.isHidden = false
                self.scrollView.backgroundColor = UIColor.black
                self.scrollView.alpha = 0
                scrollView.addSubview(zoomingImageView!)


//                keyWindow.addSubview(blackBackgroundView!)
                
//                scrollView = UIScrollView(frame: keyWindow.frame)
//                scrollView.alpha = 0
//                
//                keyWindow.addSubview(scrollView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.scrollView.alpha = 1
                    self.inputViewContainer.alpha = 0
                    
                    // math?
                    // h2 / w1 = h1 / w1
                    // h2 = h1 / w1 * w1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    
                    self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    
                    self.zoomingImageView?.center = keyWindow.center
                    
                    }, completion: { (completed) in
                        //                    do nothing
                        
                        UIApplication.shared.setStatusBarHidden(true, with: .fade)
                        
                })
                
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.scrollView.alpha = 0
                self.inputViewContainer.alpha = 1

                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                    self.scrollView.alpha = 0
                    UIApplication.shared.setStatusBarHidden(false, with: .fade)
                    
            })
        }
    }

    
//    let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)

//    let stickersPreviewViewContainer = AddStickersView()

//    let stickerBottomConstraint = 

    
    func setUpInputViews(){
        
        self.view.addSubview(inputViewContainer)
        self.view.addSubview(previewViewContainer)
        self.view.addSubview(audioPreviewViewContainer)

        
        previewViewContainer.addSubview(previewSelectedImageView)

        
        previewSelectedImageView.leftAnchor.constraint(equalTo: previewViewContainer.leftAnchor, constant: 1).isActive = true
        previewSelectedImageView.rightAnchor.constraint(equalTo: previewViewContainer.rightAnchor, constant: -1).isActive = true
        previewSelectedImageView.topAnchor.constraint(equalTo: previewViewContainer.topAnchor, constant: 1).isActive = true
        previewSelectedImageView.bottomAnchor.constraint(equalTo: previewViewContainer.bottomAnchor, constant: -1).isActive = true
        
        audioPreviewViewContainer.addSubview(preListenToAudioImageView)
        audioPreviewViewContainer.addSubview(tapToSendAudioLabel)
        audioPreviewViewContainer.addSubview(deleteAudioButton)
        
        
        deleteAudioButton.bottomAnchor.constraint(equalTo: audioPreviewViewContainer.bottomAnchor).isActive = true
        deleteAudioButton.rightAnchor.constraint(equalTo: audioPreviewViewContainer.rightAnchor).isActive = true
        deleteAudioButton.leftAnchor.constraint(equalTo: audioPreviewViewContainer.leftAnchor).isActive = true
        deleteAudioButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tapToSendAudioLabel.topAnchor.constraint(equalTo: audioPreviewViewContainer.topAnchor, constant: 5).isActive = true
        tapToSendAudioLabel.widthAnchor.constraint(equalTo: audioPreviewViewContainer.widthAnchor).isActive =  true
        tapToSendAudioLabel.centerXAnchor.constraint(equalTo: audioPreviewViewContainer.centerXAnchor).isActive = true
        tapToSendAudioLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        preListenToAudioImageView.centerYAnchor.constraint(equalTo: audioPreviewViewContainer.centerYAnchor).isActive = true
        preListenToAudioImageView.centerXAnchor.constraint(equalTo: audioPreviewViewContainer.centerXAnchor).isActive = true
        preListenToAudioImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        preListenToAudioImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        audioPreviewViewContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        audioPreviewViewContainer.bottomAnchor.constraint(equalTo: inputViewContainer.topAnchor, constant: -10).isActive = true
        audioPreviewViewContainer.widthAnchor.constraint(equalToConstant: 120).isActive = true
        audioPreviewViewContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        previewViewContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        previewViewContainer.bottomAnchor.constraint(equalTo: inputViewContainer.topAnchor, constant: -10).isActive = true
        previewViewContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        previewViewContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.bottomConstraints = inputViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        self.bottomConstraints?.isActive = true
        
        self.inputContainerViewHeightConstraint = inputViewContainer.heightAnchor.constraint(equalToConstant: 50)
        self.inputContainerViewHeightConstraint?.isActive = true
        inputViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        
        view.addConstraint(self.bottomConstraints!)
        
        
        inputViewContainer.addSubview(attachmentButton)
        inputViewContainer.addSubview(stickersButton)
        inputViewContainer.addSubview(textInputView)
        inputViewContainer.addSubview(sendButtonAndAudioContainerView)
        
        
        
        stickersButton.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 4).isActive = true
        stickersButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        stickersButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stickersButton.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor, constant:  -10).isActive = true
        
        sendButtonAndAudioContainerView.addSubview(sendButton)
        sendButtonAndAudioContainerView.addSubview(tapToPopUpAudioRecorder)
        
        
        
        sendButtonAndAudioContainerView.rightAnchor.constraint(equalTo: inputViewContainer.rightAnchor, constant: -8).isActive = true
        sendButtonAndAudioContainerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButtonAndAudioContainerView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        sendButtonAndAudioContainerView.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor, constant: -10).isActive = true
        
        sendButton.topAnchor.constraint(equalTo: sendButtonAndAudioContainerView.topAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: sendButtonAndAudioContainerView.leftAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: sendButtonAndAudioContainerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sendButtonAndAudioContainerView.widthAnchor).isActive = true
        
        
        
        tapToPopUpAudioRecorder.centerXAnchor.constraint(equalTo: sendButtonAndAudioContainerView.centerXAnchor).isActive = true
        tapToPopUpAudioRecorder.centerYAnchor.constraint(equalTo: sendButtonAndAudioContainerView.centerYAnchor).isActive = true
        tapToPopUpAudioRecorder.heightAnchor.constraint(equalToConstant: 32).isActive = true
        tapToPopUpAudioRecorder.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        attachmentButton.leftAnchor.constraint(equalTo: inputViewContainer.leftAnchor, constant: 5).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        attachmentButton.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor, constant:  -10).isActive = true
        
        
        textInputView.rightAnchor.constraint(equalTo: sendButtonAndAudioContainerView.leftAnchor, constant:  -5).isActive = true
        textInputView.leftAnchor.constraint(equalTo: stickersButton.rightAnchor, constant: 5).isActive = true
        textInputView.topAnchor.constraint(equalTo: inputViewContainer.topAnchor, constant: 8).isActive = true
        textInputView.bottomAnchor.constraint(equalTo: inputViewContainer.bottomAnchor, constant: -8).isActive = true
        

    
        
        
    }
    
    

    func handleAudioPlay(sender: UIButton){
     
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.messageObjects[indexPath.item]
            if self.audioPlayer != nil {
                
                if self.audioPlayer.isPlaying == true {
                    self.audioPlayer.stop()
                    
                    return
                    
                }
                
            }
            
            
            
                    
                    do {
                        
                        if let audioData = selectedItem.audioData {
                            
                            self.audioPlayer = try AVAudioPlayer(data: audioData as Data)
                            
                            self.audioPlayer.prepareToPlay()
                            self.audioPlayer.delegate = self
                            self.audioPlayer.volume = 1
                            
                            if self.audioPlayer.isPlaying {
                                
                                self.audioPlayer.pause()
                                
                                
                            }else{
                                
                                self.audioPlayer.play()
                                
                                
                            }
                            
 
                        }
                        
                    
                        
                    
                        
                        
                    }catch{
                        
                        
                        print(error.localizedDescription as Any)
                    }
                
                
                if let messageId = selectedItem.objectId {
                    
                    
                    let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                    request.predicate = NSPredicate(format: "objectId == %@", messageId)
                    
                    do {
                        let searchResults = try self.moc.fetch(request)
                        
                        if let result = searchResults.first {
                            
                            result.audioListened = NSNumber(booleanLiteral: true) as Bool
                            
                            try self.moc.save()
                            print("audio info updated")
                            
                        }
                        
                    } catch {
                        print("Error with request: \(error)")
                    }
                    
                    
                    
                }
                    
            
                
            
            
        }
        
        
    }
    
    func handleNameCardTapped(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view {
            
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point) {
                
                let selectedItem = self.messageObjects[indexPath.item]
                
                
                    if let nameCardId = selectedItem.nameCardId {
                        
                        if nameCardId != BmobUser.current().objectId {
                            
                            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                            request.predicate = NSPredicate(format: "objectId == %@", nameCardId)
                            
                            do {
                                let searchResults = try moc.fetch(request)
                                
                                if searchResults.count == 0 {
                                    
                                  

                                    
                                    let alert = UIAlertController(title: "Add a Friend", message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                                        
                                        self.tapNameCardBlurView.isHidden = false
                                        self.activityIndicator.startAnimating()
                                        
                                        let userToBeAdded = BmobUser(outDataWithClassName: "_User", objectId: nameCardId)
                                        
                                        let relation = BmobRelation()
                                        let currentUser = BmobUser.current()
                                        
                                        relation.add(userToBeAdded)
                                        currentUser?.add(relation, forKey: "friends")
                                        currentUser?.updateInBackground(resultBlock: { (success, error) in
                                            if error == nil {
                                                
                                                print("added")
                                                
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
                                                
                                                
                                                self.prepareToSaveRoom(selectedItem: userToBeAdded!)
                                                
                                            }else {
                                                
                                                
                                                self.tapNameCardBlurView.isHidden = true
                                                self.activityIndicator.stopAnimating()
                                                
                                            }
                                        })
                                        
                                        
                                        
                                    }))
                                    
                                    
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in

                                    self.tapNameCardBlurView.isHidden = true
                                        
                                    }))

                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }else if searchResults.count > 0{
                                    
                                   
                                    
                                    let query = BmobQuery(className: "_User")
                                    query?.whereKey("objectId", equalTo: nameCardId)
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
                                          if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
                                                            
                                            messagesVC.incomingUserProfileImageURL = profileImageFile.url
               
                                            }
                                            messagesVC.navigationItem.title = newUser.username
                                                            
                                            self.navigationController?.pushViewController(messagesVC, animated: true)

                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            
                                        }
                                    })
                                    
                                    
                                    
                                }
                                
                            } catch {
                                print("Error with request: \(error)")
                            }
                            
                            
                            
                            
                        }
                        

                        
                                
                }
                
            }
            
        }
        
 
        
        
    }
    
    
    
    func prepareToSaveRoom(selectedItem: BmobUser){
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
                                
                                self.saveToRoom(selectedItem: selectedItem)
                                
                                
                            }else if secondResults?.count == 1 {
                                
                                self.savedContactToCoreData(friend: selectedItem , room: secondResults?.first as! BmobObject)
                                
                                
                            }
                            
                            
                        }else{
                            
//                            self.backgroundBlurView.isHidden = true
                            
                            self.tapNameCardBlurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            
                            
                        }
                    })
                    
                    
                    
                }else if results?.count == 1{
                    
                    //there's room
                    
                    
                    self.savedContactToCoreData(friend: selectedItem , room: results?.first as! BmobObject)
                    
                    
                }
                
            }else{
                
                
                self.tapNameCardBlurView.isHidden = true
                self.activityIndicator.stopAnimating()
//                self.backgroundBlurView.isHidden = true
                
            }
        })
        
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
                
                if let newRoom = room.object(forKey: "newRoom") as? Bool {
                    
                    if newRoom == false  {
                        
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                        
//                        entity.createdAt = room.createdAt as NSDate?
//                        entity.objectId = friend.objectId
//                        entity.lastUpdate = NSDate()
//                        entity.newOrOld = true
//                        entity.roomId = room.objectId
                        
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
                        
                    
                        
                        do {
                            
                            try moc.save()
                            
                            self.tapNameCardBlurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            print("contact saved successfully")
                            
                            
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
                            
                            self.tapNameCardBlurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            print(error.localizedDescription)
                        }
                        
                        
                    }else if newRoom == true {
                        
                        let entity2 = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: moc) as! Contacts
                        
//                        entity2.createdAt = room.createdAt as NSDate?
//                        entity2.objectId = friend.objectId
//                        entity2.lastUpdate = NSDate()
//                        entity2.newOrOld = false
//                        entity2.roomId = room.objectId
                        
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
                            
                            self.tapNameCardBlurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            print("contact saved successfully")
                            
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
                            
                            self.tapNameCardBlurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                }
                
               
                

            }else{
                
                self.tapNameCardBlurView.isHidden = true
                self.activityIndicator.stopAnimating()
                
            }
            
        } catch {
            
            self.tapNameCardBlurView.isHidden = true
            self.activityIndicator.stopAnimating()
            print("Error with request: \(error)")
        }
        
        
    }
    
    
    func saveToRoom(selectedItem: BmobObject){
        
        let room = BmobObject(className: "Room")
        room?.setObject(selectedItem, forKey: "user1")
        room?.setObject(BmobUser.current(), forKey: "user2")
        room?.setObject(selectedItem.objectId, forKey: "user1Id")
        room?.setObject(BmobUser.current().objectId, forKey: "user2Id")
        room?.setObject(true, forKey: "newRoom")
        room?.saveInBackground(resultBlock: { (success, error) in
            if error == nil {
                
                print("room saved...")
                
                let backendMessage = BmobObject(className: "Messages")
                backendMessage?.setObject(self.currentUser, forKey: "sender")
                backendMessage?.setObject("Nice to meet you...", forKey: "textMessage")
                backendMessage?.setObject(room?.objectId, forKey: "roomId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "uniqueId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                backendMessage?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        
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
                        
                    }
                })
                
                self.savedContactToCoreData(friend: selectedItem as! BmobUser, room: room!)
                
            }else{
                
//                self.backgroundBlurView.isHidden = true
                
                self.tapNameCardBlurView.isHidden = true
                self.activityIndicator.stopAnimating()
                
                
            }
        })
        
        
        
    }
    
    func handlePlayAudio(gesture: UITapGestureRecognizer){
        if let sender = gesture.view {
            
            if self.audioPlayer != nil {
                
                if self.audioPlayer.isPlaying == true {
                    self.audioPlayer.stop()
                    
                    return
                    
                }
                
            }
            
            
            let point = sender.convert(sender.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point), let cell = self.collectionView?.cellForItem(at: indexPath) as? MessagesCollectionViewCell{
                
                
                
                let selectedItem = self.messageObjects[indexPath.item]
                
                if selectedItem.senderId != BmobUser.current().objectId {
                    
                    cell.audioDurationLabel.textColor = .lightGray
  
                }

                if let audioData = selectedItem.audioData {
                    
                    
                    do {
                        
                        
                        self.audioPlayer = try AVAudioPlayer(data: audioData as Data)
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.delegate = self
                        self.audioPlayer.volume = 1
                    
                            
                        self.audioPlayer.play()
                        
                        
                        
                    }catch{
                        
                        
                        print(error.localizedDescription as Any)
                    }
                    
                    
                    
                }
                
                
                
                if let messageId = selectedItem.objectId {
                    
                    
                    let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                    request.predicate = NSPredicate(format: "objectId == %@", messageId)
                    
                    do {
                        let searchResults = try self.moc.fetch(request)
                        
                        if let result = searchResults.first {
                            
                            result.audioListened = NSNumber(booleanLiteral: true) as Bool
                            
                            try self.moc.save()
                            print("audio info updated")
                            
                        }
                        
                    } catch {
                        print("Error with request: \(error)")
                    }
                    

                    
                }
                
                
                
                
                
                
                
            }
            
            
            
        }
      
        
    }
    
//    func processLoadMoreMessages(message: Messages){
//        
//        let messageObject = MessageObject()
//        
//        messageObject.objectId = message.objectId
//        messageObject.createdAt = message.createdAt
//        messageObject.senderId =  message.senderId
//        messageObject.delivered = message.sentOrFailed
//        messageObject.textMessage = message.textMessage
//        messageObject.senderName = message.senderName
//        messageObject.imageWidth = message.imageWidth
//        messageObject.imageHeight = message.imageHeight
//        messageObject.imageMessageURL = message.imageMessageURL
//        messageObject.imageMessage  = message.imageMessage
//        messageObject.audioData = message.audioMessage
//        messageObject.audioDuration = message.audioDuration
//        messageObject.nameCardId = message.nameCardId
//        
//        self.messageObjects.append(messageObject)
//        
//    }
    
    
    func hanldeResendButtonTapped(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point){
            
        sender.isHidden = true
            
        let selectedItem = self.messageObjects[(indexPath.item)]
        
        let userToBeDeleted = selectedItem
            
            let alert = UIAlertController(title: "Failed to deliver message", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                
                self.messageObjects.remove(at: indexPath.item)
                self.collectionView?.reloadData()
                
                if let messageId = userToBeDeleted.objectId {
                    
                    let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
                    fetch.predicate = NSPredicate(format: "objectId == %@", messageId)
                    fetch.fetchLimit = 1
                    
                    
                    do {
                        
                        let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                        
                        
                        if results.count > 0 {
                            
                            for result in results {
                                
                                self.moc.delete(result)
                                
                                do {
                                    
                                    try self.moc.save()
                                    
                                }catch{
                                    
                                    print(error.localizedDescription as Any)
                                }
                                
                                
                            }
                            
                            
                        }
                        
                    }catch{
                        
                        print(error.localizedDescription as Any)
                    }
                    
                    
                }
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action) in
                
                if let messageId = selectedItem.objectId {
                    
                    let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
                    fetch.predicate = NSPredicate(format: "objectId == %@", messageId)
                    fetch.fetchLimit = 1
                    
                    
                    do {
                        
                        let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                        
                        
                        if results.count > 0 {
                            
                            let object = results.first
                            
                            self.resendMessage(message: object!)
                            
                            
                        }
                        
                    }catch{
                        
                        print(error.localizedDescription as Any)
                    }
                    
                    
                }
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
      
        
        
        
    }
    
    func resendMessage(message: Messages){
        
        if message.textMessage != ""{
           
           self.resendText(message: message)
            
        }
        
        if message.audioMessage != nil {
            
            self.resendAudio(message: message)
            
        }
        
        if message.imageMessage != nil {
            
            self.resendImage(message: message)
            
        }
        
        if message.nameCardId != "" {
            
           self.resendNameCard(message: message)
            
            
        }

        
  }
    
    func resendNameCard(message: Messages){
       
//        self.saveNameCardPermanently(nameCardId: message.nameCardId!, uniqueId: message.objectId!)
        
        let namedCard = BmobObject(className: "Messages")
        namedCard?.setObject(self.currentUser, forKey: "sender")
        namedCard?.setObject(message.nameCardId, forKey: "nameCardId")
        namedCard?.setObject(self.incomingUser.roomId, forKey: "roomId")
        namedCard?.setObject(message.objectId, forKey: "uniqueId")
        namedCard?.setObject(self.currentUser?.objectId, forKey: "senderId")
        namedCard?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

        
        let receivingUser = BmobUser(outDataWithClassName: "_user", objectId: self.incomingUser.objectId)
        
        let AccessControl = BmobACL()
        AccessControl.setReadAccessFor(currentUser)
        AccessControl.setReadAccessFor(receivingUser)
        AccessControl.setWriteAccessFor(currentUser)
        AccessControl.setWriteAccessFor(receivingUser)
        
        namedCard?.acl = AccessControl
        
        namedCard?.saveInBackground(resultBlock: { (success, error) in
            if success{
                
                
                
                let roomQuery = BmobQuery(className: "Room")
                roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                roomQuery?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        if (results?.count)! > 0 {
                            
                            if let name =  self.currentUser?.username {
                                
                                let installationQuery = BmobInstallation.query()
                                installationQuery?.order(byDescending: "createdAt")
                                installationQuery?.limit = 1
                                installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                
                                
                                let data = ["alert": "\(name) shared a contact", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                
                                
                                let push = BmobPush()
                                push.setQuery(installationQuery)
                                push.setData(data)
                                push.sendInBackground({ (success, error) in
                                    if error == nil {
                                        
                                        print("push has been sent")
                                        
                                        self.deleReadMessages()
                                        
                                        
                                    }else{
                                        
                                        self.loadWhenSent()
                                        
                                        print(error?.localizedDescription as Any)
                                        
                                    }
                                })
                                
                            }
                            
                            
                            let unreadMessage = BmobObject(className: "UnreadMesssages")
                            unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                            unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                            unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("unread message sent successfully")
                                    
                                }else{
                                    
                                    print(error?.localizedDescription as Any)
                                }
                            })
                            
                            
                            
                        }else if results?.count == 0{
                            
                            
                            
                            DispatchQueue.main.async {
                                
                                self.showAlert()
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                })
                
               
              
                
               
                print("nameCard saved successfully")
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                
                
                
            }else{
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                print(error?.localizedDescription as Any)
            }
        })
        
    }
    
    
    func resendImage(message: Messages){
        
//        let size = CGSize(width: CGFloat(message.imageWidth), height: CGFloat(message.imageHeight))
//        self.saveImageMessagePermanently(imageData: message.imageMessage as! Data , uniqueId: message.objectId!, imageSize: size)
       
        let imageData = message.imageMessage
        let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData as Data!)
        imageFile?.save(inBackground: { (success, error) in
            if success{
                
                let imageMessage = BmobObject(className: "Messages")
                imageMessage?.setObject(self.currentUser, forKey: "sender")
                imageMessage?.setObject(imageFile, forKey: "imageMessage")
                imageMessage?.setObject(self.incomingUser?.roomId, forKey: "roomId")
                imageMessage?.setObject(message.objectId, forKey: "uniqueId")
                imageMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                imageMessage?.setObject(message.imageHeight, forKey: "imageHeight")
                imageMessage?.setObject(message.imageWidth, forKey: "imageWidth")
                imageMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

                
                let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
                
                let AccessControl = BmobACL()
                AccessControl.setReadAccessFor(self.currentUser)
                AccessControl.setReadAccessFor(receivingUser)
                AccessControl.setWriteAccessFor(self.currentUser)
                AccessControl.setWriteAccessFor(receivingUser)
                
                imageMessage?.acl = AccessControl
                imageMessage?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        
                        let roomQuery = BmobQuery(className: "Room")
                        roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                        roomQuery?.findObjectsInBackground({ (results, error) in
                            if error == nil {
                                
                                if (results?.count)! > 0 {
                                
                                    if let name =  self.currentUser?.username {
                                        
                                        let installationQuery = BmobInstallation.query()
                                        installationQuery?.order(byDescending: "createdAt")
                                        installationQuery?.limit = 1
                                        installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                        
                                        let data = ["alert": "\(name) sent you an image", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                        
                                        
                                        let push = BmobPush()
                                        push.setQuery(installationQuery)
                                        push.setData(data)
                                        push.sendInBackground({ (success, error) in
                                            if error == nil {
                                                
                                                print("push has been sent")
                                                self.deleReadMessages()
                                                
                                                
                                            }else{
                                                
                                                
                                                print(error?.localizedDescription as Any)
                                                
                                            }
                                        })
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    let unreadMessage = BmobObject(className: "UnreadMesssages")
                                    unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                                    unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                                    unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                        if success{
                                            
                                            print("unread message sent successfully")
                                            
                                        }else{
                                            
                                            print(error?.localizedDescription as Any)
                                        }
                                    })
                                    
                                    print("image message sent succesfully")
                                    
                                    
                                }else if results?.count == 0 {
                                    
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.showAlert()
                                    }
                                    
                                }

                                
                            }
                            
                            })
                        
                      
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                        
                        
                    }else{
                        
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                        
                        
                        
                        
                        
                        print(error?.localizedDescription as Any)
                    }
                })
                
                
            }else{
                
             
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                
                
            }
        })
        
        
    }
    
    func resendAudio(message: Messages){
        
//        self.saveAudioPermanentlyToCoreData(uniqueId: message.objectId!, audioData: message.audioMessage!, audioDuration: Int(message.audioDuration))

    
        let audioData = message.audioMessage
        let audioFile = BmobFile(fileName: "audioMessage.mp3", withFileData: audioData as Data!)
        audioFile?.save(inBackground: { (success, error) in
            if success {
                
                let backendMessage = BmobObject(className: "Messages")
                backendMessage?.setObject(self.currentUser, forKey: "sender")
                backendMessage?.setObject(message.audioDuration, forKey: "audioDuration")
                backendMessage?.setObject(audioFile, forKey: "audioMessage")
                backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                backendMessage?.setObject(message.objectId, forKey: "uniqueId")
                backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
                backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

                
                
                let receivingUser = BmobUser(outDataWithClassName: "_user", objectId: self.incomingUser.objectId)
                
                let AccessControl = BmobACL()
                AccessControl.setReadAccessFor(self.currentUser)
                AccessControl.setReadAccessFor(receivingUser)
                AccessControl.setWriteAccessFor(self.currentUser)
                AccessControl.setWriteAccessFor(receivingUser)
                
                backendMessage?.acl = AccessControl
                
                
                backendMessage?.saveInBackground(resultBlock: { (success, error) in
                    if success{
                        
                        
                        let roomQuery = BmobQuery(className: "Room")
                        roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                        roomQuery?.findObjectsInBackground({ (results, error) in
                            if error == nil {
                                
                                if (results?.count)! > 0 {
                                    
                                    
                                    if let name =  BmobUser.current().username {
                                        
                                        let installationQuery = BmobInstallation.query()
                                        installationQuery?.order(byDescending: "createdAt")
                                        installationQuery?.limit = 1
                                        installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                        
                                        
                                        let data = ["alert": "\(name) sent you an audio file", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                        
                                        
                                        let push = BmobPush()
                                        push.setQuery(installationQuery)
                                        push.setData(data)
                                        push.sendInBackground({ (success, error) in
                                            if error == nil {
                                                
                                                print("push has been sent")
                                                self.deleReadMessages()
                                                
                                                
                                            }else{
                                                
                                                self.loadWhenSent()
                                                
                                                print(error?.localizedDescription as Any)
                                                
                                            }
                                        })
                                        
                                        
                                    }
                                    
                                    
                                    print("audio message sent successfully")
                                    
                                    let unreadMessage = BmobObject(className: "UnreadMesssages")
                                    unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                                    unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                                    unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                        if success{
                                            
                                            print("unread message sent successfully")
                                            
                                        }else{
                                            
                                            print(error?.localizedDescription as Any)
                                        }
                                    })
    
                                    
                                }else if results?.count == 0 {
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.showAlert()
                                        
                                    }
                                    
                                    
                                }
                            
                                
                            }
                        })
                        
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                        
                    }else{
                        
                       //Failed to save to backend
                        
                        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                        request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if let result = searchResults.first {
                                
                                result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                                
                                try self.moc.save()
                                print("user info updated")
                                
                            }
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                        
                    }
                })
                
                
                
                
            }else{
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                
                //audio file couldn't be saved
            }
            
        })
     
      }
    

    func resendText(message: Messages){
    
//        self.saveMessagePermanently(textMessage: message.textMessage!, uniqueId: message.objectId!)

        
        let backendMessage = BmobObject(className: "Messages")
        backendMessage?.setObject(self.currentUser, forKey: "sender")
        backendMessage?.setObject(message.textMessage, forKey: "textMessage")
        
        backendMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
        if let uniqueId = message.objectId {
            
        backendMessage?.setObject(uniqueId, forKey: "uniqueId")
            
            
        }
        backendMessage?.setObject(self.currentUser?.objectId, forKey: "senderId")
        backendMessage?.setObject(self.incomingUser?.objectId, forKey: "receiverId")

        
        
        
        let receivingUser = BmobUser(outDataWithClassName: "_User", objectId: self.incomingUser.objectId)
        
        let AccessControl = BmobACL()
        AccessControl.setReadAccessFor(currentUser)
        AccessControl.setReadAccessFor(receivingUser)
        AccessControl.setWriteAccessFor(currentUser)
        AccessControl.setWriteAccessFor(receivingUser)
        
        backendMessage?.acl = AccessControl
        backendMessage?.saveInBackground { (success, error) in
            if error == nil {
                
                
                let roomQuery = BmobQuery(className: "Room")
                roomQuery?.whereKey("objectId", equalTo: self.incomingUser?.roomId)
                roomQuery?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        if (results?.count)! > 0 {
                            
                            if let name =  BmobUser.current().username {
                                
                                let installationQuery = BmobInstallation.query()
                                installationQuery?.order(byDescending: "createdAt")
                                installationQuery?.limit = 1
                                installationQuery?.whereKey("userId", equalTo: self.incomingUser.objectId)
                                
                                
                                let data = ["alert": "\(name): \(message.textMessage)", "badge": 1, "sound": "notification.caf"] as [String : Any]
                                
                                
                                let push = BmobPush()
                                push.setQuery(installationQuery)
                                push.setData(data)
                                push.sendInBackground({ (success, error) in
                                    if error == nil {
                                        
                                        print("push has been sent")
                                        self.deleReadMessages()
                                        
                                        
                                    }else{
                                        
                                        self.loadWhenSent()
                                        print(error?.localizedDescription as Any)
                                        
                                    }
                                })
                                
                                
                                
                            }
                            
                            print("Message delivered to the backend")
                            
                            let unreadMessage = BmobObject(className: "UnreadMesssages")
                            unreadMessage?.setObject(self.incomingUser.objectId, forKey: "incomingUserId")
                            unreadMessage?.setObject(self.incomingUser.roomId, forKey: "roomId")
                            unreadMessage?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("unread message sent successfully")
                                    
                                }else{
                                    
                                    print(error?.localizedDescription as Any)
                                }
                            })
                            
                            
                        }else if results?.count == 0{
                            
                            
                            DispatchQueue.main.async {
                                
                               self.showAlert()
                                
                            }
                            
                        }
                    
                    }
                    
                 })
                
               
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: true) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
        
                
                
            }else{
                
                let request: NSFetchRequest<Messages> = Messages.fetchRequest()
                request.predicate = NSPredicate(format: "objectId == %@", message.objectId!)
                
                do {
                    let searchResults = try self.moc.fetch(request)
                    
                    if let result = searchResults.first {
                        
                        result.sentOrFailed = NSNumber(booleanLiteral: false) as Bool
                        
                        try self.moc.save()
                        print("user info updated")
                        
                    }
                    
                } catch {
                    print("Error with request: \(error)")
                }
                
                
            }
        }
        

        
    }


    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y == 0.0) { // TOP }
            
           self.refresh.beginRefreshing()
            
//            self.handleRefresh()
        }
        

    }
    
    let popUpShowImage = PopDisplayImageView()
    func handlePopDisplayProfilePic(gesture: UITapGestureRecognizer){
        
        if let imageView = gesture.view as? UIImageView {
            
            popUpShowImage.acceptAndLoadDisplayImage(imageView: imageView)
//            popUpShowImage.acceptAndLoadDisplayImage(imageView: imageView, incomingViewController: self)
            
        }
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        if let count = self.fetchedResultsControler.sections?[0].numberOfObjects {
        
//        return count
        
//        }else{
            
         return self.messageObjects.count
//        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessagesCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.incomingUserProfileImageView.isUserInteractionEnabled = true
        cell.incomingUserProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopDisplayProfilePic)))
        
        cell.senderProfileImageView.isUserInteractionEnabled = true
        cell.senderProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopDisplayProfilePic)))
        
//        let message = self.fetchedResultsControler.object(at: indexPath) as! Messages
        
        let message = self.messageObjects[indexPath.item]

        
        if let lastDate = message.createdAt {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            let timeElapsedInSeconds = NSDate().timeIntervalSince(lastDate as Date)
            let secondsInDays: TimeInterval = 60 * 60 * 24
            
            if timeElapsedInSeconds > 7 * secondsInDays {
                
                dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                
            }else if timeElapsedInSeconds > secondsInDays {
                
                dateFormatter.dateFormat = "EEE h:mm a"
                
                
            }
            
            let stringFromDate = dateFormatter.string(from: lastDate as Date)
            
            cell.imageTimeStampLabel.text = stringFromDate
            cell.timeStampLabel.text = stringFromDate
            cell.incomingTimeStampLabel.text = stringFromDate
            
            
            
        }
    
        cell.resendButton.addTarget(self, action: #selector(hanldeResendButtonTapped), for: .touchUpInside)
        cell.playAudioButton.addTarget(self, action: #selector(handleAudioPlay), for: .touchUpInside)
        cell.audioDurationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlayAudio)))
        cell.nameCardUsernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameCardTapped)))

        
        if message.senderId == BmobUser.current().objectId {
            
            if  indexPath.item % 5 == 0 {
                
                cell.incomingTimeStampLabel.isHidden = true
                cell.timeStampLabel.isHidden = false
                

            }else{
                
                cell.incomingTimeStampLabel.isHidden = true
                cell.timeStampLabel.isHidden = true
            }
            
            
        }else{
            
            if  indexPath.item % 5 == 0 {
                
                cell.incomingTimeStampLabel.isHidden = false
                cell.timeStampLabel.isHidden = true
                
        
            }else{
                
                cell.incomingTimeStampLabel.isHidden = true
                cell.timeStampLabel.isHidden = true
             
                
            }
            
        }
        
       

        
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
            
            cell.senderProfileImageView.image = UIImage(data: profileImageData as Data)
        }
        
//        if let userProfileURL = incomingUserProfileImageURL {
//            
//              cell.incomingUserProfileImageView.sd_setImage(with: NSURL(string: userProfileURL) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
//
//        }
    
        if let incomingUserProfileImageData = self.incomingUser.profileImageData {
            
            let image = UIImage(data: incomingUserProfileImageData as Data)
            cell.incomingUserProfileImageView.image = image
            
        }

        self.setUpCell(message: message, cell: cell)
        
      

    
        return cell
    }
    
    
    
  
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40
        
//        let message = self.fetchedResultsControler.object(at: indexPath) as! Messages
        let message = self.messageObjects[indexPath.item]
        
        if let messageText = message.textMessage {
            
            height = self.estimatedRect(statusText: messageText , fontSize: 16).height + 20 + 2 
            
            return CGSize(width: view.frame.width, height: height)

          
        }else if message.imageMessage != nil || message.imageMessageURL != nil {
            
            let w = message.imageWidth
            let h = message.imageHeight
                
            let imageHeight = CGFloat(h!) / CGFloat(w!) * 150
                
            height = imageHeight
            
   
            return CGSize(width: view.frame.width, height: height)

            
        }else if message.audioData != nil{
            
            height = 40
            
            return CGSize(width: view.frame.width, height: height)

            
        }else if let namedCard = message.nameCardId{
            
            height = 70
            
            return CGSize(width: view.frame.width, height: height)

        }else if message.stickerData != nil{
            
            
            if let w = message.stickerWidth , let h = message.stickerHeight{
                
                
                let stickerHeight = CGFloat(h) / CGFloat(w) * 150
                height = stickerHeight
                
                
            }else{
                
                height = 150
 
                
            }
            
            
            return CGSize(width: view.frame.width, height: height)
            
        }
        
       
        return CGSize(width: view.frame.width, height: height)
    }
    
 
    func estimatedRect(statusText: String, fontSize: CGFloat) -> CGRect {
        
        return NSString(string: statusText).boundingRect(with: CGSize(width: 200, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        
    }
    
    
    func setUpCell(message: MessageObject, cell: MessagesCollectionViewCell){
        
        
        
        if message.senderId == BmobUser.current().objectId {
            
        
        cell.senderProfileImageView.isHidden = false
        cell.incomingUserProfileImageView.isHidden = true
        
        cell.bubbleMoveToLeft?.isActive = false
        cell.bubbleMoveToRight?.isActive = true
        cell.imageTimeStampLabel.textAlignment = .right
        cell.timeStampLabel.textAlignment = .right
        
        
        if let messageId = message.objectId {
            
            let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
            fetch.predicate = NSPredicate(format: "objectId == %@", messageId)
            fetch.fetchLimit = 1
            
            
            do {
                
                let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                
                
                if results.count > 0 {
                    
                    for result in results {
                        
                        if result.sentOrFailed == true {
                            
                            cell.resendButton.isHidden = true
                            
                            
                        }else {
                            
                            cell.resendButton.isHidden = false
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            }catch{
                
                print(error.localizedDescription as Any)
            }
            
            
        }
        
        if message.stickerData != nil {
            
            cell.bubbleContainerView.backgroundColor = .clear
            
         
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = true
            cell.blurView.isHidden = true
            cell.namedCardBackgroundImageView.isHidden = true
            cell.nameCardBackroundView.isHidden = true
            cell.audioDurationLabel.isHidden = true
            cell.playAudioButton.isHidden = true
                
                
            cell.animatedImageView.isHidden = false
 
            
            
            cell.bubbleContainerWidth?.constant = 150
            
//            let image = UIImage.gifImageWithData(data: stickerData)
//            cell.animatedImageView.image = image

            if let stickerData = message.stickerData {
                
                let image = UIImage.gifImageWithData(data: stickerData)
                cell.animatedImageView.image = image
                
                
            }
            
            
//            if let stickerURL = message.stickerURL {
//                
//                let image = UIImage.gifImageWithURL(gifUrl: stickerURL)
//                cell.animatedImageView.image = image
//                
//                
//            }
        
        
        
        }else{
            
            cell.animatedImageView.isHidden = true
            
            
            }
            
            
            
        if message.audioData != nil {
            
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = true
            cell.blurView.isHidden = true
            cell.namedCardBackgroundImageView.isHidden = true
            cell.nameCardBackroundView.isHidden = true
            cell.audioDurationLabel.isHidden = false
            cell.animatedImageView.isHidden = true
            
            
            
            cell.bubbleContainerWidth?.constant = 200
            cell.playAudioButton.isHidden = false
            cell.playAudioButton.backgroundColor = MessagesCollectionViewCell.blueColor
            
            if let audioDuration = message.audioDuration {
                
                let durationInt = Int(audioDuration)
                let secondsString = String(format: "%02d", Int(durationInt % 60))
                let minutesString = String(format: "%02d", Int(durationInt / 60))
                
                cell.audioDurationLabel.text = "\(minutesString):\(secondsString)"
                cell.audioDurationLabel.textAlignment = .left
                cell.audioDurationLabel.textColor = .white
                
                
            }
            
            
            let image = UIImage(named: "outgoingAudioIcon")
            cell.playAudioButton.setBackgroundImage(image, for: .normal)
            
            
            
        }else{
            
            cell.audioDurationLabel.isHidden = true
            cell.playAudioButton.isHidden = true


            
            }
            
            
            
            
            
            
            if let messageText = message.textMessage {
            
            cell.messageTextView.textColor = UIColor.black
            cell.bubbleContainerView.backgroundColor = UIColor(patternImage: UIImage(named: "colorPicker")!)
            
            cell.blurView.isHidden = true
            cell.playAudioButton.isHidden = true
            cell.namedCardBackgroundImageView.isHidden = true
            cell.nameCardBackroundView.isHidden = true
            cell.audioDurationLabel.isHidden = true
            cell.animatedImageView.isHidden = true

            
            
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = false
            cell.messageTextView.text = messageText
            cell.bubbleContainerWidth?.constant = self.estimatedRect(statusText: messageText ,fontSize: 16).width + 20
            
            }else{
                
                cell.messageTextView.isHidden = true
                cell.bubbleContainerView.backgroundColor = UIColor.clear

  
                
            }
                
                
                
                
            if message.imageMessage != nil || message.imageMessageURL != nil {
            
            cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
            
            cell.messageImageView.isHidden = false
            cell.messageTextView.isHidden = true
            
            cell.blurView.isHidden = false
            cell.timeStampLabel.isHidden = true
            cell.playAudioButton.isHidden = true
            cell.namedCardBackgroundImageView.isHidden = true
            cell.nameCardBackroundView.isHidden = true
            cell.audioDurationLabel.isHidden = true
            cell.animatedImageView.isHidden = true

            
        
            
            
            cell.bubbleContainerView.backgroundColor = UIColor.clear
            
            
            if let imageUrl = message.imageMessageURL {
                
                
                cell.messageImageView.sd_setImage(with: NSURL(string: imageUrl) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                
            }else if let imageData = message.imageMessage {
                
                cell.messageImageView.image = UIImage(data: imageData as Data)
                
            }
            
            cell.bubbleContainerWidth?.constant = 150
            
            
            }else{
                
                cell.messageImageView.isHidden = true
                cell.blurView.isHidden = true

  
                
            }
                
                
                
                
            if let namedCardId =  message.nameCardId{
            
            
            cell.bubbleContainerWidth?.constant = 170
            
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = true
            cell.blurView.isHidden = true
            cell.playAudioButton.isHidden = true
            
            cell.messageImageView.isHidden = true
            cell.messageTextView.isHidden = true
            
            cell.timeStampLabel.isHidden = true
            cell.namedCardBackgroundImageView.isHidden = false
            cell.nameCardBackroundView.isHidden = false
            cell.audioDurationLabel.isHidden = true
            cell.animatedImageView.isHidden = true

           var  attributedMutableText = NSMutableAttributedString()
                
                if let username = message.username {
                    
                attributedMutableText = NSMutableAttributedString(string: username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
                    
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    
                    attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
                    
                    cell.nameCardUsernameLabel.attributedText = attributedMutableText
                    
                    
                }
                
                if let phoneNumber = message.phoneNumber {
                    
                    let atrributedText = NSAttributedString(string: "\n\(phoneNumber)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.gray])
                    attributedMutableText.append(atrributedText)
                    

                    
                }
                
                if let profileData = message.nameCardProfilemageData {
                   let image = UIImage(data: profileData as Data)
                    
                    cell.namedCardBackgroundImageView.image = image
                    cell.nameCardPorileImageView.image = image
                    
                }
            
//            
//            let query = BmobQuery(className: "_User")
//            query?.whereKey("objectId", equalTo: namedCardId)
//            query?.limit = 1
//            query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
//            query?.findObjectsInBackground({ (results, error) in
//                if error == nil {
//                    
//                    if (results?.count)! > 0 {
//                        
//                        let receivedUser  = results?.first as! BmobUser
//                        
//                        DispatchQueue.main.async {
//                            
//                            
//                          
//                            
//                            if let profileImageFile = receivedUser.object(forKey: "profileImageFile") as? BmobFile {
//                                
//                                cell.namedCardBackgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
//                                
//                                
//                                cell.nameCardPorileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
//                                
//                            }
//                            
//                            
//                        }
//                        
//                        
//                    }
//                    
//                }
//            })
//            
            
        
            }else{
                
             
                cell.namedCardBackgroundImageView.isHidden = true
                cell.nameCardBackroundView.isHidden = true


                
                
            }
            
            
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        }else{
            
            
//            cell.activityIndicator.isHidden = true
            
            
            cell.resendButton.isHidden = true
//            cell.playAudioButton.isHidden = true
            cell.failedToDeliverView.isHidden = true
            
            cell.senderProfileImageView.isHidden = true
            cell.incomingUserProfileImageView.isHidden = false
            
        
            cell.bubbleMoveToLeft?.isActive = true
            cell.bubbleMoveToRight?.isActive = false
            
            cell.imageTimeStampLabel.textAlignment = .left
            
            
            
            
            if message.stickerData != nil {
                
                cell.bubbleContainerView.backgroundColor = .clear
                
                
                cell.messageImageView.isHidden = true
                cell.messageTextView.isHidden = true
                cell.blurView.isHidden = true
                cell.namedCardBackgroundImageView.isHidden = true
                cell.nameCardBackroundView.isHidden = true
                cell.audioDurationLabel.isHidden = true
                cell.playAudioButton.isHidden = true
                
                
                cell.animatedImageView.isHidden = false
                
                
                cell.bubbleContainerWidth?.constant = 150
                if let stickerData = message.stickerData {
                    
                    let image = UIImage.gifImageWithData(data: stickerData)
                    cell.animatedImageView.image = image
                    
                    
                    cell.animatedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animatedImageViewTapped)))
                    cell.animatedImageView.isUserInteractionEnabled = true
                    
                }
                
                
                
            }else{
                
                
                cell.animatedImageView.isHidden = true
                
                
            }
            

            
            if message.audioData != nil {
                
                print("There's audio")
                
                
                let image = UIImage(named: "incomingAudioIcon")
                cell.playAudioButton.setBackgroundImage(image, for: .normal)
                
                cell.playAudioButton.isHidden = false
                cell.playAudioButton.backgroundColor = .white
               
                cell.messageImageView.isHidden = true
                cell.messageTextView.isHidden = true
                cell.blurView.isHidden = true
                cell.animatedImageView.isHidden = true

                cell.bubbleContainerWidth?.constant = 200
              
                
                cell.namedCardBackgroundImageView.isHidden = true
                cell.nameCardBackroundView.isHidden = true
                cell.audioDurationLabel.isHidden = false
            
                
                if let audioDuration = message.audioDuration {
                    
                    print("duration")

                    
                    let durationInt = Int(audioDuration)
                    let secondsString = String(format: "%02d", Int(durationInt % 60))
                    let minutesString = String(format: "%02d", Int(durationInt / 60))
                    
                    cell.audioDurationLabel.text = "\(minutesString):\(secondsString)"
                    cell.audioDurationLabel.textAlignment = .right
                    
                    
                }
                
                
              
                
                if let messageId = message.objectId {
                    
                    let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
                    fetch.predicate = NSPredicate(format: "objectId == %@", messageId)
                    fetch.fetchLimit = 1
                    
                    
                    do {
                        
                        let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                        
                        
                        if results.count > 0 {
                            
                            for result in results {
                                
                                if result.audioListened == true {
                                    
                                    cell.audioDurationLabel.textColor = .lightGray
                                    
                                    
                                }else {
                                    
                                    cell.audioDurationLabel.textColor = .red
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                    }catch{
                        
                        print(error.localizedDescription as Any)
                    }
                    
                    
                }
               
                
            }else{
                
                cell.playAudioButton.isHidden = true
                cell.audioDurationLabel.isHidden = true

                
            }
            
                
      
            
            if let messageText = message.textMessage {
                
                cell.messageTextView.textColor = UIColor.black
                cell.bubbleContainerView.backgroundColor = UIColor.white
                
                cell.blurView.isHidden = true
                cell.playAudioButton.isHidden = true
                cell.namedCardBackgroundImageView.isHidden = true
                cell.nameCardBackroundView.isHidden = true
                cell.audioDurationLabel.isHidden = true
                
                cell.animatedImageView.isHidden = true

                cell.messageImageView.isHidden = true
                cell.messageTextView.isHidden = false
                cell.messageTextView.text = messageText
                cell.bubbleContainerWidth?.constant = self.estimatedRect(statusText: messageText ,fontSize: 16).width + 20
                
            }else{
                
                cell.messageTextView.isHidden = true
                cell.bubbleContainerView.backgroundColor = UIColor.clear
  
                
            }
            
            
            
            
            if message.imageMessage != nil || message.imageMessageURL != nil {
                
                cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
                
                cell.messageImageView.isHidden = false
                cell.messageTextView.isHidden = true
                cell.playAudioButton.isHidden = true
                cell.namedCardBackgroundImageView.isHidden = true
                cell.nameCardBackroundView.isHidden = true
                cell.audioDurationLabel.isHidden = true
                cell.animatedImageView.isHidden = true

                
                cell.messageTextView.backgroundColor = UIColor.clear
                
                cell.timeStampLabel.isHidden = true
                cell.blurView.isHidden = false
                cell.bubbleContainerView.backgroundColor = UIColor.clear
                
                
                if let imageUrl = message.imageMessageURL {
                    
                    cell.messageImageView.sd_setImage(with: NSURL(string: imageUrl ) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                    
                }else if let imageData = message.imageMessage {
                    
                    cell.messageImageView.image = UIImage(data: imageData as Data)
                    
                }
                
                cell.bubbleContainerWidth?.constant = 150
                
                
            }else{
                
                cell.blurView.isHidden = true
                cell.messageImageView.isHidden = true

 
                
            }
                
                
                
                
            
                if let namedCardId = message.nameCardId {
                
                cell.bubbleContainerWidth?.constant = 170
                
                cell.messageImageView.isHidden = true
                cell.messageTextView.isHidden = true
                cell.blurView.isHidden = true
                cell.playAudioButton.isHidden = true
                cell.audioDurationLabel.isHidden = true
                cell.animatedImageView.isHidden = true

                
                
                cell.timeStampLabel.isHidden = true
                cell.namedCardBackgroundImageView.isHidden = false
                cell.nameCardBackroundView.isHidden = false
                
                    
                    var  attributedMutableText = NSMutableAttributedString()
                    
                    if let username = message.username {
                        
                        attributedMutableText = NSMutableAttributedString(string: username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
                        
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 4
                        
                        attributedMutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedMutableText.string.characters.count))
                        
                        cell.nameCardUsernameLabel.attributedText = attributedMutableText
                        
                        
                    }
                    
                    if let phoneNumber = message.phoneNumber {
                        
                        let atrributedText = NSAttributedString(string: "\n\(phoneNumber)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.gray])
                        attributedMutableText.append(atrributedText)
                        
                        
                        
                    }
                    
//                    if let profileData = message.nameCardProfilemageData {
//                        let image = UIImage(data: profileData as Data)
//                        
//                        cell.namedCardBackgroundImageView.image = image
//                        cell.nameCardPorileImageView.image = image
//                        
//                    }
                    
                    
                let query = BmobUser.query()
                query?.whereKey("objectId", equalTo: namedCardId)
                query?.limit = 1
                query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
                query?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        if (results?.count)! > 0 {
                            
                            let receivedUser = results?.first as! BmobUser
                            
                            DispatchQueue.main.async {
                                
                              
                                
                                if let profileImageFile = receivedUser.object(forKey: "profileImageFile") as? BmobFile {
                                    
                                    cell.namedCardBackgroundImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                    
                                    cell.nameCardPorileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                    }
                })
                
                //////qury end
                
                }else{
                    
                    cell.namedCardBackgroundImageView.isHidden = true
                    cell.nameCardBackroundView.isHidden = true

    
                    
                    
            }
            
        }
        
    }
    
    
    
    
    func animatedImageViewTapped(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view as? UIImageView{
            
          let point = sender.convert(sender.bounds.origin, to: self.collectionView)
           if let indexPath = self.collectionView?.indexPathForItem(at: point){
                
              let selectedItem = self.messageObjects[indexPath.item]
            
            if let stickerId = selectedItem.stickerId{
                
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                
                let query = BmobQuery(className: "Stickers")
                query?.getObjectInBackground(withId: stickerId, block: { (object, error) in
                    
                    if error == nil {
                        
                        
                        self.saveStickers(object: object!)
                        
                    }else{
                        
                        self.displayAlert(reason: (error?.localizedDescription)!)

                    }
                    
                    
                })
                
                
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
                
            
                
            }
            
            
            
                
            }
            
            
        }
        
        
        
    }
    
    
    func saveStickers(object: BmobObject){
        
        var stickerHeight:Float = 0
        var stickerWidth:Float = 0
        
        if let previewFile = object.object(forKey: "preview") as? BmobFile {
            print("its available....")
            
            
            if let stickerFile = object.object(forKey: "gif") as? BmobFile {
                print("its available too....")
                
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Stickers", into: self.moc) as! Stickers
                
                if let stickerPreview = NSData(contentsOf: NSURL(string: previewFile.url) as! URL){
                    
                    if let stickerData = NSData(contentsOf: NSURL(string: stickerFile.url) as! URL){
                        
                        if let height = object.object(forKey: "height") as? Int {
                            
                            stickerHeight = Float(height)
                        }
                        
                        
                        if let width = object.object(forKey: "width") as? Int {
                            
                            stickerWidth = Float(width)
                        }
                        
                        
                        
                        print("its available....")
                        
                        entity.createdAt = NSDate()
                        entity.previewData = stickerPreview
                        entity.stickerData = stickerData
                        entity.stickerHeight = stickerHeight
                        entity.stickerWidth = stickerWidth
                        entity.stickerId = object.objectId
                        
                        do {
                            
                            try self.moc.save()
                            
                          self.displayAlert(reason: "Sticker has been saved successfully")
                            
                            
                        }catch {}
                        
                        
                    }
                    
                    
                }
                
                
                
            }
        
       }
        
    }
    
    
    func displayAlert(reason: String){
        
        let alert = UIAlertController(title: "", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alert.present(alert, animated: true, completion: nil)
  
        
        
    }
    

}
