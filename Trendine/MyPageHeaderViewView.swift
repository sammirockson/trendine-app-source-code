//
//  MyPageHeaderViewView.swift
//  Trendin
//
//  Created by Rockson on 06/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit



class MyPageHeaderViewView: UICollectionReusableView, UITextViewDelegate {
    
    let backgroundImageView: UIImageView = {
       let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.clipsToBounds = true
        return bg
        
    }()
    
    lazy var blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.isUserInteractionEnabled = true
        bView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return bView
        
    }()
    
    lazy var doneButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.backgroundColor = MessagesCollectionViewCell.blueColor
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.isHidden = true
        btn.addTarget(self, action: #selector(handleDoneEditingStatus), for: .touchUpInside)
        return btn
        
    }()
    
    let profileImageContainerView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 5
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let profileImageView: UIImageView = {
        let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        bg.layer.cornerRadius = 5
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.clipsToBounds = true
        return bg
        
    }()
    
    lazy var userInformationLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return label
        
    }()
    
    let statusTextView: UITextView = {
        let captionTextV = UITextView()
        captionTextV.font = UIFont.systemFont(ofSize: 16)
        captionTextV.textColor = UIColor.white
        captionTextV.backgroundColor = UIColor.clear
        captionTextV.isScrollEnabled = false
        captionTextV.isEditable = true
        captionTextV.isSelectable = true
        captionTextV.dataDetectorTypes = [UIDataDetectorTypes.all]
        captionTextV.translatesAutoresizingMaskIntoConstraints = false
        captionTextV.text = "What's on your mind?"
        captionTextV.layer.cornerRadius = 4
        captionTextV.clipsToBounds = true
        return captionTextV
        
    }()
    
    
    let currentUser = BmobUser.current()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.statusTextView.delegate = self
    
        self.setUpViews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.doneButton.isHidden = false
        self.statusTextView.backgroundColor = .white
        self.statusTextView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.doneButton.isHidden = true
        self.statusTextView.textColor = .white
        self.statusTextView.backgroundColor = .clear


  
    }
    
    func dismissKeyboard(){
        
        self.endEditing(true)
  
    }
    
    func handleDoneEditingStatus(){
        
        self.doneButton.isHidden = true
        self.endEditing(true)
        self.statusTextView.textColor = .white

        if let statuText = self.statusTextView.text {
         self.statusTextView.backgroundColor = .clear

         currentUser?.setObject(statuText, forKey: "OnMind")
         currentUser?.updateInBackground(resultBlock: { (success, error) in
            if success{
                
              print("updated")
                
            }else{
                
                
                print(error?.localizedDescription as Any)
            }
         })
   
            
        }
        
    }
    
    func setUpViews(){
        
    self.backgroundColor = .white
        
     self.addSubview(backgroundImageView)
     self.addSubview(blurView)
     self.addSubview(profileImageContainerView)
     self.addSubview(userInformationLabel)
     self.addSubview(statusTextView)
     self.addSubview(doneButton)
        
        
    doneButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    doneButton.bottomAnchor.constraint(equalTo: statusTextView.topAnchor, constant: -8).isActive = true
    doneButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    statusTextView.topAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor, constant: 8).isActive = true
    statusTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    statusTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    statusTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        
    userInformationLabel.leftAnchor.constraint(equalTo: profileImageContainerView.rightAnchor, constant: 8).isActive = true
    userInformationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    userInformationLabel.centerYAnchor.constraint(equalTo: profileImageContainerView.centerYAnchor).isActive = true
    userInformationLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
     profileImageContainerView.addSubview(profileImageView)
        
    profileImageView.leftAnchor.constraint(equalTo: profileImageContainerView.leftAnchor, constant: 2).isActive = true
    profileImageView.rightAnchor.constraint(equalTo: profileImageContainerView.rightAnchor, constant: -2).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor, constant: -2).isActive = true
    profileImageView.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor, constant: 2).isActive = true



        
     profileImageContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
     profileImageContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
     profileImageContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
     profileImageContainerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
      
      blurView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      blurView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      blurView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
      blurView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
     backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
     backgroundImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
     backgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
     backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
        
        
    }
    
    
}
