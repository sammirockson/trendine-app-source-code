//
//  CountryCodesTableVCell.swift
//  Trendin
//
//  Created by Rockson on 8/1/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CountryCodesTableVCell: UITableViewCell {
    
    let countryCode: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
    }()
    
    let countries: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpViews()
    }
    
    func setUpViews(){
        
      addSubview(countryCode)
      addSubview(countries)
        
        
    countryCode.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8).isActive = true
    countryCode.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    countryCode.widthAnchor.constraint(equalToConstant: 100).isActive = true
    countryCode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    countries.leftAnchor.constraint(equalTo: self.leftAnchor, constant:  8).isActive = true
    countries.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    countries.rightAnchor.constraint(equalTo: countryCode.leftAnchor).isActive = true
    countries.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
     
    }

}
