//
//  AcceptPhoneInfoViewController.swift
//  Trendin
//
//  Created by Rockson on 8/7/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
//import SinchVerification

class AcceptPhoneInfoViewController: UIViewController, UITextFieldDelegate {
    
//    var verification: Verification!
    
    lazy var pickCountryCode: UILabel = {
       let button = UILabel()
//        button.setTitleColor(.gray, for: .normal)
//        button.setTitle("China", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePopToCountryCodes)))
        button.textAlignment = .left
        button.text = "China"
        button.textColor = .gray
        button.font = UIFont.boldSystemFont(ofSize: 20)
        
        return button
        
    }()
    
    let ArrowImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "Arrow")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
        
    }()
    
    
    let inPutContainerView: UIView = {
       let view = UIView()
        view.backgroundColor =  UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let countryCodeLabel: UILabel = {
        let textF = UILabel()
        textF.backgroundColor =  UIColor.white
//        textF.layer.cornerRadius = 4
        textF.layer.masksToBounds = true
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.text = "+86"
        textF.textColor = .gray
        textF.textAlignment = .center
        textF.font = UIFont.systemFont(ofSize: 14)
//        textF.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
//        textF.layer.borderWidth = 0.5
        return textF
        
    }()

    
    let phoneNumberTextField: UITextField = {
        let textF = UITextField()
        textF.backgroundColor =  UIColor.white
        textF.layer.masksToBounds = true
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.placeholder = "Enter Your Phone Number"
        textF.textAlignment = .center
        textF.font = UIFont.systemFont(ofSize: 18)
        textF.keyboardType = .numberPad
//        textF.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
//        textF.layer.borderWidth = 0.5
        return textF
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Phone Number"
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTouch)))
        
        
        phoneNumberTextField.delegate = self
        
        setUpViews()
        self.view.backgroundColor = UIColor.white
        
        
        let rightBarItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRightBarButton))
        navigationItem.rightBarButtonItem = rightBarItem
        
        let lefttBarItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.leftBarButtonItem = lefttBarItem

 
        
        displayActivityInProgressView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleViewTouch(){
        
        self.view.resignFirstResponder()
        
    }

    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let countryCode = UserDefaults.standard.object(forKey: "countryCode") as? String, let country = UserDefaults.standard.object(forKey: "country") as? String {
            
            self.countryCodeLabel.text = countryCode
            self.pickCountryCode.text = country
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.removeObject(forKey: "countryCode")
        UserDefaults.standard.removeObject(forKey: "country")

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    func handleRightBarButton(){
        
        
        if (self.phoneNumberTextField.text?.utf8.count)! >= 9 {
           
            let phoneNumber = self.phoneNumberTextField.text
            
            self.backgroundBlurView.isHidden = false
            self.displayText.text = "Verifying..."
            
            let query = BmobUser.query()
            query?.whereKey("phoneNumber", equalTo: phoneNumber)
            query?.findObjectsInBackground({ (results, error) in
                if error == nil {
                    
                    if results?.count == 0 {
                        self.backgroundBlurView.isHidden = true
  
                    self.backgroundBlurView.removeFromSuperview()
                        
                     let signUpVC =  SignUpViewController()
                     let navVC = UINavigationController(rootViewController: signUpVC)
                     signUpVC.mobilePhoneNumber = self.phoneNumberTextField.text
                     signUpVC.countryCode = self.countryCodeLabel.text
                     self.present(navVC, animated: true, completion: nil)
                            
                        
                        
                    }else if (results?.count)! > 0 {
                        
                        self.backgroundBlurView.isHidden = true
                        self.showAlert(text: "Phone Number has been registered already")
                    }
                    
                    
                }else{
                    
                    self.backgroundBlurView.isHidden = true
                    
                    
                }
            })
            
            
        }else{
            
            self.showAlert(text: "Verify the Phone Number.")
        }

    
        

       

        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      return true
    }
    

    
    func prepareToVerifyPhoneNumber(){
        
            if (self.phoneNumberTextField.text?.utf8.count)! >= 9 {
            
            if let phoneNumber =  self.phoneNumberTextField.text , let countrCod = self.countryCodeLabel.text {
                
                
                let signUpVC =  SignUpViewController()
                let navVC = UINavigationController(rootViewController: signUpVC)
                signUpVC.mobilePhoneNumber = phoneNumber
                signUpVC.countryCode = countrCod
                self.present(navVC, animated: true, completion: nil)
                
                

             
                }
                        
            }else{
                
                self.showAlert(text: "Verify the Phone Number.")
            }
            
            
       
        
    }
    
    func showAlert(text: String){
        
       let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
       self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func handleLeftBarButton(){
        
        
        self.present(LoginViewController(), animated: true, completion: nil)
            
        
        
        
    }
    
    
    func handlePopToCountryCodes(){
        
        let navVC = UINavigationController(rootViewController: CountryCodesTableVController())
        self.present(navVC, animated: true, completion: nil)
        
    }
    
    func setUpViews(){
        
     self.view.addSubview(inPutContainerView)
     inPutContainerView.addSubview(self.ArrowImageView)
     self.inPutContainerView.addSubview(pickCountryCode)
        inPutContainerView.addSubview(lineView)
        
        lineView.rightAnchor.constraint(equalTo: inPutContainerView.rightAnchor, constant: -8).isActive = true
        lineView.leftAnchor.constraint(equalTo: inPutContainerView.leftAnchor, constant: 8).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.topAnchor.constraint(equalTo: pickCountryCode.bottomAnchor).isActive = true
        
        
        inPutContainerView.addSubview(countryCodeLabel)
        inPutContainerView.addSubview(phoneNumberTextField)
        
        ArrowImageView.rightAnchor.constraint(equalTo: inPutContainerView.rightAnchor, constant: -10).isActive = true
        ArrowImageView.topAnchor.constraint(equalTo: inPutContainerView.topAnchor, constant: 8).isActive = true
        ArrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        ArrowImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        
        phoneNumberTextField.rightAnchor.constraint(equalTo: inPutContainerView.rightAnchor, constant: -8).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        phoneNumberTextField.leftAnchor.constraint(equalTo: countryCodeLabel.rightAnchor).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        countryCodeLabel.leftAnchor.constraint(equalTo: inPutContainerView.leftAnchor, constant:  8).isActive = true
        countryCodeLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        countryCodeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        countryCodeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inPutContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inPutContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inPutContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        inPutContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        pickCountryCode.topAnchor.constraint(equalTo: inPutContainerView.topAnchor).isActive = true
        pickCountryCode.leftAnchor.constraint(equalTo: inPutContainerView.leftAnchor, constant: 8).isActive = true
        pickCountryCode.rightAnchor.constraint(equalTo: ArrowImageView.leftAnchor).isActive = true
        pickCountryCode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    
        
    }


}
