//
//  ChangeProfileInfoTableViewCell.swift
//  Trendin
//
//  Created by Rockson on 06/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class ChangeProfileInfoTableViewCell: UITableViewCell {

 
        let settingsLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
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

        
        
        settingsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant:  15).isActive = true
        settingsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        settingsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }

}
