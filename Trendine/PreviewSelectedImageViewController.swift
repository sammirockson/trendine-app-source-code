//
//  PreviewSelectedImageViewController.swift
//  Trendin
//
//  Created by Rockson on 10/5/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class PreviewSelectedImageViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    lazy var friendsOnlySwitchButton: UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(handleSwitchSwipe), for: .valueChanged)
        return sw
        
    }()

     let friendsOnlyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
//        label.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        label.text = "Share with friends only"
        label.textAlignment = .center
        return label
        
    }()
    
    
    lazy var previewImage: UIImageView = {
        let im = UIImageView()
        im.contentMode = UIViewContentMode.scaleAspectFill
        im.clipsToBounds = true
        im.translatesAutoresizingMaskIntoConstraints = false
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePreviewImageTouched)))
        return im
        
    }()
    
    lazy var clearTextViewImage: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "DeleteButton")
        im.backgroundColor = UIColor.black
        im.isUserInteractionEnabled = true
        im.tintColor = UIColor.black
        im.contentMode = UIViewContentMode.scaleAspectFill
        im.clipsToBounds = true
        im.translatesAutoresizingMaskIntoConstraints = false
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClearText)))
        return im
        
    }()
    
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black
        return v
        
    }()
    
    
    lazy var reselectImageButton: UIButton = {
            let b = UIButton()
            b.backgroundColor = UIColor.white
            b.translatesAutoresizingMaskIntoConstraints = false
            b.layer.cornerRadius = 4
            b.addTarget(self, action: #selector(handleReselectImage), for: .touchUpInside)
            return b
    
    }()
    
    lazy var captionTextField: UITextView = {
        let capText = UITextView()
        capText.text = self.addCaptionString
        capText.font = UIFont.systemFont(ofSize: 16)
        capText.backgroundColor = .clear
        capText.translatesAutoresizingMaskIntoConstraints = false
        capText.layer.cornerRadius = 4
        capText.clipsToBounds = true
        capText.textColor = UIColor.white
        capText.layer.borderWidth = 4
        capText.layer.borderColor = UIColor.black.cgColor
        return capText
        
    }()
    
    lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        label.text = "\(self.numberOfCharacters)"
        label.textAlignment = .center
        return label
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 4
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let videoPreviewScreen: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.black
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.isHidden = true
        return bView
        
    }()
    
    var durationInSeconds: Int?
    
    let addCaptionString = "Add caption..."
    var numberOfCharacters: Int = 0
    
    
    var incomingImage: UIImage?
    var incomingCompetionvC: CompetitionCollectionViewController?
    var incomingTrendingVC: TrendinCollectionViewController?
    
    var incomingUserIsForTextOnly: Bool = false
    var incomingVideoUrl: NSURL?
    var shareWithFriends = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor.black
        navigationItem.title = "Compose"
        self.captionTextField.delegate = self
        
        
       
        
        
        if incomingTrendingVC != nil {
            
            self.numberOfCharacters = 500
            
        
            
        }else if self.incomingCompetionvC != nil{
            
            self.numberOfCharacters = 50
            self.friendsOnlyLabel.isHidden = true
            self.friendsOnlySwitchButton.isHidden = true
            
            
            
        }
        
        
    
        if let image = self.incomingImage {
            
            self.previewImage.image = image
            
        }else{
            
            if let imageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
                
                self.previewImage.image = UIImage(data: imageData as Data)
            }
            
        }
        
        
        let leftButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftButton))
        navigationItem.setLeftBarButton(leftButton, animated: true)
        
        let rightButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(handleRightButton))
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        setUpViews()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.player?.pause()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.incomingUserIsForTextOnly == true {
            
            self.blurViewHeightConstraint?.constant = 220
            self.captionTextField.becomeFirstResponder()
            
        }
        
            
            if let url = self.incomingVideoUrl {
                self.videoPreviewScreen.isHidden = false

                
                self.player = AVPlayer(url: url as URL)
                self.playerLayer = AVPlayerLayer(player: player)
                self.playerLayer?.frame = self.videoPreviewScreen.bounds
                self.videoPreviewScreen.layer.addSublayer(playerLayer!)
                self.player?.play()
                
                
                if  let asset = self.player?.currentItem?.asset {
                    
                    durationInSeconds = Int(CMTimeGetSeconds(asset.duration))
                    
                }
                
            }
        
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    
    func handleSwitchSwipe(sender: UISwitch){
        
        self.shareWithFriends = self.friendsOnlySwitchButton.isOn
        
 
        
    }
    
    
    func handlePreviewImageTouched(){
        
        self.captionTextField.resignFirstResponder()
//        self.view.endEditing(true)
//        self.captionTextField.endEditing(true)
        print("resigning....")
    }
    //
    func handleClearText(){
        
        self.captionTextField.text = ""
        
        if self.incomingTrendingVC != nil {
            
            self.countTextLabel.text = "500"
            
        }else{
            
            self.countTextLabel.text = "50"
 
            
        }
        
        
        if self.incomingUserIsForTextOnly == false {
            
            self.blurViewHeightConstraint?.constant = 50 + 60
  
            
        }

        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            
            self.userLocation = currentLocation
        }
    }
    
    func playVideos(url : NSURL, playscreen: UIView){
        
        player = AVPlayer(url: url as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = playscreen.bounds
        playscreen.layer.addSublayer(playerLayer!)
        player?.play()
        player?.isMuted = true
        
        
        print("Attempting to play video......???")
        
        if  let asset = self.player?.currentItem?.asset {
            
            durationInSeconds = Int(CMTimeGetSeconds(asset.duration))
            print(Int(durationInSeconds!))
            
        }
        
        
        
        
        
    }

    func handleLeftButton(){
        
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func handleReselectImage(){
        
        
    }
    
    
    func keyboardWillShowNotification(notification: NSNotification){
        
        if let keyboardInfo = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraints?.constant = -(keyboardInfo.height - 58)
        }
        
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
        
        
    }
    
    func keyboardWillHideNotification(notification: NSNotification){
        
        
        self.bottomConstraints?.constant = -8
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    
    func handleRightButton(){
        
        self.view.endEditing(true)

        self.dismiss(animated: true) {
            
            if self.incomingTrendingVC != nil {
               //posting for trends
                
                if let image = self.incomingImage{
                    
                //psot status imageFile
                self.postStatusImageFileToBackend(image: image)
                    
                    
                    
                }
                
                
                if self.incomingUserIsForTextOnly == true && self.captionTextField.text != ""{
                    
                  //Post status textOnly
                    
                    self.postStatusTextOnly()

    
                }else if self.incomingUserIsForTextOnly == true && self.captionTextField.text == ""{
                    
                    let alert = UIAlertController(title: "Text field cannot be empty", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.incomingTrendingVC?.present(alert, animated: true, completion: nil)
                }
                
                
                if let vidUrl =  self.incomingVideoUrl {
                    
                    
                    self.postStatusVideoFileToBackend(url: vidUrl)
                    
                    
                }
                
            
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
            }else if self.incomingCompetionvC != nil {
                
                //check if the user is already in the competition
                
                let countQuery = BmobQuery(className: "Contest")
                countQuery?.countObjectsInBackground({ (count, error) in
                    if error == nil {
                    
                        if count < 100 {
                        
                         // Let the user post
                            
                            
                            let query = BmobQuery(className: "Contest")
                            query?.whereKey("poster", equalTo: BmobUser.current())
                            query?.findObjectsInBackground({ (results , error) in
                                if error == nil {
                                    
                                    if results?.count == 0 {
                                        
                                        /////Posting this image for the contest
                                        
                                        self.postContestImageFileToBackend()
                                        
                                        
                                    }else if (results?.count)! > 0 {
                                        
                                        
                                        //print alert to show the user is already part of the competition
                                        
                                       //alert
                                        
                                        self.showCompetionAlert(message: "You're already in the competition. You can upload only one photo within the 5-day period")
                                        
                                    }
                                    
                                }
                            })
                            
                            
                            
                            
                            
                            
                        }else{
                            
                         //User can't post. Competion is full
                            
                           self.showCompetionAlert(message: "Competion is full. One hundred contestants per competion. Please jump in the next competition")
                        
                            
                        }
                        
                    
                    }
                })

                
              
                
            }
            
            
            
        }
        
        
        
    }
    
    
    
    func showCompetionAlert(message: String){
        
        let alert = UIAlertController(title: message , message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.incomingCompetionvC?.present(alert, animated: true, completion: nil)
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength: Int = Int((self.captionTextField.text as NSString).length + (text as NSString).length - range.length)
        let remainingChar: Int = self.numberOfCharacters - newLength
        if remainingChar >= 0 {
            
            self.countTextLabel.text = "\(remainingChar)"
            
        }
        
        if self.incomingUserIsForTextOnly == false {
            
            let height = estimatedRect(statusText: self.captionTextField.text, fontSize: 17).height + 8 + 110
            
            if  height <= 150{
                
                self.blurViewHeightConstraint?.constant = height
                
                
            }
            
        }
       
        
        return (newLength > self.numberOfCharacters) ? false : true
        
    }
    
    func saveVideoFile(image: UIImage , videoURL: NSURL) {
        
        let videoData = NSData(contentsOf: self.incomingVideoUrl! as URL)
        let videoFile = BmobFile(fileName: "video.mp4", withFileData: videoData as Data!)
        
        
        let dataSize = videoData?.length
        
        if dataSize!  < 10000000  {
            
         
            print("\( Double(videoData!.length) * pow(Double(10.0), Double(-6.0)) ) MB") // MB: Megabytes
            
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData)
            imageFile?.save(inBackground: { (success, error) in
                if success{
                    
                    print("imaged saved...")
                    
                    videoFile?.save(inBackground: { (success, error) in
                        if success{
                            
                            print("video successfully saved...")
                            
                            let Trendin = BmobObject(className: "Trends")
                            Trendin?.setObject(BmobUser.current(), forKey: "poster")
                            
                            if self.captionTextField.text != self.addCaptionString && self.captionTextField.text != "" {
                                
                                Trendin?.setObject(self.captionTextField.text, forKey: "videoCaptionText")
                            }
                            
                            if let duration = self.durationInSeconds {
                                
                                Trendin?.setObject(duration, forKey: "videoDuration")
  
                            }
                            
                            Trendin?.setObject(videoFile, forKey: "videoFile")
                            Trendin?.setObject(imageFile, forKey: "videoPreviewFile")
                            Trendin?.setObject(Int(0), forKey: "numberOfComments")
                            Trendin?.setObject(Int(0), forKey: "numberOfLikes")
                            Trendin?.setObject([], forKey: "likersArray")
                            Trendin?.setObject(0, forKey: "numberOfViews")
                            Trendin?.setObject(self.shareWithFriends, forKey: "shareWithFriends")
                            
                            if let currentLocation = self.userLocation {
                                
                                let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
                                
                                Trendin?.setObject(geoPoint, forKey: "userLocation")
                                
                                
                            }
                            Trendin?.saveInBackground(resultBlock: { (success, error) in
                                if success{
                                    
                                    print("all video objects saved successfully")
                                    
                                    self.slideInOrAwayTheNotificationView(slideDirection: -80)
                                    self.incomingTrendingVC?.loadData()
                                    
                                }else{
                                    
                                    self.slideInOrAwayTheNotificationView(slideDirection: -80)
                                    
                                }
                            })
                            
                            
                        }
                        
                    }, withProgressBlock: { (progress) in
                        
                        self.slideInOrAwayTheNotificationView(slideDirection: 0)
                        self.incomingTrendingVC?.postImageView.image = image
                        self.incomingTrendingVC?.progressView.progress = Float(progress)
                        
                    })
                    
                    
                    
                    
                }else{
                    
                    
                }
            })
            

            
            
            
            
        }else{
            
            
            
            let alert = UIAlertController(title: "", message: "Video file size too large", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
       
        
    }

    
    func postStatusVideoFileToBackend(url: NSURL){
        
        self.slideInOrAwayTheNotificationView(slideDirection: 0)

        
        // post video
        print("video...")
        
        
        
        // snapshot the video as a preview in preview CollectionView
        
        let asset = AVURLAsset(url: url as URL)
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 5, preferredTimescale: 60)
        
        do {
            
            
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            
            self.saveVideoFile(image: image, videoURL: url)
            
        }
            
            
        catch let error as NSError
        {
            print("Image generation failed with error \(error.localizedDescription)")
        }
        
        
      
        
    }
    
    
    func postContestImageFileToBackend(){
        
        if let image = self.incomingImage ,  let data = UIImageJPEGRepresentation(image, 1.0){
            
            let imageWidth = Float(image.size.width)
            let imageHeight = Float(image.size.height)
            
            let imageFile = BmobFile(fileName: "image.JPG", withFileData: data)
            imageFile?.save(inBackground: { (success, error) in
                
                if success {
                    
                    print("file saved")
                    
                    let contest = BmobObject(className: "Contest")
                    contest?.setObject(BmobUser.current(), forKey: "poster")
                    contest?.setObject(Int(0), forKey: "points")
                    contest?.setObject(imageFile, forKey: "contestImageFile")
                    contest?.setObject(imageWidth, forKey: "imageWidth")
                    contest?.setObject(imageHeight, forKey: "imageHeight")
                    contest?.setObject(Int(0), forKey: "numberOfComments")
                    contest?.setObject(Int(0), forKey: "numberOfLikes")
                    
                    if self.captionTextField.text != self.addCaptionString && self.captionTextField.text != "" {
                        
                        contest?.setObject(self.captionTextField.text, forKey: "contestCaption")
                        
                        
                    }else{
                        
                        contest?.setObject("Good Luck!", forKey: "contestCaption")
                    }
                    
                    contest?.saveInBackground(resultBlock: { (success, error) in
                        if success{
                            
                            print("contest file has been saved")
                            
                            self.slideInOrAwayContestTheNotificationView(slideDirection: -80)
                            self.incomingCompetionvC?.loadData()
                            
                            
                        }else{
                            
                            self.slideInOrAwayContestTheNotificationView(slideDirection: -80)

                        }
                    })
                    
                    
                    
                }else{
                    
                    
                }
                
                }, withProgressBlock: { (progress) in
                    
                  
                    
                    self.slideInOrAwayContestTheNotificationView(slideDirection: 0)
                    self.incomingCompetionvC?.postImageView.image = image
                    self.incomingCompetionvC?.progressView.progress = Float(progress)
                    
            })
            
            
        }
        
        
    }
    
    func postStatusImageFileToBackend(image: UIImage){
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let imageWidth = Float(image.size.width)
        let imageHeight = Float(image.size.height)
        
        let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData)
        imageFile?.save(inBackground: { (success, error) in
            
            if success {
                
                let Trendin = BmobObject(className: "Trends")
                Trendin?.setObject(BmobUser.current(), forKey: "poster")
                
                if self.captionTextField.text != self.addCaptionString {
                    
                    Trendin?.setObject(self.captionTextField.text, forKey: "captionText")
                }
                
                Trendin?.setObject(imageFile, forKey: "imageFile")
                Trendin?.setObject(imageWidth, forKey: "imageWidth")
                Trendin?.setObject(imageHeight, forKey: "imageHeight")
                Trendin?.setObject(Int(0), forKey: "numberOfComments")
                Trendin?.setObject(Int(0), forKey: "numberOfLikes")
                Trendin?.setObject([], forKey: "likersArray")
                Trendin?.setObject(self.shareWithFriends, forKey: "shareWithFriends")
                
                if let currentLocation = self.userLocation {
                    
                let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
                    
                Trendin?.setObject(geoPoint, forKey: "userLocation")
                    
                    
                }
                Trendin?.saveInBackground(resultBlock: { (success, error) in
                    if  success{
                        
                        print("rendin object saved successfull")
                        
                        self.slideInOrAwayTheNotificationView(slideDirection: -80)
                        self.incomingTrendingVC?.loadData()
                        
                    }else{
                        
                        self.slideInOrAwayTheNotificationView(slideDirection: -80)

                    }
                })
                
                
                
            }
            
            }, withProgressBlock: { (progress) in
                
              self.slideInOrAwayTheNotificationView(slideDirection: 0)
              self.incomingTrendingVC?.postImageView.image = image
              self.incomingTrendingVC?.progressView.progress = Float(progress)
                
        })
        
        
        
    }
    
    
    func postStatusTextOnly(){
        
      self.slideInOrAwayTheNotificationView(slideDirection: 0)
    
        let TrendinTextOnly = BmobObject(className: "Trends")
        TrendinTextOnly?.setObject(BmobUser.current(), forKey: "poster")
        
        
        if self.captionTextField.text != self.addCaptionString {
            
            TrendinTextOnly?.setObject(self.captionTextField.text, forKey: "statusText")
        }
        TrendinTextOnly?.setObject(Int(0), forKey: "numberOfComments")
        TrendinTextOnly?.setObject(Int(0), forKey: "numberOfLikes")
        TrendinTextOnly?.setObject([], forKey: "likersArray")
        TrendinTextOnly?.setObject(self.shareWithFriends, forKey: "shareWithFriends")
        if let currentLocation = self.userLocation {
            
        let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
            
        TrendinTextOnly?.setObject(geoPoint, forKey: "userLocation")
            
            
        }
        TrendinTextOnly?.saveInBackground(resultBlock: { (success, error) in
            if  success{
                
                print("text only saved")
                
                self.incomingTrendingVC?.loadData()
                self.slideInOrAwayTheNotificationView(slideDirection: -80)
                
                
            }
        })
        
        
    }
    
    
    func slideInOrAwayTheNotificationView(slideDirection: Int){
        
        if let slideView = self.incomingTrendingVC?.slideDownNotificationMenu {
            
            UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                if let window = UIApplication.shared.keyWindow {
                    
                    slideView.frame = CGRect(x: 0, y: slideDirection , width: Int(window.frame.width), height: 80)
                    
                }
                
                }, completion: nil)
            
        }

    }
    
    func slideInOrAwayContestTheNotificationView(slideDirection: Int){
        
        if let slideView = self.incomingCompetionvC?.slideDownNotificationMenu {
            
            UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                if let window = UIApplication.shared.keyWindow {
                    
                    slideView.frame = CGRect(x: 0, y: slideDirection , width: Int(window.frame.width), height: 80)
                    
                }
                
                }, completion: nil)
            
        }
        
    }
    
    var bottomConstraints: NSLayoutConstraint?
    var blurViewHeightConstraint: NSLayoutConstraint?
    
    
    func setUpViews(){
        
        
        self.view.addSubview(bottomView)
        self.view.addSubview(previewImage)
        self.view.addSubview(videoPreviewScreen)
        self.view.addSubview(captionTextField)
        self.view.addSubview(clearTextViewImage)
        
        self.view.addSubview(blurView)
        
        blurView.addSubview(captionTextField)
        blurView.addSubview(clearTextViewImage)
        blurView.addSubview(countTextLabel)
        blurView.addSubview(friendsOnlySwitchButton)
        blurView.addSubview(friendsOnlyLabel)
        
        
        friendsOnlyLabel.rightAnchor.constraint(equalTo: friendsOnlySwitchButton.leftAnchor).isActive = true
        friendsOnlyLabel.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 40).isActive = true
        friendsOnlyLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10).isActive = true
        friendsOnlyLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        friendsOnlySwitchButton.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -30).isActive = true
        friendsOnlySwitchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        friendsOnlySwitchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        friendsOnlySwitchButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10).isActive = true
        
        countTextLabel.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
        countTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countTextLabel.centerYAnchor.constraint(equalTo: captionTextField.centerYAnchor).isActive = true
        countTextLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        captionTextField.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true
        captionTextField.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 60).isActive = true
        captionTextField.leftAnchor.constraint(equalTo: countTextLabel.rightAnchor).isActive = true
        captionTextField.rightAnchor.constraint(equalTo: clearTextViewImage.leftAnchor).isActive = true
        
        
        clearTextViewImage.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -5).isActive = true
        clearTextViewImage.centerYAnchor.constraint(equalTo: captionTextField.centerYAnchor).isActive = true
        clearTextViewImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        clearTextViewImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.bottomConstraints = blurView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8)
        bottomConstraints?.isActive = true
        
        blurView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        blurViewHeightConstraint = blurView.heightAnchor.constraint(equalToConstant: 100)
        blurViewHeightConstraint?.isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        //        reselectImageButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 8).isActive = true
        //        reselectImageButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8).isActive = true
        //        reselectImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //        reselectImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        previewImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        previewImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        previewImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        previewImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8).isActive = true
        
        videoPreviewScreen.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        videoPreviewScreen.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        videoPreviewScreen.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        videoPreviewScreen.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8).isActive = true
       
     
        
    }
    
    
    
    func estimatedRect(statusText: String, fontSize: CGFloat) -> CGRect {
        
        return NSString(string: statusText).boundingRect(with: CGSize(width: 200, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        
    }
    //
    
}
