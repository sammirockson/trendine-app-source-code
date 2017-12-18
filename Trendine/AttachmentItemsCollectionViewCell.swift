//
//  AttachmentItemsCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class AttachmetItemsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        return imageV
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
        
        self.addSubview(imageView)
        
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
}
