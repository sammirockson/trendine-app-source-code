//
//  LoginViewController.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    let inputContainerView: UIView = {
        let inPutView = UIView()
        inPutView.backgroundColor = UIColor.clear
        inPutView.translatesAutoresizingMaskIntoConstraints = false
        return inPutView
        
    }()
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
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
    
    
    lazy var logInButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        return button
        
    }()
    
    
    lazy var moreButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Options", for: .normal)
        button.setTitleColor(MessagesCollectionViewCell.blueColor, for: .normal)
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        
        return button
        
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
    
    let backgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.clipsToBounds = true
        bView.isHidden = false
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
    
    
    var currentUser = false
    
    
    
    func handleTerms(){
        
        
        let termsVC = TermsAndPrivacyViewController()
        termsVC.isIncomingVCTerms = true
        self.navigationController?.pushViewController(termsVC, animated: true)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayActivityInProgressView()
        

        
    }
    
    
    func PopToTerms(){
        
        print("checking....")
    }
    
//    func handlePopToPrivacyButton(){
//    
//      print("the privacy")
//      let privacyVC = TermsAndPrivacyViewController()
//      privacyVC.isIncomingVCTerms = false
//      let navVC = UINavigationController(rootViewController: privacyVC)
//      self.present(navVC, animated: true, completion: nil)
//        
//    }
//    
//    
//    func handleHandleTerms(){
//        print("the terms")
//
//        let privacyVC = TermsAndPrivacyViewController()
//        privacyVC.isIncomingVCTerms = true
//        let navVC = UINavigationController(rootViewController: privacyVC)
//        self.present(navVC, animated: true, completion: nil)
//    }
    
    func displayActivityInProgressView(){
        
        
        if let motherView = UIApplication.shared.keyWindow {
            
            motherView.addSubview(backgroundBlurView)
            
            
            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            backgroundBlurView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 180).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            
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
            
            self.backgroundBlurView.isHidden = true
            
        }
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleLogIn(){
        
        
        if let userId = self.userIdTextField.text , let password = self.passwordTextField.text {
           
            self.backgroundBlurView.isHidden = false
            displayText.text = "Logging in..."

            
            BmobUser.loginWithUsername(inBackground: userId, password: password, block: { (user, error) in
                if error == nil {
                    
                    let currentUser = BmobUser.current()
                    
                    UserDefaults.standard.setValue(false, forKey: "ContestRulesAgreedOrDisagree")
                    
                    let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
                    fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
                    
                    do {
                        
                        let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
                        
                        if results.count > 0 {
                            
                            for result in results{
                                
                                self.moc.delete(result)
                                
                            }
                            
                            do {
                                
                                try self.moc.save()
                                
                                
                                
                            }catch{
                          
                            }
                            
                            
                        }else{
                            
                            //no contacts
                            
                        }
                        
                    }catch{
                 
                    }
                    

                    
                    
                    if let deviceTokenData = UserDefaults.standard.object(forKey: "deviceTokenData") as? Data {
                        
                        let installation = BmobInstallation()
                        installation.setDeviceTokenFrom(deviceTokenData)
                        installation.setObject(currentUser, forKey: "user")
                        installation.setObject(currentUser?.objectId, forKey: "userId")
                        installation.saveInBackground(resultBlock: { (success, error) in
                            if error == nil{
                             
                                print("installation saved")

                                
                            }else{
                                
                                print("error saving installation \(error?.localizedDescription as Any)")
                                installation.saveInBackground()

                            }
                        })
                      
                       
                    
                
                        
                    }
                    
                   
                    if let currentUserProfileImage = BmobUser.current().object(forKey: "profileImageFile") as? BmobFile {
                        
                        if UserDefaults.standard.object(forKey: "chatBackgroundImage") == nil{
                         
                            if let image = UIImage(named: "giftly") {
                                
                                let imageData = UIImageJPEGRepresentation(image, 1.0)
                                UserDefaults.standard.setValue(imageData, forKey: "chatBackgroundImage")
                                
                            }
                            
                        }
                        
                        if let data = NSData(contentsOf: NSURL(string: currentUserProfileImage.url)! as URL) {
                            
                            if  UserDefaults.standard.object(forKey: "profileImageData") != nil{
                                
                                UserDefaults.standard.removeObject(forKey: "profileImageData")
                                UserDefaults.standard.setValue(data, forKey: "profileImageData")
                                
                                
                            }else{
                                
                                UserDefaults.standard.setValue(data, forKey: "profileImageData")
                            }
                        }
                    }
                    
                    
                    if let currentlyLoggedInUser = BmobUser.current() {
                        
                        if let countryCode =  currentlyLoggedInUser.object(forKey: "countrycode") as? String {
                            
                            UserDefaults.standard.setValue(countryCode, forKey: "countryCode")
                            
                        }
                        
                    }
                    self.backgroundBlurView.isHidden = true

                    let navVC = CustomTabbarController()
                    self.present(navVC, animated: true, completion: nil)
                    
                    
                }else{
                    
                    self.backgroundBlurView.isHidden = true

                    self.alert(reason: (error?.localizedDescription)!)
                    
                }
            })
            
            
        }else{
            
            
            alert(reason: "UserId/Password field is empty")
            
        }
        
        
    }

    
    func alert(reason: String){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: reason, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func handleOptions(){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = UIModalPresentationStyle.popover
    
        
        alert.addAction(UIAlertAction(title: "Forgot password?", style: .default, handler: { (action) in
            
           let resetPasswordAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
                if let textField = resetPasswordAlert.textFields?.first as UITextField? {
                    
                    if let email = textField.text {
                        
                        
                            BmobUser.requestPasswordResetInBackground(withEmail: email, block: { (success, error) in
                                if success{
                                    
                                    self.alert(reason: "Check your email and reset your password")
                                    
                                }else{
                                    
                                    
                                    self.alert(reason: error?.localizedDescription as Any as! String)
                                }
                            })
                            
                            
                        
  
                    }
  
                }
            }))
            
         resetPasswordAlert.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
         })
            
        self.present(resetPasswordAlert, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { (action) in
            
            let navVC = UINavigationController(rootViewController: AcceptPhoneInfoViewController())
            self.present(navVC, animated: true, completion: nil)
            
        }))
       
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
           presenter.sourceView = self.moreButton
           presenter.sourceRect = self.moreButton.bounds
            
        }
        present(alert, animated: true, completion: nil)
        
        
    }

    
    
    func setUpViews(){
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(inputContainerView)
        view.addSubview(logInButton)
        view.addSubview(moreButton)
        
        inputContainerView.addSubview(userIdLabel)
        inputContainerView.addSubview(passwordLabel)
        inputContainerView.addSubview(userIdTextField)
        inputContainerView.addSubview(passwordTextField)
        
    
    
        
        moreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -15).isActive = true
        
        logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  20).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -20).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant:  5).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        userIdLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        userIdLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userIdLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        userIdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        
        userIdTextField.leftAnchor.constraint(equalTo: userIdLabel.rightAnchor).isActive = true
        userIdTextField.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        userIdTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
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
        
    }
    

  

}
