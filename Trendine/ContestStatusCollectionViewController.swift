//
//  ContestStatusCollectionViewController.swift
//  Trendin
//
//  Created by Rockson on 04/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class ContestStatusCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let reuseIdentifier = "Cell"
    
    
    private var objects = [BmobObject]()
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.addSubview(refresh)
        
        let rightBarButton = UIBarButtonItem(title: "Exit", style: .done, target: self, action: #selector(handleRightBarButton))
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
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
        
        
        navigationItem.title = "My Status"
        
//        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleRightBarButton))
//        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.register(ContestStatusCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        
        
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
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
    
    func handleRightBarButton(){
        
        let alert = UIAlertController(title: "Do you want to exit the Contest?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: { (action) in
           
            if self.objects.count > 0 {
                
                self.objects.removeAll(keepingCapacity: true)
                self.collectionView?.reloadData()
                
                let query = BmobQuery(className: "Contest")
                query?.includeKey("poster")
                query?.whereKey("poster", equalTo: BmobUser.current())
                query?.findObjectsInBackground({ (results, error) in
                    if error == nil {
                        
                        for result in results! {
                            
                            if let object = result as? BmobObject {
                                
                                object.deleteInBackground({ (success, error) in
                                    if error == nil {
                                        
                                        print("object deleted successfully")
                                        
                                        
                                    }
                                })
                                
                                
                            }
                        }
                    }
                })
                
                
            }
            
            
        }))

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
//                previewVC.incomingCompetionvC = self
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
        query?.whereKey("poster", equalTo: BmobUser.current())
        query?.limit = 1
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                self.objects.removeAll(keepingCapacity: true)
                
                self.refresh.endRefreshing()
                if (results?.count)! > 0 {
                    
                
                    for result in results! {
                    
                        
                        self.objects.append(result as! BmobObject)
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                        
                    }
                    
                    
                    
                }
                
                
            }else{
                
                //There was an error
                //                self.headerView.loadMoreButton.isHidden = false
                
                self.refresh.endRefreshing()
                
                
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
    var seletedCell: ContestStatusCollectionViewCell?
    
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
//                        
//                        let BuyPointsVC = BuyPointsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//                        let navVC = UINavigationController(rootViewController: BuyPointsVC)
//                        self.present(navVC, animated: true, completion: nil)
                        
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
            
            let cell = collectionView?.cellForItem(at: indexPath) as? ContestStatusCollectionViewCell
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
                            
                            print("points updated successfully")
                            
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
                
            }
        })
        
        
    }
    
    func handlePopToComment(sender: UIButton){
        
        let point = sender.convert(sender.bounds.origin, to: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point), let cell = collectionView?.cellForItem(at: indexPath) as? ContestStatusCollectionViewCell{
            
            let selectedItem = self.objects[indexPath.item]
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            let commentVC = CommentCollectionViewController(collectionViewLayout: layout)
            commentVC.incomingContestStatusVC = cell
            commentVC.commentId = selectedItem.objectId
            self.navigationController?.pushViewController(commentVC, animated: true)
            
        }
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContestStatusCollectionViewCell
        
        cell.commentButton.addTarget(self, action: #selector(handlePopToComment), for: .touchUpInside)
        
        cell.likeButton.addTarget(self, action: #selector(handlePointInput), for: .touchUpInside)
        // Configure the cell
        
        let object = self.objects[indexPath.item]
        
        
        if let points = object.object(forKey: "points") as? Int {
            
            let countQuery = BmobQuery(className: "Contest")
            countQuery?.whereKey("points", greaterThan: points)
            countQuery?.countObjectsInBackground({ (countedObjects, error) in
                if error == nil {
                    
                    if countedObjects >= 0 {
                        
                        let currentPosition = countedObjects + 1
                        
                        cell.countingFinalistsLabel.text = String(currentPosition)

                        
                    }
                    
                }
            })
            
            
        }
        
        
        if let user = object.object(forKey: "poster") as? BmobUser, let caption = object.object(forKey: "contestCaption") as? String {
            
            let attributedMutableText = NSMutableAttributedString(string: user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            let atrributedText = NSAttributedString(string: "\n\(caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.white])
            attributedMutableText.append(atrributedText)
            
            cell.captionLabel.attributedText = attributedMutableText
            
            if let profileImageFile = user.object(forKey: "profileImageFile") as? BmobFile {
                
//                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageFile.url)
                
                cell.profileImageView.sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))

            }
            
            
            
            
        }
        
        if let points = object.object(forKey: "points") as? Int {
            
            cell.likesLabel.text = "\(points)"
            
        }
        
        if let numberOfComments = object.object(forKey: "numberOfComments") as? NSNumber {
            
            cell.commentsCountLabel.text = "\(numberOfComments.intValue)"
            
        }
        
        if let imageFile = object.object(forKey: "contestImageFile") as? BmobFile {
            
//            cell.BackgroundImageView.loadImageUsingCacheWithUrlString(urlString: imageFile.url)
            
            cell.BackgroundImageView.sd_setImage(with: NSURL(string: imageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))

        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 450
        
        return CGSize(width: self.view.frame.width - 10, height: height)
    }
    

    
    
    func handleMoreInfo(){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Buy points", style: .destructive, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "My status", style: .default, handler: { (action) in
            
            //query and count the number of users having greater points than the user and add one as his position
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Contest Details", style: .default, handler: { (action) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    

 

}
