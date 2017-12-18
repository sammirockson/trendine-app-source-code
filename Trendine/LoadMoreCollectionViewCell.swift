//
//  LoadMoreCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 19/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {
    
    let activityIndicator: UIActivityIndicatorView = {
       let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        ac.translatesAutoresizingMaskIntoConstraints = false
        return ac
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       self.setUpViews()
        
        
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
