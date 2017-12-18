//
//  TimeStampHeaderReusableView.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//


import UIKit

class TimeStampHeaderReusableView: UICollectionReusableView {
    
    let timeStampContainer: UIView = {
        let containerV = UIView()
        containerV.translatesAutoresizingMaskIntoConstraints = false
        containerV.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        containerV.layer.cornerRadius = 8
        containerV.clipsToBounds = true
        return containerV
        
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Wednesday 12:40PM"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.addSubview(timeStampContainer)
        
        timeStampContainer.addSubview(timeStamp)
        
        
        timeStamp.topAnchor.constraint(equalTo: timeStampContainer.topAnchor).isActive = true
        timeStamp.bottomAnchor.constraint(equalTo: timeStampContainer.bottomAnchor).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: timeStampContainer.rightAnchor).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: timeStampContainer.leftAnchor).isActive = true
        
        timeStampContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        timeStampContainer.widthAnchor.constraint(equalToConstant: 150).isActive = true
        timeStampContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        timeStampContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
    }
    
}
