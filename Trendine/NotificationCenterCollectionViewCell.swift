//
//  NotificationCenterCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 05/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class NotificationCenterCollectionViewCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    
    let PostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
     let notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rockson commented on your post"
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    let statusTextView: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let addButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = MessagesCollectionViewCell.blueColor
        btn.setTitle("Add", for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return btn
        
    }()
    
    let videoButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "PlayButton")
        btn.setBackgroundImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.isHidden = true
        return btn
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
      
        self.addSubview(profileImage)
        self.addSubview(PostImageView)
        self.addSubview(notificationLabel)
        self.addSubview(dividerLine)
        self.addSubview(timeStampLabel)
        self.addSubview(statusTextView)
        self.addSubview(videoButton)
        self.addSubview(addButton)

        
        videoButton.centerXAnchor.constraint(equalTo: PostImageView.centerXAnchor).isActive = true
        videoButton.centerYAnchor.constraint(equalTo: PostImageView.centerYAnchor).isActive = true
        videoButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        videoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        

        statusTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        statusTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusTextView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        statusTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        dividerLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        timeStampLabel.bottomAnchor.constraint(equalTo: dividerLine.topAnchor, constant: -5).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor).isActive = true
        timeStampLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        timeStampLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        notificationLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -68).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        PostImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        PostImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        PostImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        PostImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
      
    }
    
}
