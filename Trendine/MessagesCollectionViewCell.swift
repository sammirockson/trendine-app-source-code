//
//  MessagesCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 9/27/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class MessagesCollectionViewCell: UICollectionViewCell {
    
    var message: Messages?
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = [UIDataDetectorTypes.all]
        textView.layer.masksToBounds = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
        
    }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    let nameCardBackroundView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    let namedCardBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    let failedToDeliverView: UIView = {
        let imageView = UIView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .red
        return imageView
        
    }()
    
    
    let nameCardPorileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    

   
    
    lazy var resendButton: UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    let nameCardUsernameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let audioDurationLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    static let blueColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
    
    
    let bubbleContainerView: UIView = {
        let textView = UIView()
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = true
        return textView
        
    }()
    
    
    
    
    let incomingUserProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    
    let animatedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    let senderProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let timeStampLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 pm"
        label.isHidden = true
        return label
        
    }()
    
    let incomingTimeStampLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 pm"
        label.isHidden = true
        return label
        
    }()
    
    let imageTimeStampLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    let playAudioButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = MessagesCollectionViewCell.blueColor
        btn.titleLabel?.textColor = .white
        return btn
    }()
    
    var bubbleContainerWidth: NSLayoutConstraint?
    var bubbleContainerTopBottomAnchor: NSLayoutConstraint?
    
    var moveTimeRightLabel: NSLayoutConstraint?
    var moveTimeLeftLabel: NSLayoutConstraint?

    var bubbleMoveToLeft: NSLayoutConstraint?
    var bubbleMoveToRight: NSLayoutConstraint?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpViews(){
        
        addSubview(incomingUserProfileImageView)
        addSubview(senderProfileImageView)
        addSubview(timeStampLabel)
        addSubview(incomingTimeStampLabel)
        addSubview(bubbleContainerView)
        addSubview(resendButton)
//        addSubview(activityIndicator)

        bubbleContainerView.addSubview(messageTextView)
        bubbleContainerView.addSubview(messageImageView)
        bubbleContainerView.addSubview(blurView)
        bubbleContainerView.addSubview(playAudioButton)
        bubbleContainerView.addSubview(namedCardBackgroundImageView)
        bubbleContainerView.addSubview(nameCardBackroundView)
        bubbleContainerView.addSubview(audioDurationLabel)
        bubbleContainerView.addSubview(animatedImageView)
        
        self.blurView.addSubview(imageTimeStampLabel)
        
        nameCardBackroundView.addSubview(nameCardPorileImageView)
        nameCardBackroundView.addSubview(nameCardUsernameLabel)
        
        
        
        resendButton.centerYAnchor.constraint(equalTo: bubbleContainerView.centerYAnchor).isActive = true
        resendButton.leftAnchor.constraint(equalTo: bubbleContainerView.rightAnchor, constant: 5).isActive = true
        resendButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        resendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        audioDurationLabel.centerYAnchor.constraint(equalTo: bubbleContainerView.centerYAnchor).isActive = true
        audioDurationLabel.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor, constant: 20).isActive = true
        audioDurationLabel.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        audioDurationLabel.rightAnchor.constraint(equalTo: bubbleContainerView.rightAnchor, constant: -20).isActive = true
        
        
        nameCardUsernameLabel.leftAnchor.constraint(equalTo: nameCardPorileImageView.rightAnchor, constant: 5).isActive = true
        nameCardUsernameLabel.centerYAnchor.constraint(equalTo: nameCardBackroundView.centerYAnchor).isActive = true
        nameCardUsernameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameCardUsernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameCardPorileImageView.leftAnchor.constraint(equalTo: nameCardBackroundView.leftAnchor, constant: 8).isActive = true
        nameCardPorileImageView.centerYAnchor.constraint(equalTo: nameCardBackroundView.centerYAnchor).isActive = true
        nameCardPorileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nameCardPorileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        namedCardBackgroundImageView.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        namedCardBackgroundImageView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        namedCardBackgroundImageView.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor).isActive = true
        namedCardBackgroundImageView.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        
        nameCardBackroundView.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        nameCardBackroundView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        nameCardBackroundView.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor).isActive = true
        nameCardBackroundView.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        
        playAudioButton.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        playAudioButton.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        playAudioButton.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor).isActive = true
        playAudioButton.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        
        incomingTimeStampLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        incomingTimeStampLabel.leftAnchor.constraint(equalTo: bubbleContainerView.rightAnchor, constant: 5).isActive  = true
        incomingTimeStampLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        incomingTimeStampLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        timeStampLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        timeStampLabel.rightAnchor.constraint(equalTo: bubbleContainerView.leftAnchor, constant: -5).isActive = true
        timeStampLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timeStampLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
//        activityIndicator.rightAnchor.constraint(equalTo: bubbleContainerView.leftAnchor, constant: 5).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: bubbleContainerView.centerYAnchor).isActive = true
//        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        imageTimeStampLabel.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 8).isActive = true
        imageTimeStampLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true
        imageTimeStampLabel.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -8).isActive = true
        imageTimeStampLabel.heightAnchor.constraint(equalTo: blurView.heightAnchor).isActive = true
    
       
       
        
        blurView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: bubbleContainerView.rightAnchor).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bubbleContainerView.bottomAnchor).isActive = true
        
        bubbleContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive =  true
        bubbleContainerWidth = bubbleContainerView.widthAnchor.constraint(equalToConstant: 200)
        bubbleContainerWidth?.isActive = true
        
        bubbleMoveToLeft = bubbleContainerView.leftAnchor.constraint(equalTo: incomingUserProfileImageView.rightAnchor, constant: 8)
        bubbleMoveToLeft?.isActive = false
        
        bubbleMoveToRight = bubbleContainerView.rightAnchor.constraint(equalTo: senderProfileImageView.leftAnchor, constant: -8)
        bubbleMoveToRight?.isActive = true
        
        senderProfileImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        senderProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        senderProfileImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        senderProfileImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        
        incomingUserProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        incomingUserProfileImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        incomingUserProfileImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        incomingUserProfileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        
        messageTextView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor, constant: 5).isActive = true
        messageTextView.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        messageTextView.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor, constant: -5).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true
        
        
        
        animatedImageView.leftAnchor.constraint(equalTo: bubbleContainerView.leftAnchor).isActive = true
        animatedImageView.topAnchor.constraint(equalTo: bubbleContainerView.topAnchor).isActive = true
        animatedImageView.widthAnchor.constraint(equalTo: bubbleContainerView.widthAnchor).isActive = true
        animatedImageView.heightAnchor.constraint(equalTo: bubbleContainerView.heightAnchor).isActive = true

        
    }
    

    
}
