//
//  CompetitionCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 10/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CompetitionCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private let reuseIdentifier = "Cell"
    private let headerViewIdentifier = "TimeViewCell"
    private let loadMoreCellId = "loadMoreCellId"
    
    private var objects = [BmobObject]()
    
    
    let noContestLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Contest at the moment."
        label.textAlignment = .center
        label.textColor = .white
        return label
        
    }()
    
    let loadingObjectsActivityIndicator: UIActivityIndicatorView = {
        
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        
    }()
    
    let backgroundV: UIView = {
       let bView = UIView()
        bView.backgroundColor = UIColor.white
        return bView
        
    }()
    
    let BackgroundImageView: customImageView = {
        let imageV = customImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
//        imageV.image = UIImage(named: "RedHeart")
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
    
    
    let rulesBackgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
//        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    let rulesBackgroundView: UIView = {
        let bView = UIView()
        bView.backgroundColor = .white
        bView.layer.cornerRadius = 5
        bView.clipsToBounds = true
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    let rulesOptionsContainerView: UIView = {
        let bView = UIView()
        bView.backgroundColor = .white
        bView.layer.borderWidth = 1
        bView.layer.borderColor = UIColor(white: 0.9 , alpha: 0.8).cgColor
        bView.clipsToBounds = true
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    let thinVerticalLine: UIView = {
        let bView = UIView()
        bView.backgroundColor = .white
        bView.backgroundColor = UIColor(white: 0.9 , alpha: 0.8)
        bView.clipsToBounds = true
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    let rulesTextView: UITextView = {
       let textV = UITextView()
        textV.font = UIFont.systemFont(ofSize: 16)
        textV.translatesAutoresizingMaskIntoConstraints = false
        textV.isEditable = false
        textV.isSelectable = false
        return textV
        
    }()
    
    lazy var agreeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Agree", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleAgreeButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    lazy var disagreeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Disagree", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleDisagreeButtonTapped), for: .touchUpInside)

        return button
        
    }()
    
    let addPointsBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.isHidden = true
        return bView
        
    }()
    
    
    let inputPointsTextField: UITextField = {
       let txtF = UITextField()
        txtF.placeholder = "Enter points"
        txtF.text = "\(1)"
        txtF.translatesAutoresizingMaskIntoConstraints = false
        txtF.textColor = .white
        txtF.keyboardType = .numberPad
        txtF.textAlignment = .center
        return txtF
        
    }()
    
    
    lazy var addPointButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add Points", for: .normal)
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleAddPoints), for: .touchUpInside)
        return button
        
    }()
    
    let balanceLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Bal: 2000pts"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
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
    
    
    lazy var refresh: UIRefreshControl = {
        let RefreshC = UIRefreshControl()
        RefreshC.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return RefreshC
        
    }()
    
    var isLoadingOldPosts = false
    
//    var rightBarButton: UIBarButtonItem?
    
    
    var rightButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.queryCompetitionRules()
       
        

//        let saveContent = BmobObject(className: "ContestRules")
//        saveContent?.setObject("this is the content", forKey: "content")
//        saveContent?.saveInBackground(resultBlock: { (success, error) in
//            if success {
//                
//                print("saved...")
//            }
//        })
        
        
//        UserDefaults.standard.setValue(false, forKey: "ContestRulesAgreedOrDisagree")

        
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
     

        
        

        
        if let currentBalance = BmobUser.current().object(forKey: "contestPoints") as? Int{
        
            self.balanceLabel.text = "Bal: \(currentBalance)"
        
        }

        
        self.collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCollectTap)))
        
        
      setUpViews()
      
        
        navigationItem.title = "Photo Contest"
        
        let image = #imageLiteral(resourceName: "options")
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
//        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        rightButton.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
        rightButton.setBackgroundImage(image, for: .normal)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        if BmobUser.current().objectId != "2e897823de" || BmobUser.current().objectId != "712b4069b8" {
            
            navigationItem.rightBarButtonItem?.isEnabled = false
            rightButton.isEnabled = false
            
        }
        
       


        
        ///////
        
//        rightBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleRightBarButton))
//        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
//        self.rightBarButton?.isEnabled = false
        
        collectionView?.register(ContestTimeView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
        
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.register(CompetitionCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(ContestLoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: loadMoreCellId)

        
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
        
        
        self.view.addSubview(noContestLabel)
        
        noContestLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noContestLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        noContestLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noContestLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        noContestLabel.isHidden = true
        
        
        if let window = self.view {
            
            window.addSubview(rulesBackgroundBlurView)
        
            let x = -(self.view.bounds.width)
            rulesBackgroundBlurView.frame = CGRect(x: x, y: 60, width: self.view.bounds.width, height: self.view.bounds.height)
            rulesBackgroundBlurView.isHidden = true
            
            rulesBackgroundBlurView.addSubview(rulesBackgroundView)
            rulesBackgroundView.topAnchor.constraint(equalTo: rulesBackgroundBlurView.topAnchor, constant: 20).isActive = true
            rulesBackgroundView.leftAnchor.constraint(equalTo: rulesBackgroundBlurView.leftAnchor, constant: 10).isActive = true
            rulesBackgroundView.rightAnchor.constraint(equalTo: rulesBackgroundBlurView.rightAnchor, constant: -10).isActive = true
            rulesBackgroundView.bottomAnchor.constraint(equalTo: rulesBackgroundBlurView.bottomAnchor, constant: -70).isActive = true
            
            rulesBackgroundView.addSubview(rulesOptionsContainerView)
            rulesOptionsContainerView.bottomAnchor.constraint(equalTo: rulesBackgroundView.bottomAnchor).isActive = true
            rulesOptionsContainerView.rightAnchor.constraint(equalTo: rulesBackgroundView.rightAnchor).isActive = true
            rulesOptionsContainerView.leftAnchor.constraint(equalTo: rulesBackgroundView.leftAnchor).isActive = true
            rulesOptionsContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            rulesOptionsContainerView.addSubview(thinVerticalLine)
            thinVerticalLine.centerXAnchor.constraint(equalTo: rulesOptionsContainerView.centerXAnchor).isActive = true
            thinVerticalLine.centerYAnchor.constraint(equalTo: rulesOptionsContainerView.centerYAnchor).isActive = true
            thinVerticalLine.heightAnchor.constraint(equalTo: rulesOptionsContainerView.heightAnchor).isActive = true
            thinVerticalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
            
            rulesOptionsContainerView.addSubview(disagreeButton)
            disagreeButton.rightAnchor.constraint(equalTo: thinVerticalLine.rightAnchor).isActive = true
            disagreeButton.leftAnchor.constraint(equalTo: rulesOptionsContainerView.leftAnchor).isActive = true
            disagreeButton.topAnchor.constraint(equalTo: rulesOptionsContainerView.topAnchor).isActive = true
            disagreeButton.bottomAnchor.constraint(equalTo: rulesOptionsContainerView.bottomAnchor).isActive = true
            
            rulesOptionsContainerView.addSubview(agreeButton)
            agreeButton.rightAnchor.constraint(equalTo: rulesOptionsContainerView.rightAnchor).isActive = true
            agreeButton.leftAnchor.constraint(equalTo: thinVerticalLine.leftAnchor).isActive = true
            agreeButton.topAnchor.constraint(equalTo: rulesOptionsContainerView.topAnchor).isActive = true
            agreeButton.bottomAnchor.constraint(equalTo: rulesOptionsContainerView.bottomAnchor).isActive = true
            
            rulesBackgroundView.addSubview(rulesTextView)
            rulesTextView.leftAnchor.constraint(equalTo: rulesBackgroundView.leftAnchor).isActive = true
            rulesTextView.rightAnchor.constraint(equalTo: rulesBackgroundView.rightAnchor).isActive = true
            rulesTextView.topAnchor.constraint(equalTo: rulesBackgroundView.topAnchor).isActive = true
            rulesTextView.bottomAnchor.constraint(equalTo: rulesOptionsContainerView.topAnchor).isActive = true
            
            
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkContestTime()
        self.loadData()

        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        
        if let agreement = UserDefaults.standard.object(forKey: "ContestRulesAgreedOrDisagree") as? Bool {
            
            if agreement == false {
                
                self.rulesBackgroundBlurView.isHidden = false

                
                UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
                    
                    self.rulesBackgroundBlurView.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height)
                    
                }, completion: nil)
                
                
            }
            
        }

       
        
       



    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        self.slideUpMenu.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    func queryCompetitionRules(){
        
        let query = BmobQuery(className: "ContestRules")
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                if (results?.count)! > 0 {
                    
                    for result in results! {
                        
                        if let foundContent = result as? BmobObject {
                            
                            DispatchQueue.main.async {
                                
                                if let content = foundContent.object(forKey: "content") as? String {
                                    
                                    self.rulesTextView.text = content
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
        })
        
        
    }
    
    func handleAgreeButtonTapped(){
        
        UserDefaults.standard.setValue(true, forKey: "ContestRulesAgreedOrDisagree")

       
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            
            let x = -(self.view.bounds.width)
            self.rulesBackgroundBlurView.frame = CGRect(x: x, y: 60, width: self.view.bounds.width, height: self.view.bounds.height)
            
            
        }) { (completed) in
            
            self.rulesBackgroundBlurView.isHidden = true
  
            
        }
        
        
    }
    
    
    
    func handleDisagreeButtonTapped(){
        
        let alert = UIAlertController(title: "Disagree", message: "If you disagree to our rules and terms then you cannot  use this service!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
  
    func checkContestTime(){
        
        let query = BmobQuery(className: "ContestTime")
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    if (results?.count)! > 0 {
                        
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                        
                    }else{
                        
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
            
            
        }
    }
    
    
    func handleRefresh(){
        
        self.loadData()
        
    }
    
    func handleCollectTap(){
        
        
        self.view.endEditing(true)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification){
        
        if let keyboardInfo = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardInfo.height)
            self.bottomConstraints?.constant = -(keyboardInfo.height)
        }
        
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
        
        
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification){
        
        
        self.bottomConstraints?.constant = 0
        self.addPointsBlurView.isHidden = true
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    
    func alert(reason: String){
        
        let alert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func handleRightBarButton(){
        

        let currentUserId = BmobUser.current().objectId
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
            
            
            let currentUser = BmobUser.current()
            if let verified = currentUser?.object(forKey: "emailVerified") as? Bool{
                if verified == true {
                    
                    
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                    
                    
                }else if verified == false{
                    
                    print("check3 \(verified)")
                    
                    self.displayAlert()
                    
                    
                }
                
                
            }else{
                
                print("coultn'd do anything..")
                
            }
            

            
        }))
        
        alert.addAction(UIAlertAction(title: "Buy Points", style: .destructive, handler: { (action) in
            
            
            let layout = UICollectionViewFlowLayout()
            let buyPoints = BuyPointsCollectionViewController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(buyPoints, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "My status", style: .default, handler: { (action) in
            
            //query and count the number of users having greater points than the user and add one as his position
            
            let layout =  UICollectionViewFlowLayout()
            let currentUserStatusVC = ContestStatusCollectionViewController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(currentUserStatusVC, animated: true)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Contest Rules", style: .default, handler: { (action) in
          
            
            self.rulesBackgroundBlurView.isHidden = false

            UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
                
                
            self.rulesBackgroundBlurView.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height)
                
            }, completion: nil)
            
            
            //            slideViewUpObject.slideUpView()
//            let contestDetailsVC = ContestDetailsViewController()
//            self.navigationController?.pushViewController(contestDetailsVC, animated: true)
//            
//            
            
        }))
        
        
        if currentUserId == "2e897823de" || currentUserId == "712b4069b8"{
            
            alert.addAction(UIAlertAction(title: "Start Timer", style: .destructive, handler: { (action) in
                
                let contest = BmobObject(className: "ContestTime")
                contest?.setObject(NSDate(), forKey: "contestTime")
                contest?.saveInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        self.alert(reason: "timer has been started")
                        
                    }else{
                        
                        self.alert(reason: "\(error?.localizedDescription)")
                        
                    }
                })
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Delete Contest Time", style: .destructive, handler: { (action) in
                
                
                let query = BmobQuery(className: "ContestTime")
                query?.findObjectsInBackground { (results, error) -> Void in
                    if error == nil {
                        
                        
                        if (results?.count)! > 0 {
                            
                            for result in results! {
                                
                                let timeObject = result as! BmobObject
                                timeObject.deleteInBackground({ (success, error) in
                                    if success{
                                        
                                        self.alert(reason: "timer deleted successfully")
                                        
                                    }else{
                                        
                                        self.alert(reason: "\(error?.localizedDescription)")
                                    }
                                })
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }))
            
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.rightButton
            presenter.sourceRect = self.rightButton.bounds
            
        }
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage: UIImage?
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            selectedImage = pickedImage
            
        }else{
            
            
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        dismiss(animated: true) { 
            
            if let image = selectedImage {
                
                let previewVC = PreviewSelectedImageViewController()
                previewVC.incomingImage = image
                previewVC.incomingCompetionvC = self
                let navVC = UINavigationController(rootViewController: previewVC)
                self.present(navVC, animated: true, completion: nil)
                
            }
            
        }
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData(){
        
        self.refresh.beginRefreshing()
        
        print("loading objects...")
        
        let query = BmobQuery(className: "Contest")
        query?.includeKey("poster")
        query?.order(byDescending: "points")
        query?.limit = 100
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                self.objects.removeAll(keepingCapacity: true)
                
                self.refresh.endRefreshing()
                
                
                if (results?.count)! > 0 {
                    
                   self.noContestLabel.isHidden = true

                    
                    
                    for result in results! {
                        
                       self.objects.append(result as! BmobObject)
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                        
                    }
                    
                   
                    
                }else if results?.count == 0 {
                    
                    self.noContestLabel.isHidden = false

                    
                }
                
                
            }else{
                
                self.noContestLabel.isHidden = false

                
                //There was an error
//                self.headerView.loadMoreButton.isHidden = false
                
                self.refresh.endRefreshing()

                
            }
            
            
        }
        
    }
    
    func loadOlderObjects(){
        
        self.isLoadingOldPosts = true
        
        
        print("loading old objects...")
        
        let query = BmobQuery(className: "Contest")
        query?.includeKey("poster")
        query?.order(byDescending: "points")
        query?.limit = 20
        if let lastPoint = self.objects.last?.object(forKey: "points") as? Int {
            
            query?.whereKey("points", lessThan: lastPoint)
            
        
  
        }
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
                print("loaded")
                
                self.isLoadingOldPosts = false
                
                
                if (results?.count)! > 0 {
                    
                    
                    for result in results! {
                        
                     self.objects.append(result as! BmobObject)
                        
                        
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
    

    var bottomConstraints: NSLayoutConstraint?
  
    func setUpViews(){
        
        
        self.view.addSubview(self.addPointsBlurView)
        
        addPointsBlurView.addSubview(inputPointsTextField)
        addPointsBlurView.addSubview(addPointButton)
        addPointsBlurView.addSubview(balanceLabel)
        
        balanceLabel.leftAnchor.constraint(equalTo: addPointsBlurView.leftAnchor, constant: 5).isActive = true
        balanceLabel.rightAnchor.constraint(equalTo: inputPointsTextField.leftAnchor).isActive = true
        balanceLabel.centerYAnchor.constraint(equalTo: addPointsBlurView.centerYAnchor).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addPointButton.rightAnchor.constraint(equalTo: addPointsBlurView.rightAnchor, constant:  -8).isActive = true
        addPointButton.centerYAnchor.constraint(equalTo: addPointsBlurView.centerYAnchor).isActive = true
        addPointButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addPointButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        inputPointsTextField.centerYAnchor.constraint(equalTo: addPointsBlurView.centerYAnchor).isActive = true
        inputPointsTextField.rightAnchor.constraint(equalTo: addPointButton.leftAnchor, constant: 0).isActive = true
        inputPointsTextField.heightAnchor.constraint(equalTo: addPointsBlurView.heightAnchor).isActive = true
        inputPointsTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        addPointsBlurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        addPointsBlurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomConstraints = addPointsBlurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraints?.isActive = true
        addPointsBlurView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    
    
    var selectedItem: BmobObject?
    var seletedCell: CompetitionCollectionViewCell?
    
    func handleAddPoints(){
        
        
        if let enteredPoints =  Int(self.inputPointsTextField.text!) {
            

            if let currentBalance = BmobUser.current().object(forKey: "contestPoints") as? Int{
                if currentBalance >= enteredPoints {
                    
                    //Add the points to the selected Image
                    
                    if let selectObj = self.selectedItem {
                        
                        if  var likes = Int((self.seletedCell?.likesLabel.text)!){
                         
                            likes = likes + enteredPoints
                            
                            self.seletedCell?.likesLabel.text = "\(likes)"
                            self.view?.endEditing(true)

                            self.updatePointsInBackend(selectedItem: selectObj)
                            
                            
                        }
                      
  
                    }
                    
                    
                    
                    
                    
                }else if currentBalance < enteredPoints {
                    
                    //Print alert: insuccificient Balance
                    
                    self.collectionView?.endEditing(true)
                    
                    let alert = UIAlertController(title: "Insufficient points", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Buy points", style: .destructive, handler: { (action) in
                        
                        let BuyPointsVC = BuyPointsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                        self.navigationController?.pushViewController(BuyPointsVC, animated: true)
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                   
//                    alert.addAction(UIAlertAction(title: "Buy points", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
            
        }else{
            
            
            //Alert, points empty
        }
   
        
        
    }
    
    
 
    
    func handlePointInput(sender: UIButton){
        
        self.addPointsBlurView.isHidden = false
        self.inputPointsTextField.becomeFirstResponder()
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        
        if let indexPath = self.collectionView?.indexPathForItem(at: point) {
            
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            
            let item = self.objects[indexPath.item]
            self.selectedItem = item
            
            let cell = collectionView?.cellForItem(at: indexPath) as? CompetitionCollectionViewCell
            self.seletedCell = cell
            
        }
        
        
    }
    
    func updatePointsInBackend(selectedItem: BmobObject){
        
        let currentUser = BmobUser.current()
        
      let query = BmobQuery(className: "Contest")
      query?.getObjectInBackground(withId: selectedItem.objectId, block: { (object, error) in
        if error == nil {
            
            
            if var numberOfPoints = object?.object(forKey: "points") as? Int{
                
                numberOfPoints = numberOfPoints + Int(self.inputPointsTextField.text!)!
                
                object?.setObject(numberOfPoints, forKey: "points")
                object?.updateInBackground(resultBlock: { (success, error) in
                    if success {
                        
                        print("saved then notify...")

                        if let posterObject = object?.object(forKey: "poster") as? BmobObject {
                            
                          let posterId = posterObject.objectId
                          let poster = BmobUser(outDataWithClassName: "_User", objectId: posterId)
                            
                            if posterId != BmobUser.current().objectId {
                                
                                
                                if let username = BmobUser.current().username , let pointsAwarded = self.inputPointsTextField.text{
                                    
                                  
                                    
                                    let notify = BmobObject(className: "NotificationCenter")
                                    notify?.setObject(poster, forKey: "userToBeNotified")
                                    notify?.setObject("gave you \(pointsAwarded) points", forKey: "notificationReason")
                                    notify?.setObject(object?.objectId, forKey: "postId")
                                    notify?.setObject(false, forKey: "notified")
                                    notify?.setObject(BmobUser.current(), forKey: "responder")
                                    notify?.setObject(true, forKey: "awardedPoints")
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
                        
                       
                        
                        
                       print("points updated successfully")
                        //Send notification to the contestant of the added points and the user who added the points
                        //Update the current balance
                        
                        if var currentBalance = currentUser?.object(forKey: "contestPoints") as? Int {
                            
                            let deductFromPoints = Int(self.inputPointsTextField.text!)!
                            if deductFromPoints > 0 {
                                
                                currentBalance = currentBalance - deductFromPoints
                                
                                currentUser?.setObject(currentBalance, forKey: "contestPoints")
                                currentUser?.updateInBackground(resultBlock: { (success, error) in
                                    if success{
                                        
                                        print("user balance updated")
                                        
                                        self.inputPointsTextField.text = "\(0)"
                                        self.balanceLabel.text = "Bal: \(currentBalance)"

                                        
                                        self.loadData()
                                        
                                        
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
    
    func handlePopToComment(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point), let cell = collectionView?.cellForItem(at: indexPath) as? CompetitionCollectionViewCell{
            
            let selectedItem = self.objects[indexPath.item]
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
            commentVC.incomingCompetionVC = cell
            commentVC.commentId = selectedItem.objectId
            self.navigationController?.pushViewController(commentVC, animated: true)
            
        }
        
        
    }
    
    func handleReportButtonTapped(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point){
            
            let selectedItem = self.objects[indexPath.item]
            
            
//            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//            alert.modalPresentationStyle = .popover
//            alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
            
                let reportAlert = UIAlertController(title: "Report this post", message: "", preferredStyle: .actionSheet)
                reportAlert.addAction(UIAlertAction(title: "Copyright issues", style: .destructive, handler: { (action) in
                    
                    let reportPost = BmobObject(className: "ContestReports")
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
                    
                    let report = BmobObject(className: "ContestReports")
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
                if let presenter = reportAlert.popoverPresentationController {
                    presenter.sourceView = sender
                    presenter.sourceRect = sender.bounds
                    
                }
                self.present(reportAlert, animated: true, completion: nil)
                
                
//            }))
            
           
            
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            
//            if let presenter = alert.popoverPresentationController {
//                presenter.sourceView = sender
//                presenter.sourceRect = sender.bounds
//                
//            }
//            self.present(alert, animated: true, completion: nil)
//            
            
        }

        
        
        
    }

    
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Thank you! We're looking into it.", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CompetitionCollectionViewCell
        
//        if self.objects.count == indexPath.row{
//            
//            let loadMoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: loadMoreCellId, for: indexPath) as! ContestLoadMoreCollectionViewCell
//            
//            if self.isLoadingOldPosts == false {
//                
//                self.loadOlderObjects()
//                
//                loadMoreCell.activityIndicator.startAnimating()
//
//                
//            }
//
//            return loadMoreCell
//        }
        
        cell.commentButton.addTarget(self, action: #selector(handlePopToComment), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(handlePointInput), for: .touchUpInside)
        cell.reportButton.addTarget(self, action: #selector(handleReportButtonTapped), for: .touchUpInside)

        // Configure the cell
        
        let object = self.objects[indexPath.item]
        

        
        cell.countingFinalistsLabel.text = String(indexPath.row  + 1)
        
        if let user = object.object(forKey: "poster") as? BmobUser, let caption = object.object(forKey: "contestCaption") as? String {
            
            let attributedMutableText = NSMutableAttributedString(string: user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)])
            let atrributedText = NSAttributedString(string: "\n\(caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.white])
            attributedMutableText.append(atrributedText)
            
            cell.captionLabel.attributedText = attributedMutableText
            
            if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                
                 cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
                
            }
            
        
            
            
        }
        
        if let points = object.object(forKey: "points") as? Int {
            
            cell.likesLabel.text = "\(points)"
        
            
        }
        
        if let numberOfComments = object.object(forKey: "numberOfComments") as? Int {
            
            cell.commentsCountLabel.text = "\(numberOfComments)"
            
            
        }
        
        if let imageFile = object.object(forKey: "contestImageFile") as? BmobFile {
            
            
            cell.BackgroundImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))

        }

    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 450
        
        let object = self.objects[indexPath.item]
        
        if let h = object.object(forKey: "imageHeight") as? Float, let w = object.object(forKey: "imageWidth") as? Float {
            
          height = CGFloat(h) / CGFloat(w) * CGFloat(self.view.frame.width - 10)
            
            return CGSize(width: self.view.frame.width - 10, height: height + 50)

 
            
            
        }
        
        
        
        return CGSize(width: self.view.frame.width - 10, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView: ContestTimeView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            headerView = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath) as? ContestTimeView
            
//            headerView?.MoreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
            
        }
        
        return headerView!
    }
    
    
//    func handleMoreInfo(sender: UIButton){
//        
//        let currentUserId = BmobUser.current().objectId
////        let slideViewUpObject = SlideUpContestDetails()
//        
//        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        alert.modalPresentationStyle = .popover
//        alert.addAction(UIAlertAction(title: "Buy Points", style: .destructive, handler: { (action) in
//            
//            
//            let layout = UICollectionViewFlowLayout()
//            let buyPoints = BuyPointsCollectionViewController(collectionViewLayout: layout)
//            self.navigationController?.pushViewController(buyPoints, animated: true)
//            
//        }))
//        
//        alert.addAction(UIAlertAction(title: "My status", style: .default, handler: { (action) in
//            
//            //query and count the number of users having greater points than the user and add one as his position
//            
//            let layout =  UICollectionViewFlowLayout()
//            let currentUserStatusVC = ContestStatusCollectionViewController(collectionViewLayout: layout)
//            self.navigationController?.pushViewController(currentUserStatusVC, animated: true)
//            
//        }))
//        
//        
//        alert.addAction(UIAlertAction(title: "Contest Details", style: .default, handler: { (action) in
//            
////            slideViewUpObject.slideUpView()
////            let contestDetailsVC = ContestDetailsViewController()
//            self.navigationController?.pushViewController(contestDetailsVC, animated: true)
//            
//            
//            
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        if currentUserId == "2e897823de" || currentUserId == "712b4069b8"{
//            
//            alert.addAction(UIAlertAction(title: "Start Timer", style: .destructive, handler: { (action) in
//                
//                let contest = BmobObject(className: "ContestTime")
//                contest?.setObject(NSDate(), forKey: "contestTime")
//                contest?.saveInBackground(resultBlock: { (success, error) in
//                    if success {
//                        
//                        self.alert(reason: "timer has been started")
//                        
//                    }else{
//                        
//                        self.alert(reason: "\(error?.localizedDescription)")
//                        
//                    }
//                })
//                
//                
//            }))
//            
//            alert.addAction(UIAlertAction(title: "Delete Contest Time", style: .destructive, handler: { (action) in
//                
//                
//                    let query = BmobQuery(className: "ContestTime")
//                    query?.findObjectsInBackground { (results, error) -> Void in
//                        if error == nil {
//                            
//                            
//                            if (results?.count)! > 0 {
//                                
//                                for result in results! {
//                                    
//                                    let timeObject = result as! BmobObject
//                                    timeObject.deleteInBackground({ (success, error) in
//                                        if success{
//                                            
//                                          self.alert(reason: "timer deleted successfully")
//                                            
//                                        }else{
//                                            
//                                            self.alert(reason: "\(error?.localizedDescription)")
//                                        }
//                                    })
//                                    
//                                }
//                                
//                            }
//                            
//                            
//                            
//                        }
//                        
//                        
//                    }
//                    
//                
//                
//            }))
//            
//            
//        }
//        
//        if let presenter = alert.popoverPresentationController {
//            presenter.sourceView = sender
//            presenter.sourceRect = sender.bounds
//            
//        }
//        self.present(alert, animated: true, completion: nil)
//        
//    }
    
    func displayAlert(){
        
            
            let resetPasswordAlert = UIAlertController(title: "", message: "Re-enter your Email for verification", preferredStyle: .alert)
            resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            resetPasswordAlert.addAction(UIAlertAction(title: "Verify Email", style: .default, handler: { (action) in
                if let textField = resetPasswordAlert.textFields?.first as UITextField? {
                    
                    if let email = textField.text {
                    BmobUser.current().verifyEmailInBackground(withEmailAddress: email, block: { (verified, error) in
                        if verified {
                            
                        let currentUser = BmobUser.current()
                        currentUser?.setObject(true, forKey: "emailVerified")
                        currentUser?.updateInBackground(resultBlock: { (success, error) in
                            if success {
                                
                                DispatchQueue.main.async {
                                    
                                    let picker = UIImagePickerController()
                                    picker.sourceType = .photoLibrary
                                    picker.delegate = self
                                    self.present(picker, animated: true, completion: nil)
                                    
                                    
                                }
                                
                            }else{
                                
                                self.alert(reason: (error?.localizedDescription)!)
  
                                
                            }
                        })
                            
                           
                          
                            
                        }else{
                            
                          self.alert(reason: (error?.localizedDescription)!)
                            
                        }
                    })
                        

                        
                        
                        
                    }
                    
                }
            }))
            
            resetPasswordAlert.addTextField(configurationHandler: { (textField) in
                
                textField.placeholder = "Enter your email"
                textField.keyboardType = .emailAddress
            })
            
            self.present(resetPasswordAlert, animated: true, completion: nil)
            
        
       
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 100)  // Header size
        
    }
    
 

}
