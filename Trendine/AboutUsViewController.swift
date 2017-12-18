//
//  AboutUsViewController.swift
//  Trendin
//
//  Created by Rockson on 12/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    let iconImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    let versionLabel: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .gray
        lb.text = "version 1.2.5"
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
        
    }()
    
    lazy var contactUsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Contact Us", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(handlePushToContactUs), for: .touchUpInside)
        return btn
    }()
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "About us"
        
        self.view.backgroundColor =  UIColor.groupTableViewBackground
    

        
        self.setUpviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePushToContactUs(){
        
        self.navigationController?.pushViewController(ContactUsViewController(), animated: true)
        
        
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
    
    func setUpviews(){
        
        self.view.addSubview(iconImageView)
        self.view.addSubview(versionLabel)
        self.view.addSubview(andLabel)
        self.view.addSubview(termsButton)
        self.view.addSubview(privacyButton)
        self.view.addSubview(contactUsButton)
        
        
        
        contactUsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        contactUsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        contactUsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        contactUsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true 
        
        
        
        
        
        versionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        versionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
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
