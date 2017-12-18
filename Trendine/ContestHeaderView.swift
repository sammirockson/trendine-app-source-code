//
//  ContestHeaderView.swift
//  Trendin
//
//  Created by Rockson on 10/2/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class ContestHeaderView: UICollectionReusableView {
    
      let PopToSelfieContestImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "PhotographyContest")
        img.layer.cornerRadius = 2
        img.clipsToBounds = true
        return img
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpViews(){
        
        
        self.addSubview(PopToSelfieContestImageView)
        
        PopToSelfieContestImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        PopToSelfieContestImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        PopToSelfieContestImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        PopToSelfieContestImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
    
}
