//
//  AddStickersCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class AddStickersCollectionViewCell: UICollectionViewCell {
    
    let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.addSubview(displayImageView)
        
        displayImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        displayImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
    }
    
}
