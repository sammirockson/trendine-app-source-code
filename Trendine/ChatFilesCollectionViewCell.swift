//
//  ChatFilesCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 23/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class ChatFilesCollectionViewCell: UICollectionViewCell {
    
    let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor =  UIColor.lightGray.cgColor
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
        
        displayImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        displayImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        
    }
    
   
    
}
