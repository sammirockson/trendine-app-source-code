//
//  NotificationSettingsTableViewCell.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class NotificationSettingsTableViewCell: UITableViewCell {

   
    let switchButton: UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
        
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
    
    
    func setUpViews(){
        
        self.addSubview(switchButton)
        
        switchButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
