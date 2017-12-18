//
//  RecommendedUsersViewCell.swift
//  Trendin
//
//  Created by Rockson on 10/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class RecommendedUsersViewCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
       let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = 20
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    let BackgroundImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    let AddUserButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = MessagesCollectionViewCell.blueColor
        button.setTitle("Invite", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        return button
        
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rockson"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        
        self.setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        addSubview(BackgroundImageView)
        addSubview(blurView)
        blurView.addSubview(AddUserButton)
        self.blurView.addSubview(profileImageView)
        
        blurView.addSubview(usernameLabel)
        
        
        usernameLabel.leftAnchor.constraint(equalTo: self.blurView.leftAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.blurView.rightAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.blurView.topAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        BackgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        BackgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        BackgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        BackgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        blurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        
        
        AddUserButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -2).isActive = true
        AddUserButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        AddUserButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        AddUserButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        AddUserButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 8).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
