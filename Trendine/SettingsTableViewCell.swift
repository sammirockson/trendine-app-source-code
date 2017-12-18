//
//  SettingsTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 8/8/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
        let settingsLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        return label
        
    }()
    
    let iConImage: UIImageView = {
        let image  = UIImageView()
        image.image = UIImage(named: "personplaceholder")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 13
        image.clipsToBounds = true
        return image
        
    }()
    
    let numberOfNotificationsImageView: UIImageView = {
        let image  = UIImageView()
        image.image = UIImage(named: "NumberOfNotificationBG")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.isHidden = true
        return image
        
    }()
    
    
    let countNotificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
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
        
        setUpViews()

    }
    
    func setUpViews(){
        
        addSubview(settingsLabel)
        addSubview(iConImage)
        addSubview(numberOfNotificationsImageView)
        
        numberOfNotificationsImageView.addSubview(countNotificationLabel)
        
        
        countNotificationLabel.centerXAnchor.constraint(equalTo: numberOfNotificationsImageView.centerXAnchor).isActive = true
        countNotificationLabel.centerYAnchor.constraint(equalTo: numberOfNotificationsImageView.centerYAnchor).isActive = true
        countNotificationLabel.widthAnchor.constraint(equalTo: numberOfNotificationsImageView.widthAnchor).isActive = true
        countNotificationLabel.heightAnchor.constraint(equalTo: numberOfNotificationsImageView.heightAnchor).isActive = true
        
        
        numberOfNotificationsImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        numberOfNotificationsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        numberOfNotificationsImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfNotificationsImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        iConImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant:  17).isActive = true
        iConImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iConImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        iConImage.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        
        settingsLabel.leftAnchor.constraint(equalTo: iConImage.rightAnchor, constant:  8).isActive = true
        settingsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        settingsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }

}
