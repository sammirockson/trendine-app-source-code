//
//  ChatLogCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit



class ChatLogCollectionViewCell: UICollectionViewCell {
    
    let outgoingProfileImage: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.layer.cornerRadius = 15
        imageV.clipsToBounds = true
        imageV.image = #imageLiteral(resourceName: "personplaceholder")
        return imageV
        
    }()
    
    
    let incomingProfileImage: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.layer.cornerRadius = 15
        imageV.clipsToBounds = true
        imageV.image = #imageLiteral(resourceName: "personplaceholder")
        return imageV
        
    }()
    
    
    let messageContainerView: UIView = {
        let mView = UIView()
        mView.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.layer.cornerRadius = 16
        mView.clipsToBounds = true
        return mView
        
    }()
    
    let messageTextView: UITextView = {
        let textV = UITextView()
        textV.translatesAutoresizingMaskIntoConstraints = false
        textV.text = "Hello world"
        textV.backgroundColor = .clear
        textV.isScrollEnabled = false
        textV.font = UIFont.systemFont(ofSize: 16)
        
        return textV
        
    }()
    
    let bubbleImageView: UIImageView = {
        let imageV = UIImageView()
        //        imageV.contentMode = .scaleAspectFill
        //        imageV.clipsToBounds = true
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.image = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
        imageV.tintColor =  UIColor(white: 0.1, alpha: 0.8)
        return imageV
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = .lightGray
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    var messageWidthConstraint: NSLayoutConstraint?
    
    func setUpViews(){
        
        self.addSubview(outgoingProfileImage)
        self.addSubview(incomingProfileImage)
        self.addSubview(messageContainerView)
        
        messageContainerView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageTextView)
        
        
        bubbleImageView.rightAnchor.constraint(equalTo: messageContainerView.rightAnchor).isActive = true
        bubbleImageView.leftAnchor.constraint(equalTo: messageContainerView.leftAnchor).isActive = true
        bubbleImageView.topAnchor.constraint(equalTo: messageContainerView.topAnchor).isActive = true
        bubbleImageView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor).isActive = true
        
        
        
        
        messageTextView.rightAnchor.constraint(equalTo: bubbleImageView.rightAnchor, constant: -8).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: bubbleImageView.leftAnchor, constant: 12).isActive = true
        messageTextView.topAnchor.constraint(equalTo: bubbleImageView.topAnchor, constant: 5).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: -5).isActive = true
        
        rightConstraint = messageContainerView.rightAnchor.constraint(equalTo: outgoingProfileImage.leftAnchor, constant: 5)
        rightConstraint?.isActive = true
        
        leftConstraint = messageContainerView.leftAnchor.constraint(equalTo: incomingProfileImage.rightAnchor, constant: -5)
        leftConstraint?.isActive = false
        
        messageContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageContainerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageWidthConstraint = messageContainerView.widthAnchor.constraint(equalToConstant: 200)
        messageWidthConstraint?.isActive = true
        
        outgoingProfileImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        outgoingProfileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        outgoingProfileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        outgoingProfileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        incomingProfileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        incomingProfileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        incomingProfileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        incomingProfileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        
    }
    

    
}
