//
//  LikedUsersTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 07/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class LikedUsersTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = 20
        imageV.clipsToBounds = true
        imageV.backgroundColor = .red
        return imageV
        
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = ""
        label.textColor = .black
        //        label.backgroundColor = .red
        return label
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setUpViews(){
        
      self.addSubview(profileImageView)
      self.addSubview(usernameLabel)
        
    
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive  = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
    }
    
    
}
