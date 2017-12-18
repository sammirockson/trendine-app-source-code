//
//  PrivacyDetailsTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 08/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class PrivacyDetailsTableViewCell: UITableViewCell {
    
    let findMeByPhoneNumberSwitch: UISwitch = {
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
       
        self.addSubview(findMeByPhoneNumberSwitch)
        
        findMeByPhoneNumberSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        findMeByPhoneNumberSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        findMeByPhoneNumberSwitch.widthAnchor.constraint(equalToConstant: 30).isActive = true
        findMeByPhoneNumberSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
