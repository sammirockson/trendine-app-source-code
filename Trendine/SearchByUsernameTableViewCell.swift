//
//  SearchByUsernameTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 15/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class SearchByUsernameTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "personPlaceholder")
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Rockson"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
        
    }()
    
    
    let addButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = MessagesCollectionViewCell.blueColor
        btn.titleLabel?.textColor = .white
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.clipsToBounds = true
        btn.setTitle("Add Friend", for: .normal)
        btn.isHidden = true
        return btn
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUpViews()
        
    }
    

    
    func setUpViews(){
        
        self.addSubview(profileImageView)
        self.addSubview(usernameLabel)
        self.addSubview(addButton)
        
        
        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30)
        
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    

}
