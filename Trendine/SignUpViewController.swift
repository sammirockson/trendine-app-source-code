//
//  SignUpViewController.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
    var mobilePhoneNumber: String?
    var countryCode: String?
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    
    lazy var termsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Terms", for: .normal)
        btn.setTitleColor(MessagesCollectionViewCell.blueColor, for: .normal)
        btn.addTarget(self, action: #selector(handleTerms), for: .touchUpInside)
        return btn
    }()
    
    
    let andLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .gray
        lb.text = "and"
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
        
    }()
    
    lazy var privacyButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Privacy", for: .normal)
        btn.setTitleColor(MessagesCollectionViewCell.blueColor, for: .normal)
        btn.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    lazy var itemsContainerView: UIView = {
        let inPutView = UIView()
        inPutView.isUserInteractionEnabled = true
        inPutView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        inPutView.translatesAutoresizingMaskIntoConstraints = false
        inPutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDimissKeyboard)))
        return inPutView
        
    }()

    
    let inputContainerView: UIView = {
        let inPutView = UIView()
        inPutView.backgroundColor = UIColor.clear
        inPutView.translatesAutoresizingMaskIntoConstraints = false
        return inPutView
        
    }()
    
    let userIdTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.placeholder = "username"
        textF.font = UIFont.systemFont(ofSize: 16)
        textF.layer.cornerRadius = 4
        textF.layer.masksToBounds = true
        return textF
        
    }()
    

    
    let displayInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = UIFont.boldSystemFont(ofSize: 15)
        return label
        
    }()

    
    let userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = UIFont.boldSystemFont(ofSize: 15)
        return label
        
    }()
    
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = UIFont.boldSystemFont(ofSize: 15)
        return label
        
    }()
    
    let passwordTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.placeholder = "password"
        textF.font = UIFont.systemFont(ofSize: 16)
        textF.isSecureTextEntry = true
        textF.layer.cornerRadius = 4
        textF.layer.masksToBounds = true
        return textF
        
    }()
    
    
    let EmailTextField: UITextField = {
        let textF = UITextField()
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.placeholder = "email"
        textF.font = UIFont.systemFont(ofSize: 16)
        textF.layer.cornerRadius = 4
        textF.layer.masksToBounds = true
        textF.keyboardType = UIKeyboardType.emailAddress
        return textF
        
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = UIFont.boldSystemFont(ofSize: 15)
        return label
        
    }()
    
    lazy var profileImageView: UIImageView = {
        let profileImageV = UIImageView()
        profileImageV.contentMode = .scaleAspectFill
        profileImageV.layer.cornerRadius = 4
        profileImageV.layer.masksToBounds = true
        profileImageV.translatesAutoresizingMaskIntoConstraints = false
        profileImageV.image = UIImage(named: "personplaceholder")
        profileImageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
        profileImageV.isUserInteractionEnabled = true
        return profileImageV
        
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
    
    let bgBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        bView.translatesAutoresizingMaskIntoConstraints = false
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
        return lb
        
    }()

    
    var signUpButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    
    var phoneNumberVerified: Bool?
    var hideEmailTextField: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
        if hideEmailTextField == true {
            
           self.emailLabel.isHidden = true
           self.EmailTextField.isHidden = true
            
            
        }else{
            
            self.emailLabel.isHidden = false
            self.EmailTextField.isHidden = false
            
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setUpViews()
        
        navigationItem.title = "Sign Up"
        
        view.backgroundColor = UIColor.white
    
        
        signUpButton = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(handleSetUpForSignUp))
        navigationItem.setRightBarButton(signUpButton, animated: true)
        
        leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleLeftBarButton))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)

        self.displayActivityInProgressView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        view.resignFirstResponder()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
    }
    
    
    func handleSetUpForSignUp(){
        
        
        UserDefaults.standard.setValue(false, forKey: "ContestRulesAgreedOrDisagree")

        self.signUpButton.isEnabled = false
        self.leftBarButton.isEnabled = false
        
        self.bgBlurView.isHidden = false
        self.activityIndicator.startAnimating()
        self.displayText.text = "Signing Up..."
        
        
        
            if self.userIdTextField.text != "" &&  self.passwordTextField.text != "" && self.EmailTextField.text != ""{
                
              
                if let deviceTokenString = UserDefaults.standard.object(forKey: "deviceTokenString") as? String {
                    
                    print("Token is there...")
                    
                    
                    let query = BmobUser.query()
                    query?.whereKey("deviceTokenString", equalTo: deviceTokenString)
                    query?.findObjectsInBackground({ (results, error) in
                        if error == nil {
                            
                            if (results?.count)! < 3 {
                                
                                print("Token is not found in Database")
                                
                                self.signUpUser()
                                
                            }else if (results?.count)! >= 2 {
                                
                                DispatchQueue.main.async {
                                    
                                    self.bgBlurView.isHidden = true
                                    
                                    let warningAlert = UIAlertController(title: "Multiple accounts detected!!", message: "", preferredStyle: .alert)
                                    warningAlert.addAction(UIAlertAction(title: "Log in", style: .default, handler: { (action) in
                                        
                                        self.present(LoginViewController(), animated: true, completion: nil)
                                        
                                    }))
                                    
                                    self.present(warningAlert, animated: true, completion: nil)
                                    
                                    
                                    
                                }
                                
                                
                            }else{
                                
                                self.signUpUser()
                                
                                self.bgBlurView.isHidden = true
                                self.signUpButton.isEnabled = true
                                self.leftBarButton.isEnabled = true
                            }
                            
                            
                        }else{
                            
                            
                            self.signUpUser()
                            print(error?.localizedDescription as Any)
                        }
                    })
                    
                    
                    
                }else{
                    
                    //DeviceTokenString is not available
                    print("token not save in userDefaults")
                    self.signUpUser()
                    
                }
                
                
            }else{
                
                // textfield empty
                
                self.signUpButton.isEnabled = true
                self.leftBarButton.isEnabled = true
                self.alert(reason: "userId/password/email field is empty")
            }
            
            
      

        
    }
    
    func displayActivityInProgressView(){
        
        if let motherView = self.view {
            
            motherView.addSubview(bgBlurView)
            
            bgBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            bgBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            bgBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            bgBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            bgBlurView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: bgBlurView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: bgBlurView.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            blurView.addSubview(activityIndicator)
            blurView.addSubview(displayText)
            
            displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
            displayText.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
            displayText.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
            displayText.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            activityIndicator.startAnimating()
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            self.bgBlurView.isHidden = true
            
        }
      
        
        
    }
    

    
    func handleImagePicker(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func popBackToLoginVC(){
        
        self.dismiss(animated: true, completion: {
          
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)

            
        })
        
    }
    
    func handleDimissKeyboard(){
        
     
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            
            self.userLocation = currentLocation
        }
    }
    
    
    
    func handleRightBarButton(){
        
//        sender.isEnabled = false
        
      

        
        

    }
    
    
    func signUpUser(){
        
        print("signing up....")
        
        if self.userIdTextField.text != "" &&  self.passwordTextField.text != "" && self.EmailTextField.text != ""{
            
            self.bgBlurView.isHidden = false
            self.displayText.text = "Signing Up..."
            
            let userId = self.userIdTextField.text
            let password = self.passwordTextField.text
            let email = self.EmailTextField.text
            
            
            if let image =  self.profileImageView.image, let imageData = UIImageJPEGRepresentation(image, 0.3) {
                
                let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData)
                imageFile?.save(inBackground: { (success, error) in
                    if success{
                        
                        print("profile Image saved..")
                        
                        let user = BmobUser()
                        user.username = userId
                        user.password = password
                        user.setObject(imageFile, forKey: "profileImageFile")
                        user.setObject(true, forKey: "FindByNearBy")
                        user.setObject(true, forKey: "FindByPhone")
                        user.email = email
                        user.setObject(50, forKey: "contestPoints")
                        user.setObject(false, forKey: "emailVerified")
                        if let deviceTokenString = UserDefaults.standard.object(forKey: "deviceTokenString") as? String {
                            
                            user.setObject(deviceTokenString, forKey: "deviceTokenString")
                            
                            print("token available \(deviceTokenString)")
                            
                            
                        }
                        
                        
                        
                        if let verifiedOrNot = self.phoneNumberVerified {
                            
                            user.setObject(verifiedOrNot, forKey: "phoneNumberVerified")
                            
                        }
                        
                        if let phoneNumber = self.mobilePhoneNumber, let countryCod = self.countryCode {
                            
                            
                            user.setObject(countryCod, forKey: "countrycode")
                            user.setObject(phoneNumber, forKey: "phoneNumber")
                            
                            let fullNumber = countryCod + phoneNumber
                            user.setObject(fullNumber, forKey: "fullPhoneNumber")
                            
                            
                            
                        }
                        
                        if let currentLocation = self.userLocation {
                            
                            let geoPoint = BmobGeoPoint(longitude: currentLocation.coordinate.longitude, withLatitude: currentLocation.coordinate.latitude)
                            
                            user.setObject(geoPoint, forKey: "userLocation")
                            
                            
                        }
                        
                        user.signUpInBackground({ (success, error) in
                            
                            if success{
                                
                                let currentUser = BmobUser.current()
                                
                                
                                
                                print("signed UP....")
                                
                                
                                let query = BmobUser.query()
                                query?.limit = 1
                                query?.getObjectInBackground(withId: "2e897823de", block: { (object, error) in
                                    if error == nil {
                                        
                                        
                                        if let admin = object as? BmobUser {
                                            
                                            let adminRelation = BmobRelation()
                                            
                                            adminRelation.add(admin)
                                            currentUser?.add(adminRelation, forKey: "friends")
                                            currentUser?.updateInBackground(resultBlock: { (success, error) in
                                                if success{
                                                    
                                                    
                                                    print("admin updated")
                                                    
                                                    self.prepareToTransitionToMainView(imageData: imageData as NSData)
                                                    
                                                    
                                                }
                                            })
                                            
                                            
                                            
                                            
                                        }
                                        
                                    }else{
                                        

                                        self.bgBlurView.isHidden = true
                                        self.signUpButton.isEnabled = true
                                        self.leftBarButton.isEnabled = true
                                        print(error?.localizedDescription as Any)
                                    }
                                })
                                
                                
                            }else{
                                
                                self.bgBlurView.isHidden = true
                                self.signUpButton.isEnabled = true
                                self.leftBarButton.isEnabled = true

                                self.alert(reason: error?.localizedDescription as Any as! String)
                                
                                
                            }
                            
                            
                        })
                        
                        
                        
                    }else{
                        
                        
                        // error
                        

                        self.signUpButton.isEnabled = true
                        self.leftBarButton.isEnabled = true
                        self.bgBlurView.isHidden = true
                        self.alert(reason: (error?.localizedDescription)!)
                    }
                })
                
            }
            
            
            
            
            
        }else{
            
            // textfield empty

            
            self.signUpButton.isEnabled = true
            self.leftBarButton.isEnabled = true
            self.alert(reason: "userId/password/email field is empty")
        }
        
        
        
        
        
        
        
        
    }
    
    
    func prepareToTransitionToMainView(imageData: NSData){
        
           let currentUser = BmobUser.current()
        
    
            if let deviceTokenData = UserDefaults.standard.object(forKey: "deviceTokenData") as? Data {
             

                let installation = BmobInstallation()
                installation.setDeviceTokenFrom(deviceTokenData)
                installation.setObject(currentUser, forKey: "user")
                installation.setObject(currentUser?.objectId, forKey: "userId")
                installation.saveInBackground(resultBlock: { (success, error) in
                    
                    if success{
                        
                        print("installation saved")
                        
                    }else{
                        
                        print(error?.localizedDescription as Any)
                    }
                    
                    
                })
                
                
                
                
        }
                

       
    
      
        
        
        if let image = UIImage(named: "giftly") {
            
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            UserDefaults.standard.setValue(imageData, forKey: "chatBackgroundImage")
            
        }
        
        
        if  UserDefaults.standard.object(forKey: "profileImageData") != nil{
            
            UserDefaults.standard.removeObject(forKey: "profileImageData")
            UserDefaults.standard.setValue(imageData, forKey: "profileImageData")
            
            
        }else{
            
            UserDefaults.standard.setValue(imageData, forKey: "profileImageData")
        }
        
        
        
        let relation = BmobRelation()
        relation.add(currentUser)
        currentUser?.add(relation, forKey: "friends")
        currentUser?.updateInBackground(resultBlock: { (success, error) in
            if error == nil {

                print("added the user to itself")
                
                let query = BmobUser.query()
                query?.getObjectInBackground(withId: "712b4069b8", block: { (userObject, error) in
                    if error == nil {
                        
                        let adminRelation = BmobRelation()
                        adminRelation.add(userObject)
                        currentUser?.add(adminRelation, forKey: "friends")
                        currentUser?.updateInBackground(resultBlock: { (success, error) in
                            if success {
                                
                                
                                self.signUpButton.isEnabled = true
                                self.leftBarButton.isEnabled = true
                                self.bgBlurView.isHidden = true
                                
//                                let alertDisplay = UIAlertController(title: "", message: "Activation link has been sent to your email address. Please confirm your account and tap Next", preferredStyle: .alert)
//                                alertDisplay.addAction(UIAlertAction(title: "Next", style: .cancel, handler: { (action) in
//                
                                    self.bgBlurView.removeFromSuperview()
                                    
                                    DispatchQueue.main.async {
                                        
                                        let customVC = RecommendedPointsViewController()
                                        self.present(customVC, animated: true, completion: nil)
                                    }
//                                }))
//                                self.present(alertDisplay, animated: true, completion: nil)
                                
                                
                            }
                        })
                        
                        
                    }else{
                        
                        self.signUpButton.isEnabled = true
                        self.leftBarButton.isEnabled = true
                        BmobUser.current().deleteInBackground({ (success, error) in
                            if success {
                                
                                
                            }
                        })
                        
                        self.bgBlurView.isHidden = true
                        
                    }
                })
                
                
                ////////////////
                
            }else{
                
 
                self.signUpButton.isEnabled = true
                self.leftBarButton.isEnabled = true
                BmobUser.current().deleteInBackground({ (success, error) in
                    if success {
                        
                        
                    }
                })
                
                self.bgBlurView.isHidden = true
                
            }
        })
        

    
    
        
    }
    
 
    func alert(reason: String){
        
        let alert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func verifyEmail(){
        
        let resetPasswordAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        resetPasswordAlert.addAction(UIAlertAction(title: "Enter email", style: .default, handler: { (action) in
            if let textField = resetPasswordAlert.textFields?.first as UITextField? {
                
                if let email = textField.text {
                    
                    if let currentUser = BmobUser.current(){
                        
                        currentUser.verifyEmailInBackground(withEmailAddress: email, block: { (success, error) in
                            if success {
                            
                                DispatchQueue.main.async {
                                    
                                    let customVC = CustomTabbarController()
                                    self.present(customVC, animated: true, completion: nil)
                                }
                            
                                
                            }else{
                                
                                
                                self.alert(reason: error?.localizedDescription as Any as! String)
                            }
                        })
                        
                        
                        
                    }
                    
                }
                
            }
        }))
        
        resetPasswordAlert.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Enter your email"
        })
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    
    func handleLeftBarButton(){
        
        self.present(LoginViewController(), animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.profileImageView.image = image
            
        }
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            self.profileImageView.image = image
        }
        
        
        self.dismiss(animated: true, completion: nil)
        
       
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true, completion: nil)
    }
    
    
    func handleTerms(){
        
        
        let termsVC = TermsAndPrivacyViewController()
        termsVC.isIncomingVCTerms = true
        self.navigationController?.pushViewController(termsVC, animated: true)
        
    }
    
    
    func handlePrivacy(){
        
        
        let termsVC = TermsAndPrivacyViewController()
        termsVC.isIncomingVCTerms = false
        self.navigationController?.pushViewController(termsVC, animated: true)
        
        
    }


    func setUpViews(){
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(inputContainerView)
        view.addSubview(profileImageView)
        
        self.view.addSubview(andLabel)
        self.view.addSubview(termsButton)
        self.view.addSubview(privacyButton)
        
      
        
        inputContainerView.addSubview(emailLabel)
        inputContainerView.addSubview(EmailTextField)
        inputContainerView.addSubview(userIdLabel)
        inputContainerView.addSubview(passwordLabel)
        inputContainerView.addSubview(userIdTextField)
        inputContainerView.addSubview(passwordTextField)
        
        
        
        
        
        emailLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        emailLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        EmailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        EmailTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        EmailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        EmailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        
        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant:  -30).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        passwordLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant:  5).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        userIdLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        userIdLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userIdLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        userIdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        
        userIdTextField.leftAnchor.constraint(equalTo: userIdLabel.rightAnchor).isActive = true
        userIdTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        userIdTextField.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor).isActive = true
        userIdTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.rightAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant:  5).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -8).isActive = true
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  8).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        
        andLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        andLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        andLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        andLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        termsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        termsButton.rightAnchor.constraint(equalTo: andLabel.leftAnchor).isActive = true
        termsButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        privacyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        privacyButton.leftAnchor.constraint(equalTo: andLabel.rightAnchor).isActive = true
        privacyButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }

    
}
