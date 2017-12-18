//
//  CommentCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 10/7/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = 5
        imageV.clipsToBounds = true
        return imageV
        
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Rockson"
        label.textColor = .black
//        label.backgroundColor = .red
        return label
        
    }()
    
    let commentLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "comment there"
        label.textColor = .black
        label.numberOfLines = 0
        return label
        
    }()
    
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "30mins"
        label.textAlignment = .right
        return label
        
    }()
    
//    let topThinLine: UIView = {
//       let lineV = UIView()
//        lineV.translatesAutoresizingMaskIntoConstraints = false
//        lineV.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        return lineV
//        
//    }()
    
    let bottomThinLine: UIView = {
        let lineV = UIView()
        lineV.translatesAutoresizingMaskIntoConstraints = false
        lineV.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return lineV
        
    }()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
       
//      self.addSubview(topThinLine)
      self.addSubview(bottomThinLine)
      self.addSubview(profileImageView)
        
      self.addSubview(usernameLabel)
      self.addSubview(commentLabel)
      self.addSubview(timeStampLabel)
        
//        topThinLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        topThinLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        topThinLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
//        topThinLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bottomThinLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomThinLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomThinLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        bottomThinLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        timeStampLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeStampLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStampLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        commentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: timeStampLabel.leftAnchor, constant: -5).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
}
