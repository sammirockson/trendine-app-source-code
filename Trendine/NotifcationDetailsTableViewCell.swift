//
//  NotifcationDetailsTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 26/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class NotifcationDetailsTableViewCell: UITableViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Rockson"
        label.textColor = .black
        return label
        
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
//        label.backgroundColor = .red
        return label
        
    }()
    
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.image = UIImage(named: "personplaceholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = 5
        imageV.clipsToBounds = true
        return imageV
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUpViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpViews(){
        
      self.addSubview(profileImageView)
      self.addSubview(timeStampLabel)
      self.addSubview(usernameLabel)
      self.addSubview(commentLabel)
        
        
        commentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        usernameLabel.rightAnchor.constraint(equalTo: timeStampLabel.leftAnchor, constant: -8).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30)
        
//        usernameLabel.backgroundColor = .blue
        
        
        timeStampLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        timeStampLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        timeStampLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }

}
