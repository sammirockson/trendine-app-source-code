//
//  BuyPointsCollectionViewCell.swift
//  Trendin
//
//  Created by Rockson on 31/10/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class BuyPointsCollectionViewCell: UICollectionViewCell {
    
    let displayImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor =  UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1).cgColor
        return imageView
        
    }()
    
    
    
    
    let amountLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
        
    }()
    
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
        
    }()
    
    let buyButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
        btn.setTitle("Purchase", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true

        return btn
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
        
        self.addSubview(displayImageView)
        self.addSubview(pointsLabel)
        self.addSubview(buyButton)
        self.addSubview(amountLabel)
        
        amountLabel.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 5).isActive = true
        amountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        amountLabel.widthAnchor.constraint(equalTo: displayImageView.widthAnchor).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pointsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        pointsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pointsLabel.widthAnchor.constraint(equalTo: displayImageView.widthAnchor).isActive = true
        pointsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buyButton.bottomAnchor.constraint(equalTo: displayImageView.bottomAnchor, constant: -10).isActive = true
        buyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buyButton.widthAnchor.constraint(equalTo: displayImageView.widthAnchor, constant: -40).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        displayImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        displayImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
    }
    
}
