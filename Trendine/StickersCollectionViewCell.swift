//
//  StickersCollectionViewCell.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    
    let displayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.layer.borderWidth = 1
        //        imageView.layer.borderColor =  UIColor.lightGray.cgColor
        return imageView
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    let saveStickerButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Download"), for: .normal)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
        
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
       // self.addSubview(blurView)
        
        displayImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        displayImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        displayImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        displayImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
      //  blurView.addSubview(saveStickerButton)
        
        //saveStickerButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
       // saveStickerButton.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
      //  saveStickerButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, constant: -6).isActive = true
      //  saveStickerButton.heightAnchor.constraint(equalTo: blurView.heightAnchor, constant: 6).isActive = true
        
      //  blurView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true
       // blurView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    // blurView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
     //   blurView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
       
        
    }
    
    
    
}
