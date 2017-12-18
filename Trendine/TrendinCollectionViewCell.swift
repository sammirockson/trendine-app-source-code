//
//  TrendinCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation

class TrendinCollectionViewCell: UICollectionViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var object: TrendinObject?{
        
        didSet{
            
 
            
        }
    }
    
    
    let controlsContainerView: UIView = {
        let View = UIView()
        View.contentMode = .scaleAspectFill
        View.translatesAutoresizingMaskIntoConstraints = false
        View.layer.masksToBounds = true
        View.isUserInteractionEnabled = true
        View.backgroundColor = UIColor.clear
        return View
        
    }()
    
    let statusContainerView: UIView = {
        let View = UIView()
        View.contentMode = .scaleAspectFill
        View.translatesAutoresizingMaskIntoConstraints = false
        View.layer.masksToBounds = true
        return View
        
    }()
    
    
    let videoContainerView: UIView = {
        let View = UIView()
        View.contentMode = .scaleAspectFill
        View.translatesAutoresizingMaskIntoConstraints = false
        View.layer.masksToBounds = true
        return View
        
    }()
    
    let videoPlayerView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    let captionTextView: UITextView = {
        let captionTextV = UITextView()
        captionTextV.font = UIFont.systemFont(ofSize: 17)
        captionTextV.textColor = UIColor.darkGray
        captionTextV.backgroundColor = UIColor.clear
        captionTextV.isScrollEnabled = false
        captionTextV.isEditable = false
        captionTextV.isSelectable = true
        captionTextV.dataDetectorTypes = [UIDataDetectorTypes.all]
        captionTextV.translatesAutoresizingMaskIntoConstraints = false
        captionTextV.isHidden = true
        return captionTextV
        
    }()
    
    
    let videoCaptionTextView: UITextView = {
        let captionTextV = UITextView()
        captionTextV.font = UIFont.systemFont(ofSize: 17)
        captionTextV.textColor = UIColor.darkGray
        captionTextV.backgroundColor = UIColor.clear
        captionTextV.isScrollEnabled = false
        captionTextV.isEditable = false
        captionTextV.isSelectable = true
        captionTextV.dataDetectorTypes = [UIDataDetectorTypes.all]
        captionTextV.translatesAutoresizingMaskIntoConstraints = false
        captionTextV.isHidden = true
        return captionTextV
        
    }()
    
    let statusTextView: UITextView = {
        let statusView = UITextView()
        statusView.isEditable = false
        statusView.isSelectable = true
        statusView.isScrollEnabled = false
        statusView.text = ""
        statusView.font = UIFont.systemFont(ofSize: 18)
        statusView.textColor = UIColor.darkGray
        statusView.dataDetectorTypes = [UIDataDetectorTypes.all]
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    
    let dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let verticalDividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "options"), for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    lazy var commentLabel: UILabel = {
          let label = UILabel()
          label.textColor = .lightGray
          label.font = UIFont.systemFont(ofSize: 12)
          label.translatesAutoresizingMaskIntoConstraints = false
          label.text = "\(0) comments"
          label.textAlignment = .left
        return label
    }()
    
    
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Love"), for: .normal)
        button.setTitle("\(123456789)", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = MessagesCollectionViewCell.blueColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var commentImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"trendinCommentButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        return button
    }()
    
    
    let moreButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named:"moreDetailsIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named:"play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.tintColor = .white
        button.isHidden = false
//        button.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
        return button
    }()
    
    
    
    let postsContainerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "August")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let playButtonContaierView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        bView.layer.cornerRadius = 25
        bView.clipsToBounds = true
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
 
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.layer.cornerRadius = 4
        bView.clipsToBounds = true
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.isHidden = false
        return bView
        
    }()
    
    
    lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:50"
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
       let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.translatesAutoresizingMaskIntoConstraints = false

        return ai
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var statusImageViewHeightConstraint: NSLayoutConstraint?
    var likeButtonHeightConstraint: NSLayoutConstraint?
    var likeButtonWidthConstraint: NSLayoutConstraint?


    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    
//    func handleControlsTapped(){
//        
//        playButtonContaierView.isHidden = false
//
//        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(handleHidePlayButton), userInfo: nil, repeats: false)
//  
//        
//    }


    func handleHidePlayButton(){
        
        playButtonContaierView.isHidden = true
 
        
    }

    func setUpViews(){
        
        addSubview(profileImage)
        addSubview(optionsButton)
        addSubview(usernameLabel)
        addSubview(commentImageButton)
        addSubview(commentLabel)
        
        addSubview(likeButton)
        addSubview(dividerLine)
        addSubview(statusTextView)
        addSubview(statusContainerView)
        addSubview(verticalDividerLine)
        addSubview(videoContainerView)
        
        videoContainerView.addSubview(videoCaptionTextView)
        videoContainerView.addSubview(videoPlayerView)
        videoContainerView.addSubview(controlsContainerView)
        videoContainerView.addSubview(playButtonContaierView)

        
        

        controlsContainerView.addSubview(activityIndicator)
        playButtonContaierView.addSubview(playButton)

    
        controlsContainerView.addSubview(blurView)
        blurView.addSubview(videoDurationLabel)
        statusContainerView.addSubview(captionTextView)
        statusContainerView.addSubview(displayImageView)

        
        playButtonContaierView.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor).isActive = true
        playButtonContaierView.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor).isActive = true
        playButtonContaierView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButtonContaierView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor).isActive = true
        controlsContainerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor).isActive = true
        controlsContainerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor).isActive = true
        controlsContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    
        
        videoDurationLabel.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        videoDurationLabel.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
        videoDurationLabel.widthAnchor.constraint(equalTo: blurView.widthAnchor).isActive = true
        videoDurationLabel.heightAnchor.constraint(equalTo: blurView.heightAnchor).isActive = true
        
        
        blurView.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor , constant: -8).isActive = true
        blurView.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -8).isActive = true
        blurView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        optionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        usernameLabel.rightAnchor.constraint(equalTo: optionsButton.leftAnchor, constant: -8).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        statusTextView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0).isActive = true
        statusTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        statusTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        statusTextView.bottomAnchor.constraint(equalTo: dividerLine.topAnchor, constant: 0).isActive = true
        
        
        
        videoContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        videoContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        videoContainerView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant:  8).isActive = true
        videoContainerView.bottomAnchor.constraint(equalTo: dividerLine.topAnchor, constant:  0).isActive = true
        
    
    
        videoPlayerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor).isActive = true
        videoPlayerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor).isActive = true
        videoPlayerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor).isActive = true
//        let videoPlayerViewHeight = self.frame.width * 9 / 16
        videoPlayerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        
        videoCaptionTextView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor).isActive = true
        videoCaptionTextView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor).isActive = true
        videoCaptionTextView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor).isActive = true
        videoCaptionTextView.topAnchor.constraint(equalTo: videoContainerView.topAnchor).isActive = true

        
        
        statusContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        statusContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        statusContainerView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant:  8).isActive = true
        statusContainerView.bottomAnchor.constraint(equalTo: dividerLine.topAnchor, constant:  0).isActive = true
        
        
        dividerLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        commentLabel.leftAnchor.constraint(equalTo: commentImageButton.rightAnchor, constant: 8).isActive = true
        commentLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: verticalDividerLine.leftAnchor).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        commentImageButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        commentImageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentImageButton.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 8).isActive = true
        commentImageButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
//        var likeButtonHeightConstraint: NSLayoutConstraint?
//        var likeButtonWidthConstraint: NSLayoutConstraint?
        
        likeButton.leftAnchor.constraint(equalTo: verticalDividerLine.rightAnchor, constant: 10).isActive = true
        likeButtonWidthConstraint = likeButton.widthAnchor.constraint(equalToConstant: 100)
        likeButtonWidthConstraint?.isActive = true
        likeButtonHeightConstraint = likeButton.heightAnchor.constraint(equalToConstant: 30)
        likeButtonHeightConstraint?.isActive = true
        likeButton.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 8).isActive = true
        
        
        
        displayImageView.leftAnchor.constraint(equalTo: statusContainerView.leftAnchor).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: statusContainerView.bottomAnchor).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: statusContainerView.rightAnchor).isActive = true
        statusImageViewHeightConstraint = displayImageView.heightAnchor.constraint(equalToConstant: 300)
        statusImageViewHeightConstraint?.isActive = true
        
        
        captionTextView.leftAnchor.constraint(equalTo: statusContainerView.leftAnchor, constant: 8).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: statusContainerView.rightAnchor, constant: -8).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: statusContainerView.bottomAnchor).isActive = true
        captionTextView.topAnchor.constraint(equalTo: statusContainerView.topAnchor).isActive = true
        
        
        verticalDividerLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        verticalDividerLine.heightAnchor.constraint(equalToConstant: 20).isActive = true
        verticalDividerLine.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 15).isActive = true
        verticalDividerLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        playButton.centerXAnchor.constraint(equalTo: playButtonContaierView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: playButtonContaierView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
    }
    

    
}
