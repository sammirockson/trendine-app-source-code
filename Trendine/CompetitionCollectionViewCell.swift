//
//  CompetitionCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 10/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CompetitionCollectionViewCell: UICollectionViewCell {
    
    let likeButton: UIButton = {
       let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "BlackHeart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let reportButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "Report"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "commentButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let commentsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
        
    }()
    
    let likesLabel: UILabel = {
       let label = UILabel()
        label.text = "32,780,000"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
        
    }()
    
    let likeItemsContainer: UIView = {
        let bView = UIView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        return bView
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    
    let finalistsNumbersBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 4
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let countingFinalistsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let BackgroundImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = 20
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    let numbeerOfLikesImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "RedHeart")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    let captionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        addSubview(likeItemsContainer)
        addSubview(BackgroundImageView)
        addSubview(blurView)
        addSubview(finalistsNumbersBlurView)
        
        blurView.addSubview(profileImageView)
        blurView.addSubview(captionLabel)
        
        finalistsNumbersBlurView.addSubview(countingFinalistsLabel)
        
        countingFinalistsLabel.centerXAnchor.constraint(equalTo: finalistsNumbersBlurView.centerXAnchor).isActive = true
        countingFinalistsLabel.centerYAnchor.constraint(equalTo: finalistsNumbersBlurView.centerYAnchor).isActive = true
        countingFinalistsLabel.widthAnchor.constraint(equalToConstant: 18)
        countingFinalistsLabel.heightAnchor.constraint(equalToConstant: 18)
        
        
        likeItemsContainer.addSubview(likeButton)
        likeItemsContainer.addSubview(reportButton)
        likeItemsContainer.addSubview(likesLabel)
        likeItemsContainer.addSubview(commentButton)
        likeItemsContainer.addSubview(numbeerOfLikesImageView)
        likeItemsContainer.addSubview(commentsCountLabel)
        
        
        reportButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 30).isActive = true
        reportButton.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        reportButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        commentsCountLabel.leftAnchor.constraint(equalTo: commentButton.rightAnchor , constant: 5).isActive = true
        commentsCountLabel.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        commentsCountLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        commentsCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        numbeerOfLikesImageView.rightAnchor.constraint(equalTo: likeItemsContainer.rightAnchor, constant: -5).isActive = true
        numbeerOfLikesImageView.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        numbeerOfLikesImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        numbeerOfLikesImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        commentButton.leftAnchor.constraint(equalTo: likeItemsContainer.leftAnchor, constant: 8).isActive = true
        commentButton.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        
        finalistsNumbersBlurView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -5).isActive = true
        finalistsNumbersBlurView.bottomAnchor.constraint(equalTo: blurView.topAnchor, constant: -5).isActive = true
        finalistsNumbersBlurView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        finalistsNumbersBlurView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        likesLabel.leftAnchor.constraint(equalTo: reportButton.rightAnchor, constant: 5).isActive = true
        likesLabel.rightAnchor.constraint(equalTo: numbeerOfLikesImageView.leftAnchor).isActive = true
        likesLabel.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        likesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        likeButton.leftAnchor.constraint(equalTo: commentsCountLabel.rightAnchor, constant: 8).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: likeItemsContainer.centerYAnchor).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        likeItemsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        likeItemsContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        likeItemsContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeItemsContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        BackgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        BackgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        BackgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        BackgroundImageView.bottomAnchor.constraint(equalTo: likeItemsContainer.topAnchor).isActive = true
    
        
        blurView.bottomAnchor.constraint(equalTo: likeItemsContainer.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        blurView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 4).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor , constant: 4).isActive = true
        captionLabel.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true
        
        
        
    }
    
}
