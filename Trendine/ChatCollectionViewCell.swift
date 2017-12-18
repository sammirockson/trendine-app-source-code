//
//  ChatCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rockson"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        //        label.backgroundColor = .red
        return label
        
    }()
    
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12:30 PM"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
        
    }()
    
    
    let lastMessageLabewl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Did you get the memo? If you didn't get it then we gotta reschedule the whole meeting."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 2
        //        label.backgroundColor = .green
        return label
        
    }()
    
    
    let userInfoContainer: UIView = {
        let divLine = UIView()
        divLine.backgroundColor = .clear
        divLine.translatesAutoresizingMaskIntoConstraints = false
        return divLine
        
    }()
    
    let dividerLine: UIView = {
        let divLine = UIView()
        divLine.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        divLine.translatesAutoresizingMaskIntoConstraints = false
        return divLine
        
    }()
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.image = #imageLiteral(resourceName: "personplaceholder")
        imageV.layer.cornerRadius = 34
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpViews(){
        
        self.addSubview(dividerLine)
        self.addSubview(profileImageView)
        self.addSubview(userInfoContainer)
        userInfoContainer.addSubview(timeStampLabel)
        userInfoContainer.addSubview(usernameLabel)
        userInfoContainer.addSubview(lastMessageLabewl)
        
        
        lastMessageLabewl.rightAnchor.constraint(equalTo: userInfoContainer.rightAnchor, constant: -8).isActive = true
        lastMessageLabewl.leftAnchor.constraint(equalTo: userInfoContainer.leftAnchor).isActive = true
        lastMessageLabewl.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        lastMessageLabewl.bottomAnchor.constraint(equalTo: userInfoContainer.bottomAnchor).isActive = true
        
        
        usernameLabel.rightAnchor.constraint(equalTo: timeStampLabel.leftAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: userInfoContainer.leftAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: timeStampLabel.centerYAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        timeStampLabel.rightAnchor.constraint(equalTo: userInfoContainer.rightAnchor, constant: -8).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: userInfoContainer.topAnchor).isActive = true
        timeStampLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        timeStampLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        userInfoContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        userInfoContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userInfoContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userInfoContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        dividerLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 82).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }

    
}
