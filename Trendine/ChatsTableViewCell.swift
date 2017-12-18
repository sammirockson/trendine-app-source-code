//
//  ChatsTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

   
    let profileImageView: customImageView = {
        let imageView = customImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personplaceholder")
        imageView.layer.cornerRadius = 29
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = MessagesCollectionViewCell.blueColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }()
    
      
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    let userContentContainer: UIView = {
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    let divderLine: UIView = {
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let unreadMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let unreadMessageView: UIImageView = {
        let contentView = UIImageView()
        contentView.isHidden = true
//        contentView.backgroundColor = UIColor.red
        contentView.layer.cornerRadius = 13
        contentView.clipsToBounds = true
        contentView.image = UIImage(named: "NumberOfNotificationBG")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpViews()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func  setUpViews(){
        
        //        let newConstraints = AddConstraintsObject()
        addSubview(profileImageView)
        addSubview(userContentContainer)
        addSubview(unreadMessageView)
        
        unreadMessageView.addSubview(unreadMessageLabel)
        
        unreadMessageLabel.centerXAnchor.constraint(equalTo: unreadMessageView.centerXAnchor).isActive = true
        unreadMessageLabel.centerYAnchor.constraint(equalTo: unreadMessageView.centerYAnchor).isActive = true
        unreadMessageLabel.widthAnchor.constraint(equalTo: unreadMessageView.widthAnchor).isActive = true
        unreadMessageView.heightAnchor.constraint(equalTo: unreadMessageView.heightAnchor).isActive = true
        
        
        unreadMessageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
        unreadMessageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        unreadMessageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        unreadMessageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        
        userContentContainer.addSubview(usernameLabel)
        userContentContainer.addSubview(lastMessageLabel)
        userContentContainer.addSubview(timeStampLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        userContentContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userContentContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userContentContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        userContentContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //        userContentContainer.backgroundColor = UIColor.redColor()
        //        usernameLabel.backgroundColor = .blueColor()
        //
        
        timeStampLabel.rightAnchor.constraint(equalTo: userContentContainer.rightAnchor).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: userContentContainer.topAnchor).isActive = true
        timeStampLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeStampLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: timeStampLabel.leftAnchor, constant: 8).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: userContentContainer.topAnchor, constant: 0).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        lastMessageLabel.leftAnchor.constraint(equalTo: userContentContainer.leftAnchor).isActive = true
        lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        lastMessageLabel.heightAnchor.constraint(equalToConstant: 18)
        lastMessageLabel.rightAnchor.constraint(equalTo: userContentContainer.rightAnchor).isActive = true
        
    
        
        
        
    }


}
